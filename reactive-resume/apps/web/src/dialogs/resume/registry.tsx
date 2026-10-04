import type { AnyDialogRendererEntry } from "../schemas";
import { CreateResumeDialog, DuplicateResumeDialog, UpdateResumeDialog } from ".";
import { ImportResumeDialog } from "./import";
import { CreateAwardDialog, UpdateAwardDialog } from "./sections/award";
import { CreateCertificationDialog, UpdateCertificationDialog } from "./sections/certification";
import { CreateCoverLetterDialog, UpdateCoverLetterDialog } from "./sections/cover-letter";
import { CreateCustomSectionDialog, UpdateCustomSectionDialog } from "./sections/custom";
import { CreateEducationDialog, UpdateEducationDialog } from "./sections/education";
import { CreateExperienceDialog, UpdateExperienceDialog } from "./sections/experience";
import { CreateInterestDialog, UpdateInterestDialog } from "./sections/interest";
import { CreateLanguageDialog, UpdateLanguageDialog } from "./sections/language";
import { CreateProfileDialog, UpdateProfileDialog } from "./sections/profile";
import { CreateProjectDialog, UpdateProjectDialog } from "./sections/project";
import { CreatePublicationDialog, UpdatePublicationDialog } from "./sections/publication";
import { CreateReferenceDialog, UpdateReferenceDialog } from "./sections/reference";
import { CreateSkillDialog, UpdateSkillDialog } from "./sections/skill";
import { CreateSummaryItemDialog, UpdateSummaryItemDialog } from "./sections/summary-item";
import { CreateVolunteerDialog, UpdateVolunteerDialog } from "./sections/volunteer";
import { TemplateGalleryDialog } from "./template/gallery";

export const resumeDialogRenderers: readonly AnyDialogRendererEntry[] = [
	{ type: "resume.create", render: () => <CreateResumeDialog /> },
	{ type: "resume.update", render: ({ data }) => <UpdateResumeDialog data={data} /> },
	{ type: "resume.duplicate", render: ({ data }) => <DuplicateResumeDialog data={data} /> },
	{ type: "resume.import", render: () => <ImportResumeDialog /> },
	{ type: "resume.template.gallery", render: () => <TemplateGalleryDialog /> },
	{ type: "resume.sections.profiles.create", render: ({ data }) => <CreateProfileDialog data={data} /> },
	{ type: "resume.sections.profiles.update", render: ({ data }) => <UpdateProfileDialog data={data} /> },
	{ type: "resume.sections.experience.create", render: ({ data }) => <CreateExperienceDialog data={data} /> },
	{ type: "resume.sections.experience.update", render: ({ data }) => <UpdateExperienceDialog data={data} /> },
	{ type: "resume.sections.education.create", render: ({ data }) => <CreateEducationDialog data={data} /> },
	{ type: "resume.sections.education.update", render: ({ data }) => <UpdateEducationDialog data={data} /> },
	{ type: "resume.sections.skills.create", render: ({ data }) => <CreateSkillDialog data={data} /> },
	{ type: "resume.sections.skills.update", render: ({ data }) => <UpdateSkillDialog data={data} /> },
	{ type: "resume.sections.projects.create", render: ({ data }) => <CreateProjectDialog data={data} /> },
	{ type: "resume.sections.projects.update", render: ({ data }) => <UpdateProjectDialog data={data} /> },
	{
		type: "resume.sections.certifications.create",
		render: ({ data }) => <CreateCertificationDialog data={data} />,
	},
	{
		type: "resume.sections.certifications.update",
		render: ({ data }) => <UpdateCertificationDialog data={data} />,
	},
	{ type: "resume.sections.languages.create", render: ({ data }) => <CreateLanguageDialog data={data} /> },
	{ type: "resume.sections.languages.update", render: ({ data }) => <UpdateLanguageDialog data={data} /> },
	{ type: "resume.sections.publications.create", render: ({ data }) => <CreatePublicationDialog data={data} /> },
	{ type: "resume.sections.publications.update", render: ({ data }) => <UpdatePublicationDialog data={data} /> },
	{ type: "resume.sections.awards.create", render: ({ data }) => <CreateAwardDialog data={data} /> },
	{ type: "resume.sections.awards.update", render: ({ data }) => <UpdateAwardDialog data={data} /> },
	{ type: "resume.sections.interests.create", render: ({ data }) => <CreateInterestDialog data={data} /> },
	{ type: "resume.sections.interests.update", render: ({ data }) => <UpdateInterestDialog data={data} /> },
	{ type: "resume.sections.volunteer.create", render: ({ data }) => <CreateVolunteerDialog data={data} /> },
	{ type: "resume.sections.volunteer.update", render: ({ data }) => <UpdateVolunteerDialog data={data} /> },
	{ type: "resume.sections.references.create", render: ({ data }) => <CreateReferenceDialog data={data} /> },
	{ type: "resume.sections.references.update", render: ({ data }) => <UpdateReferenceDialog data={data} /> },
	{ type: "resume.sections.summary.create", render: ({ data }) => <CreateSummaryItemDialog data={data} /> },
	{ type: "resume.sections.summary.update", render: ({ data }) => <UpdateSummaryItemDialog data={data} /> },
	{ type: "resume.sections.cover-letter.create", render: ({ data }) => <CreateCoverLetterDialog data={data} /> },
	{ type: "resume.sections.cover-letter.update", render: ({ data }) => <UpdateCoverLetterDialog data={data} /> },
	{ type: "resume.sections.custom.create", render: ({ data }) => <CreateCustomSectionDialog data={data} /> },
	{ type: "resume.sections.custom.update", render: ({ data }) => <UpdateCustomSectionDialog data={data} /> },
];
