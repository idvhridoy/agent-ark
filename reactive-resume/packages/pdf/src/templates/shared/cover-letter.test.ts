import { describe, expect, it } from "vitest";
import { sampleResumeData } from "@reactive-resume/schema/resume/sample";
import { shouldShowResumeHeader } from "./cover-letter";

const createCoverLetterOnlyData = () => {
	const data = structuredClone(sampleResumeData);
	const coverLetter = data.customSections.find((section) => section.type === "cover-letter");

	if (!coverLetter) throw new Error("sample resume must include a cover letter");

	return {
		...data,
		customSections: [coverLetter],
		metadata: {
			...data.metadata,
			layout: {
				...data.metadata.layout,
				pages: [{ fullWidth: true, main: [coverLetter.id], sidebar: [] }],
			},
		},
	};
};

describe("shouldShowResumeHeader", () => {
	it("hides the header when every visible layout section is a cover letter", () => {
		expect(shouldShowResumeHeader(createCoverLetterOnlyData(), 0)).toBe(false);
	});

	it("can keep the first-page header for cover letter documents", () => {
		const data = { ...createCoverLetterOnlyData(), renderOptions: { includeCoverLetterHeader: true } };

		expect(shouldShowResumeHeader(data, 0)).toBe(true);
		expect(shouldShowResumeHeader(data, 1)).toBe(false);
	});

	it("keeps the first-page header for normal resume documents", () => {
		expect(shouldShowResumeHeader(sampleResumeData, 0)).toBe(true);
		expect(shouldShowResumeHeader(sampleResumeData, 1)).toBe(false);
	});
});
