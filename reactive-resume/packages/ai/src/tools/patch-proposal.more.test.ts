import { describe, expect, it } from "vitest";
import { normalizeResumePatchProposals } from "./patch-proposal";

describe("normalizeResumePatchProposals", () => {
	it("attaches a baseUpdatedAt to every proposal", () => {
		const at = new Date("2024-01-01T00:00:00Z");
		const proposals = normalizeResumePatchProposals(
			{
				proposals: [
					{
						title: "A",
						operations: [{ op: "replace", path: "/basics/name", value: "x" }],
					},
					{
						title: "B",
						operations: [{ op: "replace", path: "/basics/name", value: "y" }],
					},
				],
			},
			at,
		);

		for (const p of proposals) {
			expect(p.baseUpdatedAt).toBe(at.toISOString());
		}
	});

	it("preserves order of input proposals", () => {
		const proposals = normalizeResumePatchProposals(
			{
				proposals: [
					{ title: "first", operations: [{ op: "replace", path: "/basics/name", value: "1" }] },
					{ title: "second", operations: [{ op: "replace", path: "/basics/name", value: "2" }] },
					{ title: "third", operations: [{ op: "replace", path: "/basics/name", value: "3" }] },
				],
			},
			new Date(),
		);

		expect(proposals.map((p) => p.title)).toEqual(["first", "second", "third"]);
	});
});
