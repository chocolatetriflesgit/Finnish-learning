---
name: language-authoring
description: Author and verify language-learning content — exercises with trustworthy answer keys, level-constrained passages, error taxonomies, vocabulary pipelines, and tutor-style marking. Use when generating drills, translation passages, cloze items, worksheets, quizzes or courses for any human language, when writing accepted-answer lists, or when a learner disputes whether content is correct.
---

# language-authoring — content a learner can trust

Principles proven in a Finnish tutoring system; examples are Finnish, the rules are language-agnostic.

## The iron law: never teach a wrong form

An answer key that teaches an error is the one unacceptable failure — worse than no exercise. Two defences, always both:

**1. Independent second pass.** After drafting ANY answer key, re-derive every accepted answer *as if checking a stranger's work* — not "does this look right" but "derive it again from the rules". Build the checklist from the target language's actual failure points, e.g.: agreement (gender/number/case), inflection class and stem changes, case/preposition government of specific verbs, word order, orthography including diacritics, false-friend translations. Anything you cannot re-derive with confidence: **replace the item** rather than ship the doubt.

**2. Verify disputed or idiomatic forms against real usage.** Intuition about idiom is exactly where generators slip. Web-search native sources (learner blogs by native teachers, corpora, reference grammars) before shipping anything you'd hesitate to defend. Classic catch: fixed expressions with non-obvious grammar (Finnish wishes take the partitive: *Hyvää päivää!* — so "Get well soon" is *Pikaista paranemista*, never the nominative).

**When a learner challenges content**, verify honestly before responding — three outcomes, all good:
- **They're right** → fix it, thank them, log the correction in the commit.
- **They're half right** → the disputed form is real but underexplained (Finnish *Paljonko se tekee?* is genuine till-idiom for a total; *Paljonko se maksaa?* asks a thing's price). Keep the form AND add teaching that distinguishes them.
- **The content stands** → show the evidence, kindly. Never cave to an incorrect correction; never defend an error.

## Accepted answers: generous beats strict

A learner marked wrong for a *correct* answer loses trust faster than anything else. For every item, enumerate variant classes:
- pronoun-optional forms (*"(minä) olen"* — pro-drop languages especially)
- legitimate word-order permutations
- contractions vs full forms; standard spelling variants (*ruoasta/ruuasta*)
- with/without optional words the prompt doesn't force

Normalise before comparing (the proven function): lowercase, Unicode NFC, straighten curly quotes, strip terminal punctuation `.,!?…;:"()`, collapse whitespace. Show a properly-capitalised display answer separately from the accept-list.

**When variants explode** (open personal questions, free translation): don't auto-mark — switch the item to self-check-against-model or collect-for-human/AI-marking. A model answer always carries the caveat: *"one good answer, not the only correct one."*

## Level constraint: produce only what's been taught

- Make the syllabus machine-readable: per-unit grammar tags + vocabulary list. "What the learner knows after unit N" must be computable.
- Everything the learner must **produce** uses only grammar/vocab from completed units. Current-unit material may appear **receptively** (reading/listening) as a stretch — flagged and glossed, never silently.
- **Engineer translation passages target-language-first**: draft the target-language text inside the constraint, verify every form (iron law), *then* write the source-language prompt from it. Writing the English first and hoping the translation fits the syllabus produces unsatisfiable prompts.
- New vocabulary enters glossed (3–5 words per session), gets forced production immediately, then is deliberately recycled into later passages until tracked as known.

## Exercise repertoire

Transform drills (conjugate / negate / pluralise / past-ify), cloze with case-or-form choice, **build-the-question** (given the answer, write the question — question formation is under-drilled production grammar), minimal pairs for meaning-bearing sound contrasts, dictation, two-way translation passages, dialogue completion, register conversion (formal↔colloquial), free writing with model + caveat, spoken items (→ companion skill `speech-web`).

## The adaptive layer (what makes it a tutor, not a workbook)

- **Error taxonomy**: the syllabus grammar tags double as error tags. Log per tag: count, last-seen, up to 5 examples in `"their form → correct form"` shape. Next session's drills bias toward the top tags; success decrements.
- **Vocabulary tracking**: per word — gloss, introduced date, right/wrong counts, last-seen. Due = wrong>right or stale 7+ days; due words get priority in new passages.
- **Marking like a tutor**, not a string-matcher: for each real error give *quote → corrected form → one-line why → tag*. Name the 1–3 *patterns* behind the errors, not just instances. Overturn the auto-checker in the learner's favour when their variant is defensible — and say so. Praise specifically ("the object case in X was exactly right"), never generically. If work is flawless, say exactly that; never invent errors.
- State files must actually be **written** after marking/conversation, not just reported — the memory is the product.

Reference implementation (syllabus JSON, worksheet template, generate/mark/converse skills): https://github.com/chocolatetriflesgit/Finnish-learning — companion skill: `speech-web`.
