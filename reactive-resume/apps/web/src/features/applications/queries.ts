import { orpc } from "@/libs/orpc/client";

// A single source of truth for the applications list query so the query key stays identical
// across the board (optimistic drag), the detail panel, and the route. We always fetch archived
// rows too and filter them per-view client-side, so "unarchive" has something to act on.
const LIST_INPUT = { includeArchived: true } as const;

export const applicationsListQueryOptions = () => orpc.applications.list.queryOptions({ input: LIST_INPUT });
export const applicationsListQueryKey = () => orpc.applications.list.queryKey({ input: LIST_INPUT });
