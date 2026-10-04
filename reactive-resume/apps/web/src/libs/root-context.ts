import { getSession } from "./auth/session";
import { getLocale, loadLocale } from "./locale";
import { client } from "./orpc/client";
import { getTheme } from "./theme";

export async function loadRootContext() {
	const [theme, locale, session, flags] = await Promise.all([
		getTheme(),
		getLocale(),
		getSession(),
		client.flags.get(),
	]);

	await loadLocale(locale);

	return { theme, locale, session, flags };
}
