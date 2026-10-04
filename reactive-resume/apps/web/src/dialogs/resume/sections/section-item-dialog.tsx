import type { ReactNode } from "react";
import { Trans } from "@lingui/react/macro";
import { Button } from "@reactive-resume/ui/components/button";
import {
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogHeader,
	DialogTitle,
} from "@reactive-resume/ui/components/dialog";

type SectionItemDialogProps = {
	/** Full dialog title — pass a Trans node so i18n extraction works per-file */
	title: ReactNode;
	/** Leading icon — PlusIcon (create) or PencilSimpleLineIcon (update) */
	icon: ReactNode;
	/** Called via `void form.handleSubmit()` from the form's onSubmit handler */
	onSubmit: () => void;
	/** Called by useFormBlocker's requestClose */
	onCancel: () => void;
	isSubmitting: boolean;
	/** Button label: <Trans>Create</Trans> or <Trans>Save Changes</Trans> */
	submitLabel: ReactNode;
	/** When true, uses a single-column form layout (cover-letter, summary-item) */
	singleColumn?: boolean;
	children: ReactNode;
};

/**
 * Shared shell for section-item Create/Update dialogs.
 * Each dialog still owns its schema, defaultValues, and form hooks.
 * This wrapper only removes the duplicated DialogContent/Header/form/Footer boilerplate.
 */
export function SectionItemDialog({
	title,
	icon,
	onSubmit,
	onCancel,
	isSubmitting,
	submitLabel,
	singleColumn = false,
	children,
}: SectionItemDialogProps) {
	return (
		<DialogContent>
			<DialogHeader>
				<DialogTitle className="flex items-center gap-x-2">
					{icon}
					{title}
				</DialogTitle>
				<DialogDescription />
			</DialogHeader>

			<form
				className={singleColumn ? "grid gap-4" : "grid gap-4 sm:grid-cols-2"}
				onSubmit={(event) => {
					event.preventDefault();
					event.stopPropagation();
					onSubmit();
				}}
			>
				{children}

				<DialogFooter className={singleColumn ? undefined : "sm:col-span-full"}>
					<Button variant="ghost" onClick={onCancel}>
						<Trans>Cancel</Trans>
					</Button>

					<Button type="submit" disabled={isSubmitting}>
						{submitLabel}
					</Button>
				</DialogFooter>
			</form>
		</DialogContent>
	);
}
