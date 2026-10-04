import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { describe, expect, it } from "vitest";
import { templateSchema } from "@reactive-resume/schema/templates";

const templatePages = templateSchema.options.map(
	(template) =>
		[
			template,
			fileURLToPath(new URL(`./templates/${template}/${capitalize(template)}Page.tsx`, import.meta.url)),
		] as const,
);

function capitalize(template: string): string {
	return template.charAt(0).toUpperCase() + template.slice(1);
}

describe("RTL PDF fixture", () => {
	it.each(templatePages)("%s wires shared RTL helpers and alignEnd slot", (_template, pagePath) => {
		const source = readFileSync(pagePath, "utf8");

		// ponytail: RTL helpers and alignEnd moved to the shared template base; either direct or via useTemplateBase counts.
		expect(source.includes("createRtlStyleHelpers") || source.includes("useTemplateBase")).toBe(true);
		expect(
			source.includes("alignEnd") || source.includes("createBaseTemplateStyles") || source.includes("useTemplateBase"),
		).toBe(true);
		expect(source).not.toContain("alignRight");
		expect(source).not.toContain('from "@reactive-resume/utils/locale"');
	});
});
