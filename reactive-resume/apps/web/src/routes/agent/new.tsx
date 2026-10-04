import { createFileRoute } from "@tanstack/react-router";
import z from "zod";
import { NewThreadSetup } from "./-components/new-thread-setup";
import { AgentThreadSidebar } from "./-components/thread-sidebar";

const searchSchema = z.object({ resumeId: z.string().optional() });

export const Route = createFileRoute("/agent/new")({
	component: RouteComponent,
	validateSearch: searchSchema,
});

function RouteComponent() {
	const { resumeId } = Route.useSearch();

	return (
		<div className="flex h-svh min-w-0 flex-col overflow-hidden bg-background lg:flex-row">
			<div className="h-72 min-h-0 shrink-0 lg:h-auto lg:w-72">
				<AgentThreadSidebar className="border-e-0 border-b lg:border-e lg:border-b-0" />
			</div>

			<main className="grid min-w-0 flex-1 overflow-auto">
				<NewThreadSetup resumeId={resumeId} />
			</main>
		</div>
	);
}
