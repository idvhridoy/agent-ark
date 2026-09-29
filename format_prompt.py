"""format_prompt.py — Reformat scraped windsurf.run / cursor.directory rule files.

The raw downloads cram the actual prompt into one backtick-quoted blob where
headings (#, ##, ###), bullets (-) and numbered items (1. 2. 3.) all run
together on a single line. This script extracts that blob, restores real
markdown structure, strips the navigation/tag-cloud junk, and rebuilds a clean,
human-readable file.

Usage:
    python format_prompt.py downloaded/.net.md          -> writes .net.formatted.md
    python format_prompt.py downloaded/                 -> formats every .md in the folder
    python format_prompt.py downloaded/ -o cleaned/     -> write into a folder
    python format_prompt.py downloaded/ --in-place      -> overwrite originals
    python format_prompt.py file.md --stdout            -> print, don't write
"""
from __future__ import annotations

import argparse
import logging
import re
import sys
from dataclasses import dataclass
from pathlib import Path

logger = logging.getLogger("format_prompt")

# ---------------------------------------------------------------------------
# Extraction patterns
# ---------------------------------------------------------------------------

FRONTMATTER_RE = re.compile(r"\A---\s*\n(?P<body>.*?)\n---\s*\n", re.S)
SOURCE_RE = re.compile(r"^source:\s*(?P<url>\S+)\s*$", re.M)
# The prompt lives inside  [ \n ` ... ` \n ][N]
BLOB_RE = re.compile(r"\[\s*\n\s*`(?P<prompt>.*?)`\s*\n\s*\]\[\d+\]", re.S)
# Alternate layout: a bare backtick-quoted blob starting at line start
BLOB2_RE = re.compile(r"^\s*`(?P<prompt>.+?)`\s*$", re.S | re.M)
AUTHOR_RE = re.compile(r"^###\s+(?P<name>.+?)\s*$", re.M)

# Patterns for the generic (non-blob) scrape layout, e.g. mcp-*.md pages
WEB_CONTENT_RE = re.compile(r"^# Web Content from\s+\S+\s*$", re.M)
LINK_ONLY_RE = re.compile(r"^\s*(?:\[[^\]]*\]\[\d+\])+\s*(?:Search)?\s*$")  # [text][n] refs
FOOTNOTE_RE = re.compile(r"^\[\d+\]:\s*\S+\s*$")
TAG_CLOUD_RE = re.compile(r"[A-Za-z]\d+[A-Z(]")  # "TypeScript23Python16"

# ---------------------------------------------------------------------------
# Reformatting patterns (applied to the unwrapped blob text)
# ---------------------------------------------------------------------------

# A heading marker must be preceded by whitespace/start so "C#", "F#" survive.
HEADING_RE = re.compile(r"(?<!\S)(#{1,6})\s+")
# " - " bullets; word-hyphens like "object-oriented" have no surrounding spaces.
BULLET_RE = re.compile(r"(?<=\s)-(?=\s)")
# " 1. " numbered items; decimals like "3.12" don't match (dot + digit).
NUMBERED_RE = re.compile(r"(?<=\s)(\d{1,3})\.\s+")
# Guess unmarked section titles: "...end of sentence. Some Title - first bullet"
GUESS_HEADING_RE = re.compile(
    r"(?P<end>[.?!]\s+)"
    r"(?P<title>[A-Z][\w/&+()\-]*(?: [\w/&+()\-]+){0,8}?)"
    r"(?=\s+-\s|\s+\d{1,3}\.\s)"
)
# Headings glued to the previous bullet with no sentence break:
# "...integration with Odoo Odoo-Specific Guidelines - Use XML"
GUESS_GLUE_RE = re.compile(
    r"(?P<end>[a-z][\w']*\s+)"
    r"(?P<title>[A-Z][\w/&+()\-]*(?:\s+[A-Z][\w/&+()\-]*){1,5}?)"
    r"(?=\s+-\s|\s+\d{1,3}\.\s)"
)
# Heading glued to the "You are a ..." preamble: "# Title You are a senior ..."
HEAD_BODY_RE = re.compile(
    r"^(#{1,6} .{2,80}?)\s+(You are|You will|You're|As an?)\s", re.M
)


@dataclass
class ParsedRules:
    frontmatter: str
    source_url: str
    prompt: str
    author: str
    structured: bool = False  # True when the body is already valid markdown


def parse_file(raw: str) -> ParsedRules | None:
    """Pull the frontmatter, prompt blob and author out of a raw download."""
    blob = BLOB_RE.search(raw)
    fm = FRONTMATTER_RE.match(raw)
    source = SOURCE_RE.search(raw)
    frontmatter = fm.group(0).rstrip() if fm else ""
    source_url = source.group("url") if source else ""

    if blob:
        author = AUTHOR_RE.search(raw, pos=blob.end())
        return ParsedRules(frontmatter, source_url, blob.group("prompt"),
                           author.group("name") if author else "")

    # Fallback layout (mcp-*.md etc.): markdown is already structured,
    # just wrapped in navigation junk and footnote link definitions.
    body = clean_generic_body(raw)
    if body is not None:
        prompt, author = body
        return ParsedRules(frontmatter, source_url, prompt, author, structured=True)

    # Bare backtick-blob layout (no nav junk, no web-content heading).
    blob2 = BLOB2_RE.search(raw)
    if blob2:
        author = AUTHOR_RE.search(raw, pos=blob2.end())
        return ParsedRules(frontmatter, source_url, blob2.group("prompt"),
                           author.group("name") if author else "")
    return None


