# Finnish learning — project conventions

Personal Finnish-tutoring system for Malcolm (British, learning from scratch toward A2). Claude Code IS the tutor engine: skills generate worksheets, mark answers, and hold conversations. **No API keys or external services** — that's a deliberate choice; don't propose them unprompted.

## How it fits together

- `finnish-from-zero.html` — the 24-lesson course; source of truth for lesson content. Modify only for **verified language corrections** (check real usage first, note the fix in the commit). The workbook (`finnish-from-zero-workbook.html`) may additionally gain new exercise sections when Malcolm asks.
- `tutor/syllabus.json` — extracted curriculum: per-lesson `grammar` tags + vocab, plus the `error_tags` taxonomy used by all state files. Update only if the course itself changes.
- `tutor/progress.json`, `tutor/errors.json`, `tutor/vocab.json` — learner state, owned by the skills (/practice creates, /mark and /puhutaan update). Schemas are documented in `.claude/skills/practice/SKILL.md` §1 and `mark/SKILL.md` §4.
- `tutor/template.html` — worksheet shell. Worksheets are stamped from it by replacing the single `const PAYLOAD = null; // __PAYLOAD__ …` line with a payload object (schema in the template's header comment). Generated worksheets go in `tutor/worksheets/YYYY-MM-DD.html`.
- `serve.cmd`/`serve.ps1` — localhost static server, the fallback when browsers block the mic on `file://` pages.

## Iron rules

1. **Level constraint**: anything Malcolm must *produce* uses only grammar from lessons `0..completed_through` (progress.json); current-lesson grammar may appear receptively.
2. **Answer-key verification**: every accepted answer in generated exercises gets an independent second-pass check (gradation, vowel harmony, partitive objects, object case) before the file is written. Teaching a wrong form is the one unacceptable failure.
3. **Accepted-answer arrays are generous**: pronoun-optional variants, word-order variants, spelling variants (ruoasta/ruuasta).
4. State files are the memory — /mark and /puhutaan must actually write their updates, not just report.

Content themes that land: the gym (kyykky/penkki/maastaveto), office work, café/food, Helsinki, weather, travel.

## Git & publishing

This repo commits **directly to main** and pushes — no branches, no PRs. It's the deliberate exception to Malcolm's global /ship PR workflow (solo repo, generated content, GitHub Pages deploys from main); the project-level `.claude/commands/ship.md` override encodes this and wins over the global one. After /practice generates a worksheet, offer to /ship it so the Pages site stays current. There is no API key anywhere in this system and the published site must stay purely static — generation happens only in Claude Code sessions on this machine.
