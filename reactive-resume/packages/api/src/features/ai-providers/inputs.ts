import z from "zod";
import { aiProviderSchema } from "@reactive-resume/ai/types";

export const providerInput = z.object({
	label: z.string().trim().min(1),
	provider: aiProviderSchema,
	model: z.string().trim().min(1),
	baseURL: z.string().trim().optional(),
	apiKey: z.string().trim().min(1),
});

export const updateProviderInput = providerInput
	.partial()
	.extend({ id: z.string(), enabled: z.boolean().optional() })
	.refine((input) => Object.keys(input).some((key) => key !== "id"), {
		message: "At least one field must be provided.",
	});
