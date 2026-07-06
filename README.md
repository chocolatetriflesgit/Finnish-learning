# Suomen tutor — Finnish practice system

A self-contained tutoring loop built on Claude Code. It generates fresh, level-matched worksheets from the **Finnish from Zero** course, marks your free writing like a tutor, tracks what you get wrong, and holds Finnish conversations at your level. No API keys, no accounts — it runs on the Claude Code subscription you already have.

## The daily loop

```
claude          # open Claude Code in this folder
  /practice     # → generates today's worksheet and opens it in your browser
                #   (first run: it asks which lesson you've reached)
  ... do the worksheet in the browser ...
  ... press  "Export answers ⭳"  when done ...
  /mark         # → tutor-style feedback, error log updated
  /puhutaan     # → Finnish conversation practice, any time ("lopetetaan" to stop)
```

Each worksheet contains: a Finnish→English passage, an English→Finnish passage (both using only grammar you've covered), read-aloud and answer-aloud speaking exercises, a review section aimed at your recent mistakes, and a free-writing prompt. New vocabulary is introduced glossed, then recycled into later passages until it sticks.

## Speaking exercises & the microphone

The 🎤 buttons use your browser's built-in speech recognition (Finnish). **Chrome works best**; it needs internet and mic permission. If the mic is blocked when a worksheet is opened directly as a file, double-click **`serve.cmd`** — it serves the worksheets at `http://localhost:8321` where the mic always works. If a recognition result is wrong but you're sure you said it right, use *"mark as correct"* — the transcript is still saved so /mark can see it.

**Bonus:** install the Finnish language pack in Windows and **Win + H** (voice typing) lets you *speak* your side of `/puhutaan` conversations instead of typing.

## What's in this folder

| Path | What it is |
|---|---|
| `finnish-from-zero.html` | The 24-lesson course (the curriculum) |
| `finnish-from-zero-workbook.html` | The original fixed workbook |
| `tutor/syllabus.json` | Machine-readable course: per-lesson grammar + vocab |
| `tutor/progress.json` · `errors.json` · `vocab.json` | Your state — created on first `/practice` |
| `tutor/template.html` | Worksheet shell (don't edit casually — worksheets are stamped from it) |
| `tutor/worksheets/` | Your generated worksheets, one per day |
| `serve.cmd` / `serve.ps1` | Local server, only needed for mic-over-file:// problems |

## On the web (GitHub Pages)

The repo doubles as a website: `index.html` lists the course, workbook and all worksheets. With GitHub Pages enabled (Settings → Pages → deploy from `main`, root), everything is reachable at `https://<username>.github.io/<repo>/` — shareable links, phone practice, and the 🎤 mic works there without any setup (proper HTTPS). After `/practice` generates a new worksheet, commit and push to put it on the site.

## Ideas for later (deliberately not in v1)

Dedicated grammar-drill mode · full spaced-repetition scheduling for vocab · listening exercises via text-to-speech · publishing worksheets to GitHub Pages to practise from a phone. Ask Claude Code for any of these when you want them — the state files are already designed for it.
