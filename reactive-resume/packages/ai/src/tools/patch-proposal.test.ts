import { describe, expect, it } from "vitest";
import {
	normalizeResumePatchProposals,
	resumePatchProposalToolInputSchema,
	resumePatchProposalToolOutputSchema,
} from "./patch-proposal";

describe("resume patch proposals", () => {
	it("requires at least one operation per proposal", () => {
		const result = resumePatchProposalToolOutputSchema.safeParse({
			proposals: [
				{
					id: "proposal-1",
					title: "Empty proposal",
					operations: [],
				},
			],
		});

		expect(result.success).toBe(false);
	});

	it("normalizes tool input without requiring model-generated ids", () => {
		const result = resumePatchProposalToolInputSchema.safeParse({
			proposals: [
				{
					title: "Rewrite summary",
					summary: "Make the summary more direct.",
					operations: [{ op: "replace", path: "/summary/content", value: "<p>Focused product engineer.</p>" }],
				},
			],
		});

		expect(result.success).toBe(true);
	});

	it("normalizes base versions as JSON-safe ISO timestamps", () => {
		const proposals = normalizeResumePatchProposals(
			{
				proposals: [
					{
						title: "Rewrite summary",
						operations: [{ op: "replace", path: "/summary/content", value: "<p>Focused product engineer.</p>" }],
					},
				],
			},
			new Date("2026-05-10T06:38:27.093Z"),
		);

		const result = resumePatchProposalToolOutputSchema.parse({ proposals });

		expect(result.proposals[0]?.baseUpdatedAt).toBe("2026-05-10T06:38:27.093Z");
	});
});
