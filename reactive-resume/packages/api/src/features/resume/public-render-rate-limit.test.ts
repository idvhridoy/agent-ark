import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { createPublicRenderRateLimiter } from "./public-render-rate-limit";

beforeEach(() => {
	vi.useFakeTimers();
	vi.setSystemTime(0);
});

afterEach(() => {
	vi.useRealTimers();
});

describe("public render rate limit", () => {
	it("cannot reset a transport client's budget by rotating forwarding headers", async () => {
		const limiter = createPublicRenderRateLimiter({ capacity: 1, refillWindowMs: 60_000 });
		const first = {
			trustedClient: "203.0.113.9",
			requestHeaders: new Headers({
				"cf-connecting-ip": "198.51.100.1",
				"x-forwarded-for": "198.51.100.2",
			}),
			resumeId: "resume-1",
		};
		const rotated = {
			...first,
			requestHeaders: new Headers({
				"cf-connecting-ip": "198.51.100.3",
				"x-forwarded-for": "198.51.100.4",
			}),
		};

		await limiter.consume(first);

		await expect(limiter.consume(rotated)).rejects.toMatchObject({ code: "RATE_LIMIT_EXCEEDED", status: 429 });
	});

	it("shares one IP-and-resume token bucket across projection and PDF consumers", async () => {
		const limiter = createPublicRenderRateLimiter({ capacity: 2, refillWindowMs: 60_000 });
		const input = { trustedClient: "203.0.113.7", resumeId: "resume-1" };

		await limiter.consume(input);
		await limiter.consume(input);

		await expect(limiter.consume(input)).rejects.toMatchObject({ code: "RATE_LIMIT_EXCEEDED", status: 429 });
	});

	it("keeps budgets separate by client IP and resume", async () => {
		const limiter = createPublicRenderRateLimiter({ capacity: 1, refillWindowMs: 60_000 });
		await limiter.consume({ trustedClient: "203.0.113.7", resumeId: "resume-1" });

		await expect(limiter.consume({ trustedClient: "203.0.113.8", resumeId: "resume-1" })).resolves.toBeUndefined();
		await expect(limiter.consume({ trustedClient: "203.0.113.7", resumeId: "resume-2" })).resolves.toBeUndefined();
	});

	it("refills the bounded bucket over time", async () => {
		const limiter = createPublicRenderRateLimiter({ capacity: 1, refillWindowMs: 1_000 });
		const input = { trustedClient: "203.0.113.7", resumeId: "resume-1" };
		await limiter.consume(input);
		await expect(limiter.consume(input)).rejects.toThrow();

		vi.advanceTimersByTime(1_001);

		await expect(limiter.consume(input)).resolves.toBeUndefined();
	});
});
