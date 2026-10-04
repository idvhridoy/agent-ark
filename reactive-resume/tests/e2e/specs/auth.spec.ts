import { loginViaUi, logoutViaUi, registerViaUi } from "../fixtures/auth";
import { expect, test } from "../fixtures/test";

test("registers and logs in with email credentials", async ({ page, account }) => {
	await registerViaUi(page, account);
	await expect(page.getByRole("heading", { name: "Resumes" })).toBeVisible();

	await logoutViaUi(page, account);
	await expect(page.getByRole("heading", { name: "Sign in to your account" })).toBeVisible();

	await loginViaUi(page, account);
	await expect(page.getByRole("heading", { name: "Resumes" })).toBeVisible();
});
