# MVP Plan — Nihongo Reader

## Objective

Build a reliable mobile demo for Japanese contextual reading and vocabulary learning.

The demo should prove the core learning loop:

> Image → OCR → Reader → Dictionary Lookup → Save Word → Flashcard Review → Stats

This is a vertical slice, not the full product.

## Milestone 1 — App Shell

Create the base Flutter app structure.

Requirements:
- Dark theme
- Home screen
- Navigation
- Feature folders
- Placeholder screens

Screens:
- Home
- OCR
- Reader
- Dictionary
- Flashcards
- Stats

Success criteria:
- App runs on Android and iOS.
- Navigation works.
- `flutter analyze` passes.

## Milestone 2 — Image Import and OCR

Implement the first technical proof.

Requirements:
- Import image from gallery.
- Capture image from camera.
- Run Japanese OCR using ML Kit.
- Show extracted text.
- Allow user to edit extracted text.
- Continue to reader with edited text.

Success criteria:
- User can import or capture an image.
- Japanese text is extracted.
- OCR text appears on screen.
- User can manually fix OCR mistakes.
- Reader screen receives the final text.

## Milestone 3 — Reader

Implement basic reading screen.

Requirements:
- Display extracted Japanese text.
- Allow user to select text.
- Add lookup action.
- Navigate/open dictionary lookup for selected text.

Success criteria:
- User can read OCR text.
- User can select Japanese text.
- Selected text can be sent to dictionary lookup.

## Milestone 4 — Local Database

Add local persistence.

Requirements:
- Add SQLite database.
- Create saved words table.
- Create review history table.
- Create basic dictionary table or bundled sample dictionary.

Success criteria:
- App can persist saved words.
- Saved words remain after app restart.
- Database code is isolated from UI.

## Milestone 5 — Dictionary Lookup Prototype

Implement local dictionary lookup.

Requirements:
- Use a small bundled sample dictionary first.
- Search by selected Japanese expression.
- Return matching dictionary candidates.
- Show expression, reading, meaning, and part of speech.

Success criteria:
- User selects text from reader.
- App shows dictionary result.
- User can choose a result to save.

## Milestone 6 — Save Flashcards

Connect dictionary lookup to flashcard saving.

Requirements:
- Save selected dictionary entry.
- Include source sentence when available.
- Include created date.
- Initialize review metadata.

Success criteria:
- User can save a dictionary result.
- Saved card appears in Flashcards screen.

## Milestone 7 — Flashcard Review

Create simple review loop.

Requirements:
- Show Japanese expression and source sentence on front.
- Show reading and meaning on back.
- Add review buttons:
  - Again
  - Hard
  - Good
  - Easy
- Update due date and review metadata.

Success criteria:
- User can review saved cards.
- Review result updates local DB.
- Reviewed cards are scheduled for later.

## Milestone 8 — Stats Dashboard

Create minimal dashboard.

Requirements:
- Total saved words
- Due today
- Total reviews
- Basic review performance

Success criteria:
- Stats reflect local database data.
- Dashboard is simple and demo-friendly.

## Explicit Non-Goals

Do not build these during MVP:

- backend
- login
- cloud sync
- payments
- subscriptions
- LLM reports
- marketplace
- Anki export
- PDF import
- manga reconstruction
- advanced gamification
- perfect tokenization
- production-level dictionary import pipeline

## Recommended Build Order

1. Bootstrap Flutter project.
2. Add app shell and navigation.
3. Add OCR image import/capture.
4. Add OCR review screen.
5. Add reader screen.
6. Add local database.
7. Add sample dictionary lookup.
8. Add save-to-flashcard.
9. Add review flow.
10. Add stats dashboard.

## Development Rule

Work incrementally.

After each milestone:
- run `flutter analyze`
- run `flutter test`
- manually run the app
- commit the working change

Avoid large agent-generated rewrites.