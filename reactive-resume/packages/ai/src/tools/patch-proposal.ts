import z from "zod";
import { jsonPatchOperationSchema } from "@reactive-resume/resume/patch";

const resumePatchProposalSchema = z.object({
	id: z.string().min(1),
	title: z.string().trim().min(1),
	summary: z.string().trim().min(1).optional(),
	baseUpdatedAt: z.string().datetime().optional(),
	operations: z.array(jsonPatchOperationSchema).min(1),
});

export const resumePatchProposalToolInputSchema = z.object({
	proposals: z
		.array(
			resumePatchProposalSchema.omit({ id: true, baseUpdatedAt: true }).extend({
				id: z.string().min(1).optional(),
			}),
		)
		.min(1),
});

export const resumePatchProposalToolOutputSchema = z.object({
	proposals: z.array(resumePatchProposalSchema).min(1),
});

type ResumePatchProposal = z.infer<typeof resumePatchProposalSchema>;
type ResumePatchProposalToolInput = z.infer<typeof resumePatchProposalToolInputSchema>;

export function normalizeResumePatchProposals(
	input: ResumePatchProposalToolInput,
	baseUpdatedAt?: Date,
): ResumePatchProposal[] {
	return input.proposals.map((proposal, index) => ({
		...proposal,
		id: proposal.id ?? `proposal-${index + 1}`,
		...(baseUpdatedAt ? { baseUpdatedAt: baseUpdatedAt.toISOString() } : {}),
	}));
}
