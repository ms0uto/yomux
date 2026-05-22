# Product Spec — Nihongo Reader

## Concept

Nihongo Reader is a mobile-first Japanese reading and vocabulary learning app.

The core idea is simple:

> Scan Japanese. Read it. Tap unknown words. Save them. Review them.

Users can scan or import Japanese text from real-world content such as books, manga, menus, signs, screenshots, PDFs, or daily-life text. The app extracts the Japanese text using OCR and turns it into an interactive reader.

Each word or phrase can be looked up in a Japanese dictionary. The user can then save useful vocabulary as flashcards and review them later using spaced repetition.

## Target User

Japanese learners who want to move from textbook study to real reading.

Primary users:
- Beginner to intermediate Japanese learners
- Learners living in or visiting Japan
- Learners reading manga, novels, signs, menus, screenshots, or social media posts
- Sentence-mining users who currently use separate tools like OCR, dictionaries, and Anki

## Core Problem

Japanese learners often encounter real Japanese content but cannot read it comfortably because lookup is slow.

Current workflow is fragmented:
- take photo or screenshot
- copy text manually or run separate OCR
- search words in a dictionary
- save vocabulary manually
- create Anki cards manually
- review somewhere else

This app combines that flow into one mobile experience.

## Core Value Proposition

The app reduces friction between encountering Japanese and understanding Japanese.

User loop:

1. Scan or import Japanese text.
2. Extract text with OCR.
3. Read it inside the app.
4. Tap unknown words or phrases.
5. View reading and meaning.
6. Save useful vocabulary.
7. Review saved words as flashcards.
8. See progress.

## MVP Scope

The first version is a vertical slice, not a complete platform.

The MVP must prove this loop:

1. Import or capture one Japanese image.
2. Extract Japanese text using OCR.
3. Show the OCR result in an editable review screen.
4. Display the text in a reader screen.
5. Allow the user to select/tap Japanese text.
6. Search a local Japanese dictionary.
7. Save selected vocabulary as flashcards.
8. Review saved flashcards.
9. Show a basic progress dashboard.

## Out of Scope for MVP

Do not implement these in the first version:

- user accounts
- backend
- cloud sync
- payments
- subscription system
- marketplace
- teacher/creator tools
- LLM progress reports
- complex gamification
- manga panel reconstruction
- PDF import
- Anki export
- perfect Japanese tokenization
- social features
- web version

## Main Screens

### Home

Main entry point.

Actions:
- Scan Japanese
- Import Image
- Flashcards
- Stats

### OCR Capture / Import

Allows the user to:
- take a photo using the camera
- import an image from gallery

### OCR Review

Displays extracted Japanese text.

The user can:
- review OCR result
- manually edit text
- continue to reader

### Reader

Displays the extracted Japanese text in a clean reading interface.

The user can:
- tap/select Japanese text
- open dictionary lookup
- save selected words as flashcards

### Dictionary Lookup

Shows dictionary candidates.

Each candidate should show:
- expression
- reading
- meaning
- part of speech if available

The user can save the selected entry.

### Flashcards

Shows saved vocabulary.

Flashcard front:
- Japanese expression
- source sentence

Flashcard back:
- reading
- meaning

Review buttons:
- Again
- Hard
- Good
- Easy

### Stats

Minimal dashboard:
- total saved words
- reviews completed
- due today
- accuracy or review distribution

## Technical Direction

Use:
- Flutter
- Android and iOS only
- Local-first architecture
- ML Kit for OCR
- SQLite for local persistence
- Bundled local dictionary data

Avoid:
- backend dependencies
- authentication
- cloud sync
- heavy architecture
- premature monetization features

## Dictionary Strategy

The app should eventually use a JMdict-derived local dictionary.

For the first implementation, it is acceptable to use a small bundled sample dictionary to prove the lookup flow.

Dictionary lookup does not need perfect Japanese NLP in the MVP.

Acceptable MVP behavior:
- user selects/taps text
- app searches exact or prefix matches
- app displays candidate entries
- user chooses which one to save

## Product Principle

The MVP should feel like a working learning loop, not a collection of isolated technical demos.

Priority:

1. Reliable scan/import
2. Reliable OCR result display
3. Fast dictionary lookup
4. Easy save-to-flashcard
5. Simple review loop
6. Basic progress visibility