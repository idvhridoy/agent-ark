// Percent change of the most recent `window` days vs the `window` days before it.
// Returns null when the prior period had no activity (division by zero / no baseline).
export function computeDelta(series: number[], window: number): number | null {
	const recent = series.slice(-window);
	const previous = series.slice(-window * 2, -window);
	const recentSum = recent.reduce((sum, n) => sum + n, 0);
	const previousSum = previous.reduce((sum, n) => sum + n, 0);
	if (previousSum === 0) return null;
	return Math.round(((recentSum - previousSum) / previousSum) * 100);
}

// Polyline points for the sparkline, or null for degenerate inputs (fewer than two
// points, or an all-zero series) where there is nothing meaningful to draw.
export function getSparklinePoints(values: number[], width: number, height: number): string | null {
	if (values.length < 2 || values.every((n) => n === 0)) return null;
	const max = Math.max(...values, 1);
	const step = width / (values.length - 1);
	return values
		.map((value, index) => `${(index * step).toFixed(1)},${(height - (value / max) * height).toFixed(1)}`)
		.join(" ");
}
