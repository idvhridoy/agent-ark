import { describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => ({
	auth: {},
	env: {
		APP_URL: "https://rxresu.me",
	},
}));

vi.mock("@better-auth/oauth-provider", () => ({
	oauthProviderAuthServerMetadata: vi.fn(() => vi.fn(() => Response.json({}))),
	oauthProviderOpenIdConfigMetadata: vi.fn(() => vi.fn(() => Response.json({}))),
}));

vi.mock("@reactive-resume/auth/config", () => ({
	auth: mocks.auth,
}));

vi.mock("@reactive-resume/env/server", () => ({
	env: mocks.env,
}));

vi.mock("@reactive-resume/mcp/server-card", () => ({
	buildMcpServerCard: vi.fn(() => ({})),
}));

vi.mock("../app-version", () => ({
	appVersion: "test",
}));

describe("handleOAuthProtectedResource", () => {
	it("advertises the mounted auth issuer as the authorization server", async () => {
		const { handleOAuthProtectedResource } = await import("./metadata");

		const response = await handleOAuthProtectedResource();

		await expect(response.json()).resolves.toMatchObject({
			resource: "https://rxresu.me",
			authorization_servers: ["https://rxresu.me/api/auth"],
		});
	});
});
