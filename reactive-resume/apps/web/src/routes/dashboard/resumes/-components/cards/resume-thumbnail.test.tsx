// @vitest-environment happy-dom

import type { ComponentProps } from "react";
import { act, render, waitFor } from "@testing-library/react";
import { afterEach, beforeEach, expect, it, vi } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { sampleResumeData } from "@reactive-resume/schema/resume/sample";
import { ResumeThumbnail } from "./resume-thumbnail";

const mocks = vi.hoisted(() => ({
	inView: true,
	toPdf: vi.fn(async () => new Blob(["pdf"])),
	toImage: vi.fn(async (_pdf: Blob, size?: { width: number; height: number }) => `blob:${size?.width}x${size?.height}`),
}));

vi.mock("motion/react", () => ({ useInView: () => mocks.inView }));
vi.mock("@/features/resume/export/pdf-document", () => ({ createResumePdfBlob: mocks.toPdf }));
vi.mock("@/features/resume/preview/pdf-thumbnail", () => ({ createPdfFirstPageImageUrl: mocks.toImage }));
vi.mock("@/libs/orpc/client", () => ({
	orpc: {
		resume: {
			getById: {
				queryOptions: () => ({
					queryKey: ["resume-data"],
					queryFn: async () => ({ data: sampleResumeData }),
				}),
			},
		},
	},
}));

const resume: ComponentProps<typeof ResumeThumbnail>["resume"] = {
	id: "thumbnail-test",
	name: "Resume",
	slug: "resume",
	tags: [],
	isLocked: false,
	isPublic: false,
	showDownloadButtons: true,
	createdAt: new Date(0),
	updatedAt: new Date(0),
};
let resize: () => void;
let media: EventTarget;
let width = 270;
let height = 382;
let currentResume = resume;

beforeEach(() => {
	mocks.inView = true;
	mocks.toPdf.mockClear();
	mocks.toImage.mockClear();
	width = 270;
	height = 382;
	currentResume = resume;
	vi.spyOn(HTMLElement.prototype, "clientWidth", "get").mockImplementation(() => width);
	vi.spyOn(HTMLElement.prototype, "clientHeight", "get").mockImplementation(() => height);
	vi.stubGlobal("devicePixelRatio", 2);
	vi.stubGlobal(
		"ResizeObserver",
		class {
			constructor(callback: () => void) {
				resize = callback;
			}
			observe() {}
			disconnect() {}
		},
	);
	vi.spyOn(window, "matchMedia").mockImplementation(() => {
		media = new EventTarget();
		return media as MediaQueryList;
	});
	vi.spyOn(URL, "revokeObjectURL").mockImplementation(() => {});
});

afterEach(() => {
	vi.restoreAllMocks();
	vi.unstubAllGlobals();
});

function setup() {
	const client = new QueryClient({
		defaultOptions: { queries: { retry: false, staleTime: Number.POSITIVE_INFINITY } },
	});
	const ui = () => (
		<QueryClientProvider client={client}>
			<ResumeThumbnail resume={currentResume} isLocked={false} />
		</QueryClientProvider>
	);
	const result = render(ui());
	const image = () => result.container.querySelector<HTMLElement>("[style*='background-image']")?.style.backgroundImage;
	return { ...result, client, image, refresh: () => result.rerender(ui()) };
}

it("upgrades a cached image after growth and keeps it visible until replacement is ready", async () => {
	const view = setup();
	await waitFor(() => expect(view.image()).toContain("blob:576x768"));
	let finish!: (url: string) => void;
	mocks.toImage.mockImplementationOnce(
		() =>
			new Promise<string>((resolve) => {
				finish = resolve;
			}),
	);
	act(() => {
		width = 607;
		height = 859;
		resize();
	});
	await waitFor(() => expect(mocks.toImage).toHaveBeenCalledTimes(2));
	expect(view.image()).toContain("blob:576x768");
	expect(URL.revokeObjectURL).not.toHaveBeenCalled();
	expect(mocks.toImage.mock.calls[1]?.[1]).toEqual({ width: 1216, height: 1728 });
	await act(async () => finish("blob:1216x1728"));
	await waitFor(() => expect(view.image()).toContain("blob:1216x1728"));
	expect(URL.revokeObjectURL).toHaveBeenCalledWith("blob:576x768");
	act(() => {
		width = 295;
		height = 418;
		resize();
	});
	await new Promise((resolve) => setTimeout(resolve, 250));
	expect(view.image()).toContain("blob:1216x1728");
	expect(mocks.toImage).toHaveBeenCalledTimes(2);
	view.unmount();
	expect(URL.revokeObjectURL).not.toHaveBeenCalledWith("blob:1216x1728");
});

