import type { AnyDialogRendererEntry } from "../schemas";
import { CreateApiKeyDialog } from "./create";

export const apiKeyDialogRenderers: readonly AnyDialogRendererEntry[] = [
	{ type: "api-key.create", render: () => <CreateApiKeyDialog /> },
];
