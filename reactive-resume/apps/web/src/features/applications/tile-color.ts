// Deterministic accent color for a company's initials tile, shared by the board card and the
// table row so the same company reads the same everywhere.
const TILE_COLORS = [
	"bg-rose-500",
	"bg-orange-500",
	"bg-amber-500",
	"bg-emerald-500",
	"bg-teal-500",
	"bg-sky-500",
	"bg-indigo-500",
	"bg-violet-500",
	"bg-fuchsia-500",
];

export function tileColor(seed: string) {
	let hash = 0;
	for (let i = 0; i < seed.length; i++) hash = (hash * 31 + seed.charCodeAt(i)) | 0;
	return TILE_COLORS[Math.abs(hash) % TILE_COLORS.length];
}