it("reuses rendered image after card hide and remount", async () => {
	const view = setup();
	await waitFor(() => expect(view.image()).toContain("blob:576x768"));
	view.unmount();

	const remounted = render(
		<QueryClientProvider client={view.client}>
			<ResumeThumbnail resume={resume} isLocked={false} />
		</QueryClientProvider>,
	);
	await waitFor(() =>
		expect(
			remounted.container.querySelector<HTMLElement>("[style*='background-image']")?.style.backgroundImage,
		).toContain("blob:576x768"),
	);
	expect(mocks.toPdf).toHaveBeenCalledTimes(1);
	expect(mocks.toImage).toHaveBeenCalledTimes(1);
	remounted.unmount();
});

it("revokes rendered images when query is evicted or replaced", async () => {
	mocks.toImage.mockResolvedValueOnce("blob:original").mockResolvedValueOnce("blob:updated");
	const view = setup();
	await waitFor(() => expect(view.image()).toContain("blob:original"));
	currentResume = { ...resume, updatedAt: new Date(1000) };
	view.refresh();
	await waitFor(() => expect(view.image()).toContain("blob:updated"));
	expect(URL.revokeObjectURL).toHaveBeenCalledExactlyOnceWith("blob:original");

	view.client.removeQueries({ queryKey: ["resume-thumbnail"] });
	expect(URL.revokeObjectURL).toHaveBeenCalledTimes(2);
	expect(URL.revokeObjectURL).toHaveBeenLastCalledWith("blob:updated");
	view.unmount();
});

it.each([true, false])("revokes same-query replacements after invalidation (mounted: %s)", async (mounted) => {
	mocks.toImage.mockResolvedValueOnce("blob:original");
	const view = setup();
	await waitFor(() => expect(view.image()).toContain("blob:original"));
	const query = view.client.getQueryCache().find({ queryKey: ["resume-thumbnail"], exact: false, type: "active" });
	expect(query?.state.data).toBe("blob:original");
	let finish!: (url: string) => void;
	mocks.toImage.mockImplementationOnce(
		() =>
			new Promise<string>((resolve) => {
				finish = resolve;
			}),
	);
	if (!mounted) view.unmount();
	let invalidation!: Promise<void>;
	act(() => {
		invalidation = view.client.invalidateQueries({ refetchType: mounted ? "active" : "all" });
	});
	await waitFor(() => expect(mocks.toImage).toHaveBeenCalledTimes(2));
	expect(query?.state.data).toBe("blob:original");
	if (mounted) expect(view.image()).toContain("blob:original");
	expect(URL.revokeObjectURL).not.toHaveBeenCalled();
	await act(async () => {
		finish("blob:replacement");
		await invalidation;
	});
	await waitFor(() => expect(query?.state.data).toBe("blob:replacement"));
	if (mounted) await waitFor(() => expect(view.image()).toContain("blob:replacement"));
	expect(URL.revokeObjectURL).toHaveBeenCalledExactlyOnceWith("blob:original");
	view.unmount();
	expect(URL.revokeObjectURL).not.toHaveBeenCalledWith("blob:replacement");
	view.client.removeQueries({ queryKey: ["resume-thumbnail"] });
	expect(URL.revokeObjectURL).toHaveBeenCalledTimes(2);
	expect(URL.revokeObjectURL).toHaveBeenLastCalledWith("blob:replacement");
});

it("does not revoke URLs owned by unrelated queries", async () => {
	const view = setup();
	await waitFor(() => expect(view.image()).toContain("blob:576x768"));
	view.client.setQueryData(["other-image"], "blob:other-original");
	view.client.setQueryData(["other-image"], "blob:other-replacement");
	view.client.removeQueries({ queryKey: ["other-image"] });
	expect(URL.revokeObjectURL).not.toHaveBeenCalled();
	view.unmount();
});

it("upgrades after a DPR change even when CSS dimensions do not change", async () => {
	const view = setup();
	await waitFor(() => expect(view.image()).toContain("blob:576x768"));
	act(() => {
		vi.stubGlobal("devicePixelRatio", 3);
		media.dispatchEvent(new Event("change"));
	});
	await waitFor(() => expect(view.image()).toContain("blob:832x1152"));
});

it("does not generate thumbnails before an offscreen card enters view", async () => {
	mocks.inView = false;
	const view = setup();
	await act(async () => {});
	expect(view.image()).toBeUndefined();
	expect(mocks.toPdf).not.toHaveBeenCalled();
	mocks.inView = true;
	view.refresh();
	await waitFor(() => expect(view.image()).toContain("blob:576x768"));
	mocks.inView = false;
	view.refresh();
	act(() => {
		width = 607;
		height = 859;
	});
	await new Promise((resolve) => setTimeout(resolve, 250));
	expect(mocks.toImage).toHaveBeenCalledTimes(1);
	mocks.inView = true;
	view.refresh();
	await waitFor(() => expect(view.image()).toContain("blob:1216x1728"));
});
