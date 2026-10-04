import { createSampleResumeFromDashboard, openSidebarSection } from "../fixtures/resume";
import { expect, test } from "../fixtures/test";

test("switches the resume template and persists the choice", async ({ authPage: page }, testInfo) => {
	await createSampleResumeFromDashboard(page, testInfo);

	await openSidebarSection(page, "Template");
	// Sample resumes start on Azurill; its preview button opens the gallery
	await page.getByRole("button", { name: "Azurill", exact: true }).click();
	const gallery = page.getByRole("dialog", { name: "Template Gallery" });
	await expect(gallery).toBeVisible();

	const savePromise = page.waitForResponse((response) => {
		if (!response.url().includes("/api/rpc")) return false;
		if (response.request().method() !== "POST") return false;
		if (!response.ok()) return false;
		return (response.request().postData() ?? "").includes("bronzor");
	});
	await gallery.getByRole("img", { name: "Bronzor", exact: true }).click();
	await savePromise;
	await page.keyboard.press("Escape");

	// After a reload the Template section previews the newly selected template
	await page.reload();
	await openSidebarSection(page, "Template");
	await expect(page.getByRole("img", { name: "Bronzor", exact: true })).toBeVisible();
});
