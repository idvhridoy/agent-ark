import { BrandIcon } from "@reactive-resume/ui/components/brand-icon";
import { Spinner } from "@reactive-resume/ui/components/spinner";

export function LoadingScreen() {
	return (
		<div className="fixed inset-0 z-50 flex h-svh w-svw flex-col items-center justify-center gap-y-6 bg-background">
			<BrandIcon variant="icon" className="size-12" />
			<Spinner className="size-6" />
		</div>
	);
}
