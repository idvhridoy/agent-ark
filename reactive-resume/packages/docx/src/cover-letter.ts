import type { ResumeData } from "@reactive-resume/schema/resume/data";

const isCoverLetterSection = (data: ResumeData, sectionId: string) => {
	const section = data.customSections.find((customSection) => customSection.id === sectionId);

	return section?.type === "cover-letter" && !section.hidden && section.items.some((item) => !item.hidden);
};

const isCoverLetterOnlyDocument = (data: ResumeData) => {
	const sectionIds = data.metadata.layout.pages.flatMap((page) => [...page.main, ...page.sidebar]);

	return sectionIds.length > 0 && sectionIds.every((sectionId) => isCoverLetterSection(data, sectionId));
};

export const shouldShowResumeHeader = (data: ResumeData) => !isCoverLetterOnlyDocument(data);
