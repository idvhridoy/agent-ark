"""clone_repos.py — clone every GitHub URL in repo.md into this folder, in parallel.

Reads the URL list (repo.md by default), skips duplicates and already-cloned
repos, and clones with a thread pool. Shallow clones (--depth 1) by default —
these are reference repos; pass --full if you need git history.

Usage:
    py -3 clone_repos.py                     # clone everything in repo.md here
    py -3 clone_repos.py -j 12               # more workers
    py -3 clone_repos.py --full              # full history instead of shallow
    py -3 clone_repos.py --update            # git pull --ff-only existing clones
    py -3 clone_repos.py --dest repos/       # clone into a subfolder
    py -3 clone_repos.py --dry-run           # list what would happen
"""
from __future__ import annotations

import argparse
import logging
import re
import shutil
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path

logger = logging.getLogger("clone_repos")

GITHUB_URL_RE = re.compile(
    r"https?://github\.com/(?P<owner>[A-Za-z0-9_.-]+)/(?P<repo>[A-Za-z0-9_.-]+?)/?(?:\.git)?\s*$"
)


@dataclass
class Repo:
    url: str
    owner: str
    name: str
    dirname: str  # folder name under dest (owner--name on collision)


@dataclass
class Result:
    repo: Repo
    status: str  # cloned | updated | exists | failed
    detail: str = ""


def load_repos(path: Path) -> list[Repo]:
    """Parse unique GitHub URLs from the list file, preserving order."""
    seen_urls: set[str] = set()
    taken_names: set[str] = set()
    repos: list[Repo] = []

    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line:
            continue
        m = GITHUB_URL_RE.match(line)
        if not m:
            logger.warning("ignoring non-GitHub line: %s", line)
            continue
        owner, name = m.group("owner"), m.group("repo")
        # Reject names that could escape dest or be parsed as a git flag.
        if any(p in (".", "..") or p.startswith("-") for p in (owner, name)):
            logger.warning("ignoring unsafe repo path: %s", line)
            continue
        url = f"https://github.com/{owner}/{name}"
        if url.lower() in seen_urls:
            continue
        seen_urls.add(url.lower())

        dirname = name
        if dirname.lower() in taken_names:
            dirname = f"{owner}--{name}"
        taken_names.add(dirname.lower())
        repos.append(Repo(url, owner, name, dirname))

    return repos


def clone_repo(repo: Repo, dest: Path, depth: int | None, update: bool,
               timeout: int) -> Result:
    target = dest / repo.dirname

    if (target / ".git").exists():
        if not update:
            return Result(repo, "exists")
        proc = subprocess.run(
            ["git", "-C", str(target), "pull", "--ff-only", "--quiet"],
            capture_output=True, text=True, timeout=timeout,
        )
        return Result(repo, "updated" if proc.returncode == 0 else "failed",
                      proc.stderr.strip())

    if target.exists():
        # Folder exists but is not a clone — fall back to owner--name.
        target = dest / f"{repo.owner}--{repo.name}"
        if target.exists():
            return Result(repo, "failed", f"path blocked: {target}")

    cmd = ["git", "clone", "--quiet"]
    if depth:
        cmd += ["--depth", str(depth)]
    cmd += [repo.url, str(target)]

    try:
        proc = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return Result(repo, "failed", f"timed out after {timeout}s")
    if proc.returncode != 0:
        return Result(repo, "failed", proc.stderr.strip().splitlines()[-1]
                      if proc.stderr.strip() else "unknown git error")
    return Result(repo, "cloned")


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    ap.add_argument("--file", type=Path, default=Path(__file__).with_name("repo.md"),
                    help="URL list file (default: repo.md next to this script)")
    ap.add_argument("--dest", type=Path, default=Path(__file__).parent,
                    help="Clone destination (default: this script's folder)")
    ap.add_argument("-j", "--jobs", type=int, default=8, help="parallel clones")
    ap.add_argument("--depth", type=int, default=1, help="clone depth (default 1)")
    ap.add_argument("--full", action="store_true", help="full history (no depth limit)")
    ap.add_argument("--update", action="store_true",
                    help="git pull --ff-only repos that already exist")
    ap.add_argument("--timeout", type=int, default=600, help="per-repo timeout seconds")
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")

    if shutil.which("git") is None:
        logger.error("git is not on PATH")
        return 1
    if not args.file.is_file():
        logger.error("list file not found: %s", args.file)
        return 1

    depth = None if args.full else args.depth
    repos = load_repos(args.file)
    logger.info("%d repos -> %s (jobs=%d, depth=%s)", len(repos), args.dest,
                args.jobs, depth or "full")

    if args.dry_run:
        for r in repos:
            state = "exists" if (args.dest / r.dirname / ".git").exists() else "clone"
            print(f"{state:7} {r.url} -> {r.dirname}")
        return 0

    counts = {"cloned": 0, "updated": 0, "exists": 0, "failed": 0}
    failures: list[Result] = []
    done = 0

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        futures = {
            pool.submit(clone_repo, r, args.dest, depth, args.update,
                        args.timeout): r
            for r in repos
        }
        for fut in as_completed(futures):
            res = fut.result()
            done += 1
            counts[res.status] += 1
            if res.status == "failed":
                failures.append(res)
            logger.info("[%d/%d] %-7s %s %s", done, len(repos), res.status,
                        res.repo.url, res.detail)

    logger.info("done: %d cloned, %d updated, %d existing, %d failed",
                counts["cloned"], counts["updated"], counts["exists"],
                counts["failed"])
    if failures:
        logger.info("failed repos:")
        for f in failures:
            logger.info("  %s (%s)", f.repo.url, f.detail)
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
