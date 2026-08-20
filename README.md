# Rails Testing — Elden Ring Item Tracker

A Rails app for browsing Elden Ring's reference data (weapons, armors, shields,
talismans, incantations, sorceries, ashes of war, bosses, creatures, NPCs, and
locations) and tracking which of them you've found across one or more
playthroughs.

## Requirements

* Ruby `ruby-4.0.6` (see `.ruby-version`)
* Rails 8.1, SQLite (via `sqlite3`), no external services required — background
  jobs, cache, and Action Cable all run through SQLite-backed Solid gems
  (`solid_queue`, `solid_cache`, `solid_cable`)

## Setup

```bash
bin/setup
```

This installs gems, prepares the database (creating it and loading the Elden
Ring reference data from `db/seed_data/*.json` on first run), clears logs/tmp,
and starts the dev server. Pass `--skip-server` to stop before starting the
server, or `--reset` to drop and recreate the database.

## Running the app

```bash
bin/dev
```

Starts the app at `http://localhost:3000`. There's no separate asset build/watch
process — Bootstrap and all JavaScript (Turbo, Stimulus) are served directly via
importmap/Propshaft with no bundling step.

## Authentication

Sign in with email/password or Google OAuth. New/returning users land on their
Playthroughs page. Admins (`User#role`) can manage other users' roles at
`/admin/users`.

## Testing

```bash
bin/rails test                                     # full suite
bin/rails test test/models/playthrough_test.rb     # a single file
bin/rails test test/models/playthrough_test.rb:12  # a single test by line
```

Tests use Minitest with fixtures (`test/fixtures/*.yml`), not FactoryBot/RSpec.

## Code quality & security

```bash
bin/rubocop           # style (rubocop-rails-omakase)
bin/brakeman          # static security analysis
bin/bundler-audit     # gem vulnerability audit
bin/importmap audit   # JS pin vulnerability audit
```

Or run everything CI runs in one go:

```bash
bin/ci
```

## Deployment

Deployed via [Kamal](https://kamal-deploy.org) — configuration lives in
`config/deploy.yml` and `.kamal/`.

## Versioning

The app's version is tracked in the `VERSION` file at the repo root, with
notable changes logged in `CHANGELOG.md`. See [`CLAUDE.md`](CLAUDE.md) for
architecture notes if you're working on this codebase with Claude Code.
