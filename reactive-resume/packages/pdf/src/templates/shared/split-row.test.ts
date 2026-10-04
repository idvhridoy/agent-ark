import { describe, expect, it } from "vitest";
import { hasSplitRowText } from "./split-row";

describe("hasSplitRowText", () => {
	it("returns true only for non-empty text", () => {
		expect(hasSplitRowText("2019 - 2024")).toBe(true);
		expect(hasSplitRowText("   ")).toBe(false);
		expect(hasSplitRowText(undefined)).toBe(false);
	});
});
