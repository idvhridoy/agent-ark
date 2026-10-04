import { describe, expect, it } from "vitest";
import { updateProviderInput } from "./inputs";

describe("AI provider router input", () => {
	it("does not default baseURL on switch-only updates", () => {
		expect(updateProviderInput.parse({ id: "provider-1", enabled: false })).not.toHaveProperty("baseURL");
	});
});
