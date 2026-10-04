// @vitest-environment happy-dom

import { cleanup, render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, expect, it, vi } from "vitest";
import { i18n } from "@lingui/core";
import { I18nProvider } from "@lingui/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { createMemoryHistory, createRootRoute, createRouter, RouterProvider } from "@tanstack/react-router";

const mocks = vi.hoisted(() => ({ list: vi.fn() }));

vi.mock("@/libs/orpc/client", () => ({
	orpc: {
		applications: {
			list: { queryOptions: () => ({ queryKey: ["applications"], queryFn: mocks.list }) },
			tags: { queryOptions: () => ({ queryKey: ["tags"], queryFn: async () => [] }) },
		},
	},
}));
vi.mock("@/features/applications/components/application-detail-sheet", () => ({ ApplicationDetailSheet: () => null }));
vi.mock("@/features/applications/components/application-form-sheet", () => ({ ApplicationFormSheet: () => null }));
vi.mock("@/features/applications/components/export-applications-sheet", () => ({
	ExportApplicationsSheet: () => null,
}));
vi.mock("@/features/applications/components/import-applications-sheet", () => ({
	ImportApplicationsSheet: () => null,
}));
vi.mock("@/features/applications/components/board", () => ({ ApplicationBoard: () => null }));
vi.mock("@/features/applications/components/insights-view", () => ({ ApplicationInsights: () => null }));
vi.mock("../-components/header", () => ({ DashboardHeader: () => null }));

type TableProps = { applications: { id: string; company: string }[] };
vi.mock("@/features/applications/components/table-view", () => ({
	ApplicationTable: ({ applications }: TableProps) => (
		<ul aria-label="Applications">
			{applications.map((application) => (
				<li key={application.id}>{application.company}</li>
			))}
		</ul>
	),
}));

import { Route } from "./index";

beforeEach(() => {
	vi.restoreAllMocks();
	vi.clearAllMocks();
	i18n.loadAndActivate({ locale: "en-US", messages: {} });
	mocks.list.mockResolvedValue([
		{ id: "one", company: "Acme", role: "Engineer", tags: [], archived: false },
		{ id: "two", company: "Example", role: "Designer", tags: [], archived: false },
		{ id: "archived", company: "Archived company", role: "Engineer", tags: [], archived: true },
	]);
});

async function renderApplications(url: string) {
	const rootRoute = createRootRoute();
	const routeOptions = { ...Route.options, path: "/dashboard/applications/", getParentRoute: () => rootRoute };
	const routeTree = rootRoute.addChildren([Route.update(routeOptions)]);
	const router = createRouter({ routeTree, history: createMemoryHistory({ initialEntries: [url] }) });
	const queryClient = new QueryClient({ defaultOptions: { queries: { retry: false } } });
	await router.load();
	render(
		<QueryClientProvider client={queryClient}>
			<I18nProvider i18n={i18n}>
				<RouterProvider router={router} />
			</I18nProvider>
		</QueryClientProvider>,
	);
	await screen.findByPlaceholderText("Search applications…");
	return router;
}

it("clears a URL-seeded search without restoring it on reload", async () => {
	const router = await renderApplications(
		'/dashboard/applications/?search=no-such-company&tags=["missing"]&archived=true&view=table&sort=company',
	);
	expect(screen.getByPlaceholderText("Search applications…")).toHaveValue("no-such-company");
	await userEvent.click(screen.getByRole("button", { name: "Clear filters" }));

	expect(screen.getByPlaceholderText("Search applications…")).toHaveValue("");
	expect(await screen.findByText("Acme")).toBeVisible();
	expect(screen.getByText("Example")).toBeVisible();
	expect(screen.queryByText("Archived company")).not.toBeInTheDocument();
	await waitFor(() => expect(router.state.location.search).toEqual({ view: "table", sort: "company" }));

	const reloadUrl = router.history.location.href;
	cleanup();
	await renderApplications(reloadUrl);
	expect(screen.getByPlaceholderText("Search applications…")).toHaveValue("");
	expect(screen.getByText("Acme")).toBeVisible();
	expect(screen.getByText("Example")).toBeVisible();
	expect(screen.queryByRole("button", { name: "Clear filters" })).not.toBeInTheDocument();
});

it("filters typed company and role searches without navigating or refetching", async () => {
	const router = await renderApplications("/dashboard/applications/?view=table&sort=company");
	const navigate = vi.spyOn(router, "navigate");
	const url = router.history.location.href;
	const input = screen.getByPlaceholderText("Search applications…");

	await userEvent.type(input, "acme");
	expect(screen.getByText("Acme")).toBeVisible();
	expect(screen.queryByText("Example")).not.toBeInTheDocument();
	await userEvent.clear(input);
	await userEvent.type(input, "designer");
	expect(screen.getByText("Example")).toBeVisible();
	expect(screen.queryByText("Acme")).not.toBeInTheDocument();
	expect(navigate).not.toHaveBeenCalled();
	expect(router.history.location.href).toBe(url);
	expect(mocks.list).toHaveBeenCalledTimes(1);
});
