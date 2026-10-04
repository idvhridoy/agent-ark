// @vitest-environment happy-dom

import { readFileSync } from "node:fs";
import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { LoadingScreen } from "./loading-screen";

describe("LoadingScreen", () => {
	it("renders the Reactive Resume icon and spinner", () => {
		render(<LoadingScreen />);

		const icons = screen.getAllByAltText("Reactive Resume");
		expect(icons).toHaveLength(2);
		expect(icons.map((icon) => icon.getAttribute("src"))).toEqual(["/icon/dark.svg", "/icon/light.svg"]);
		expect(screen.getByLabelText("Loading")).toBeInTheDocument();
	});

	it("uses the same icon asset as the initial HTML loader", () => {
		const html = readFileSync("index.html", "utf8");

		expect(html).toContain('src="/icon/dark.svg"');
		expect(html).not.toContain('src="/logo/dark.svg"');
	});

	it("fills the viewport (fixed inset-0)", () => {
		const { container } = render(<LoadingScreen />);

		const wrapper = container.firstChild as HTMLElement;
		expect(wrapper.className).toContain("fixed");
		expect(wrapper.className).toContain("inset-0");
	});
});
