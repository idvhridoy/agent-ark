import { RichInput } from "@/components/input/rich-input";
import { useCurrentBuilderResumeSelector, useUpdateResumeData } from "@/features/resume/builder/draft";
import { SectionBase } from "../shared/section-base";

export function SummarySectionBuilder() {
	const section = useCurrentBuilderResumeSelector((resume) => resume.data.summary);
	const updateResumeData = useUpdateResumeData();

	const onChange = (value: string) => {
		updateResumeData((draft) => {
			draft.summary.content = value;
		});
	};

	return (
		<SectionBase type="summary">
			<RichInput value={section.content} onChange={onChange} />
		</SectionBase>
	);
}
