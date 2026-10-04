/**
 * Converts a summary string and optional highlights array into an HTML description.
 * Summary becomes a <p> tag, highlights become a <ul> list.
 */
export function toHtmlDescription(summary?: string, highlights?: string[]): string {
	const parts: string[] = [];

	if (summary) {
		parts.push(`<p>${summary}</p>`);
	}

	if (highlights && highlights.length > 0) {
		parts.push("<ul>");

		for (const highlight of highlights) {
			parts.push(`<li>${highlight}</li>`);
		}

		parts.push("</ul>");
	}

	return parts.join("");
}

/**
 * Converts an array of strings into an HTML unordered list.
 */
export function arrayToHtmlList(items: string[]): string {
	if (items.length === 0) return "";
	return `<ul>${items.map((item) => `<li>${item}</li>`).join("")}</ul>`;
}

export const BULLET_PATTERN = /^\s*[-–—•*◦‣·]\s+/;

const escapeHtml = (value: string) =>
	value
		.replace(/&/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;")
		.replace(/"/g, "&quot;")
		.replace(/'/g, "&#39;");

/**
 * Converts plain-text lines into escaped HTML: a <ul> when most lines are bullets, otherwise one <p> per line.
 */
export function toHtml(lines: string[]): string {
	const cleaned = lines.map((line) => line.trim()).filter(Boolean);
	if (cleaned.length === 0) return "";

	const bulleted = cleaned.filter((line) => BULLET_PATTERN.test(line));
	if (bulleted.length >= 2 && bulleted.length * 2 >= cleaned.length) {
		const items = cleaned.map((line) => `<li>${escapeHtml(line.replace(BULLET_PATTERN, ""))}</li>`).join(""); // nosemgrep
		return `<ul>${items}</ul>`; // nosemgrep
	}

	return cleaned.map((line) => `<p>${escapeHtml(line.replace(BULLET_PATTERN, ""))}</p>`).join(""); // nosemgrep
}
