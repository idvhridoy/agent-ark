export const defaultHighlightColor = "rgba(255, 255, 0, 1)";

export function resolveHighlightToolbarState(isHighlight: boolean, highlightColor: string | null) {
	const visibleHighlightColor = highlightColor ?? (isHighlight ? defaultHighlightColor : undefined);

	return { visibleHighlightColor, canClearHighlight: isHighlight };
}
