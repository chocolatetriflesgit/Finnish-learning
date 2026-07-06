---
name: speech-web
description: Build voice features in web pages with zero API keys — browser speech recognition and text-to-speech for language learning, pronunciation practice, dictation, and listening exercises. Use when adding 🎤 or 🔊 features, picking TTS voices, debugging mic/permission problems, or designing speaking/listening exercise types.
---

# speech-web — browser voice features (no API keys)

Everything here uses what browsers ship for free. Battle-tested in a Finnish-learning app; all of it generalises — swap the BCP-47 language tag (`fi-FI`, `fr-FR`, `ja-JP`…).

## Capability map (who can do what)

| Capability | Best support | Notes |
|---|---|---|
| Speech recognition | **Chrome** (Google backend) | Widest language coverage incl. small languages; needs internet; free |
| Speech recognition | Edge (Azure backend) | Patchier language support — may fire `language-not-supported` for languages Chrome handles |
| TTS voices | All browsers via `speechSynthesis` | Uses OS-installed voices; **Edge additionally exposes its online "Natural" voices** with no install — often the best free voice for a language |
| Neither | Text-only models | Claude's API has no audio in/out — the browser supplies ears and voice; the model supplies the text on both sides |

## Speech recognition recipe

```js
const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
// feature-detect: if (!SR) → show typed fallback, never a dead button

const rec = new SR();
rec.lang = "fi-FI";
rec.continuous = true;      // CRITICAL for learners: default mode cuts them off
                            // mid-thought — let them finish, give a visible ● Stop button
rec.interimResults = true;  // live "heard so far" display keeps people talking
rec.maxAlternatives = 5;    // judge against ALL alternatives, not just the first
```

Collect finals across result events (continuous mode delivers several); judge correct if **any** alternative normalises to the target (see `language-authoring` for the normalise function).

**Error → human message map** (never surface raw error codes):
- `not-allowed` / `service-not-allowed` → mic blocked. On a `file://` page this is usually the *page context*, not the user: serve over `http://localhost` (a 30-line static server fixes it) or use HTTPS.
- `language-not-supported` → this browser's speech backend lacks the language — "try Chrome".
- `no-speech` → heard nothing; try closer to the mic.
- `network` → recognition is a cloud service; needs internet.
- `audio-capture` → no microphone found.

**Non-negotiable UX for learners:**
1. **Typed fallback** on every spoken item ("or type it") — recognition can fail for hardware, permission, accent or nerves; the exercise must never dead-end.
2. **Override button** ("the recogniser misheard me — mark as correct"): recognisers are trained on native speech and WILL mangle learners. Trust the human; keep the transcript in the export so a marker can judge later.
3. **Word-level feedback**: colour the target sentence's words by whether they appeared in the transcript (position-tolerant match) — "which word did it miss" beats a bare ✗.
4. Abort any active recognition before starting a new one; reset button state in `onend` (it fires after both success and error).

**Honest framing** for pronunciation: an exact-match transcript means *"an automatic system understood you"* — a genuinely useful intelligibility check, not phoneme-level accent coaching. Don't oversell it.

## Text-to-speech recipe

```js
function speak(text, lang, rate = 0.9) {           // 0.85–0.9 for learners
  const pick = () => {
    const vs = speechSynthesis.getVoices().filter(v => v.lang.startsWith(lang.slice(0, 2)));
    return vs.find(v => /natural|online/i.test(v.name))   // Edge online voices first
        || vs.find(v => v.lang === lang) || vs[0] || null;
  };
  const go = () => {
    const u = new SpeechSynthesisUtterance(text);
    u.lang = lang; const v = pick(); if (v) u.voice = v; u.rate = rate;
    speechSynthesis.cancel(); speechSynthesis.speak(u);
  };
  if (speechSynthesis.getVoices().length) go();
  else speechSynthesis.onvoiceschanged = go;       // voices load ASYNC — handle it
}
```

**When no voice exists for the language**, say so in the UI and point at the install path — don't fail silently:
- **Windows**: Settings → System → **Optional features** → View features → "<language> text-to-speech" (the Time & Language → Speech page also works but crashes on some builds). Power route (admin): `Add-WindowsCapability -Online -Name "Language.TextToSpeech~~~<tag>~0.0.1.0"`. Check what's installed (no admin): registry `HKLM:\SOFTWARE\Microsoft\Speech_OneCore\Voices\Tokens`.
- **macOS**: System Settings → Accessibility → Spoken Content → Manage Voices.
- **Zero-install fallback**: open the page in **Edge** — its online Natural voices cover many languages through the same API (needs internet).
- Windows edition check if installs mysteriously fail: registry `EditionID` = `CoreSingleLanguage` means language packs are licence-blocked (plain `Core`/Home is fine).

## Exercise patterns that work

- **Model-then-record loop**: 🔊 play the sentence → 🎤 learner reads it → transcript vs target. The model answers "how should it sound?" before asking them to produce it.
- **Read-aloud check**: show text, judge transcript (intelligibility framing above).
- **Voice-answer**: show a question, accept spoken answers against a generous list (see `language-authoring`).
- **Dictation** ("type what you hear"): THE exercise for languages where sound length/quantity changes meaning (Finnish *tuli/tuuli/tulli*, Japanese vowel length…). Pure TTS + text input — no recognition needed.
- **Minimal pairs**: play/read two near-identical words; identify or produce the difference.
- **Listen-then-answer**: TTS a passage, comprehension questions after — no transcript shown.

## Testing without a microphone

Everything except the actual mic grant is testable headless: drive the internal result handlers directly (call the judge function with fake transcripts via DevTools/preview eval), verify error-message mapping by dispatching each error code, check voice pickers with `speechSynthesis.getVoices()`. The one thing only a human can verify is the live mic permission + real speech — say so explicitly when handing over.

A complete working implementation of all of the above (worksheet with 🔊/🎤 items, export, fallbacks): `tutor/template.html` in https://github.com/chocolatetriflesgit/Finnish-learning — companion skill: `language-authoring`.