def _is_junk_line(line: str) -> bool:
    s = line.strip()
    if not s:
        return True
    if s in ("[", "Search") or LINK_ONLY_RE.match(s):
        return True
    return bool(TAG_CLOUD_RE.search(s))


def clean_generic_body(raw: str) -> tuple[str, str] | None:
    """Strip nav/footer junk from already-structured scrape pages."""
    if not WEB_CONTENT_RE.search(raw):
        return None
    fm = FRONTMATTER_RE.match(raw)
    body = raw[fm.end():] if fm else raw
    lines = WEB_CONTENT_RE.sub("", body, count=1).splitlines()

    # Drop the nav/tag-cloud preamble: everything before the first real line
    # (a heading or a normal text line).
    start = next(
        (i for i, line in enumerate(lines)
         if line.startswith("#") or not _is_junk_line(line)),
        len(lines),
    )
    # Drop footnote link definitions and anything after them.
    end = next(
        (i for i, line in enumerate(lines) if FOOTNOTE_RE.match(line)),
        len(lines),
    )
    lines = lines[start:end]

    # Trailing junk: link-only lines, then a possible "### Author" heading.
    while lines and _is_junk_line(lines[-1]):
        lines.pop()
    author = ""
    if lines and (m := AUTHOR_RE.match(lines[-1])):
        author = m.group("name")
        lines.pop()
        while lines and _is_junk_line(lines[-1]):
            lines.pop()

    return "\n".join(lines).strip(), author


def _glue_heading_sub(m: re.Match) -> str:
    end, title = m.group("end"), m.group("title")
    # A bullet's trailing word can leak into the title run
    # ("...with Odoo Odoo-Specific Guidelines"); drop leading words that
    # are a prefix of the next word.
    words = title.split()
    while len(words) > 1 and words[1].startswith(words[0]):
        end += words.pop(0) + " "
    return f"{end}\n\n## {' '.join(words)}"


def format_prompt(blob: str) -> str:
    """Turn the single-line blob into structured markdown."""
    # The blob is hard-wrapped at ~80 chars; join it back into one string.
    text = " ".join(blob.split())

    text = HEADING_RE.sub(lambda m: f"\n\n{m.group(1)} ", text)
    text = GUESS_HEADING_RE.sub(
        lambda m: f"{m.group('end')}\n\n## {m.group('title')}", text
    )
    text = GUESS_GLUE_RE.sub(_glue_heading_sub, text)
    text = HEAD_BODY_RE.sub(lambda m: f"{m.group(1)}\n\n{m.group(2)} ", text)
    text = BULLET_RE.sub("\n-", text)
    text = NUMBERED_RE.sub(lambda m: f"\n{m.group(1)}. ", text)

    text = re.sub(r"[ \t]+\n", "\n", text)
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text.strip()


def title_from_slug(path: Path) -> str:
    words = re.sub(r"[-_]+", " ", path.stem).strip() or "Rules"
    return words.title()


def rebuild(parsed: ParsedRules, path: Path) -> str:
    prompt = parsed.prompt if parsed.structured else format_prompt(parsed.prompt)
    if not re.match(r"^#{1,6}\s", prompt):
        prompt = f"# {title_from_slug(path)}\n\n{prompt}"

    parts: list[str] = []
    if parsed.frontmatter:
        parts.append(parsed.frontmatter)
    parts.append(prompt)
    footer_bits = []
    if parsed.author:
        footer_bits.append(f"**Author:** {parsed.author}")
    if parsed.source_url:
        footer_bits.append(f"**Source:** {parsed.source_url}")
    if footer_bits:
        parts.append("---\n\n" + " | ".join(footer_bits))

    return "\n\n".join(parts) + "\n"


def process_file(path: Path, out_path: Path | None, stdout: bool) -> str:
    raw = path.read_text(encoding="utf-8")
    parsed = parse_file(raw)
    if parsed is None:
        return "skipped"
    output = rebuild(parsed, path)
    if stdout:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stdout.write(output)
        return "printed"
    assert out_path is not None
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(output, encoding="utf-8")
    return "formatted"


def iter_targets(paths: list[str]) -> list[Path]:
    targets: list[Path] = []
    for raw in paths:
        p = Path(raw)
        if p.is_dir():
            targets.extend(sorted(p.glob("*.md")))
        elif p.is_file():
            targets.append(p)
        else:
            logger.warning("not found: %s", p)
    return targets


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("paths", nargs="+", help="Markdown file(s) or directories to format")
    ap.add_argument("-o", "--outdir", type=Path, help="Directory for formatted output")
    ap.add_argument("--in-place", action="store_true", help="Overwrite the original files")
    ap.add_argument("--stdout", action="store_true", help="Print to stdout instead of writing files")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(levelname)s %(message)s",
    )

    if args.in_place and (args.outdir or args.stdout):
        ap.error("--in-place cannot be combined with -o/--stdout")

    counts = {"formatted": 0, "skipped": 0, "printed": 0}
    for path in iter_targets(args.paths):
        if path.name.endswith(".formatted.md"):
            continue
        if args.in_place:
            out = path
        elif args.outdir:
            out = args.outdir / path.name
        else:
            out = path.with_name(f"{path.stem}.formatted.md")
        try:
            result = process_file(path, out, args.stdout)
        except Exception as exc:
            logger.error("%s: %s", path.name, exc)
            continue
        counts[result] += 1
        logger.info("%-9s %s%s", result, path.name, "" if args.stdout else f" -> {out.name}")

    logger.info(
        "done: %d formatted, %d skipped (no prompt block)",
        counts["formatted"] + counts["printed"],
        counts["skipped"],
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
