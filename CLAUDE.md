# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
bin/setup                    # bundle install, db:prepare, clear logs/tmp, then starts the server
bin/dev                      # start the app (plain `bin/rails server`, no build/watch process)
bin/rails test                                    # full test suite (Minitest, parallelized across CPUs)
bin/rails test test/models/playthrough_test.rb    # single file
bin/rails test test/models/playthrough_test.rb:12 # single test at a line
bin/rubocop                  # style check (rubocop-rails-omakase house style, config in .rubocop.yml)
bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error   # static security analysis
bin/bundler-audit            # gem vulnerability audit
bin/importmap audit          # JS pin vulnerability audit
bin/ci                       # runs the full sequence above (see config/ci.rb) plus a seed dry-run
```

To pin a new JS package (vendored, not CDN — see Architecture below):
```bash
bin/importmap pin <package>[@<version>]
```

## Architecture

Rails 8.1 app (module `RailsTesting`) — an Elden Ring item reference/tracker. SQLite + Propshaft (not Sprockets) + Solid Queue/Cache/Cable + Puma + Kamal for deploy.

### Auth (hand-rolled, not Devise)
`User` uses `has_secure_password` plus Google OAuth (`omniauth-google-oauth2`). Sessions are real DB rows (`Session belongs_to :user`), not just cookie state — `Current` (`ActiveSupport::CurrentAttributes`) holds `Current.session`/`Current.user` for the request. `app/controllers/concerns/authentication.rb` makes every controller require login by default (`before_action :require_authentication`); opt out per-controller with `allow_unauthenticated_access(**options)`. `app/controllers/concerns/authorization.rb` provides `require_admin`, included only where needed (`Admin::UsersController`). `User#role` is an enum (`standard`/`admin`).

Ownership-scoped lookups (e.g. `Current.user.playthroughs.find(params[:id])`) simply 404 via `ActiveRecord::RecordNotFound` on a foreign record — Rails' `show_exceptions = :rescuable` in `config/environments/test.rb` turns that into a plain 404 response rather than a raised exception, so controller tests assert `assert_response :not_found`, not `assert_raises`.

### Domain model: 11 "item" tables + tracking
Eleven read-only reference tables — `weapons, armors, shields, talismans, incantations, sorceries, ashes_of_war (model AshOfWar), bosses, creatures, npcs, locations` — each with a unique `uid` string (stable external key) seeded from `db/seed_data/*.json` via the `seed_model!` helper in `db/seeds.rb`. These 11 models are otherwise plain — no per-type validations/behavior.

User progress tracking is layered on top via a **single polymorphic join table**, not 11 per-type join tables:
- `Playthrough belongs_to :user`, `has_many :found_items`
- `FoundItem belongs_to :playthrough` and `belongs_to :item, polymorphic: true`
- `FoundItem::TRACKABLE_TYPES` (in `app/models/found_item.rb`) is the single registry mapping a URL-safe slug (e.g. `"weapons"`) to its model class (`Weapon`) — this is the source of truth for "which entities are trackable." **The route slug and the DB `item_type` column are different strings** (slug vs. class name) — don't conflate them.
- The `Findable` concern (`app/models/concerns/findable.rb`) gives each of the 11 item models `has_many :found_items, as: :item` — include it on any new trackable model.
- `ItemsController` is one generic controller (not 11), resolving `params[:item_type]` via `FoundItem::TRACKABLE_TYPES.fetch(slug) { raise ActiveRecord::RecordNotFound }` — a closed-hash lookup, deliberately **not** `constantize` on user input.
- Item browsing/marking-found only exists nested under a playthrough (`/playthroughs/:id/items/:item_type`) — there's no standalone item browser, since "found" is inherently playthrough-scoped.

### Frontend
Bootstrap 5 (vendored locally, not CDN — `app/assets/stylesheets/bootstrap.min.css` + JS pinned via importmap alongside `@popperjs/core`) plus Turbo/Stimulus, all wired through `config/importmap.rb` → `app/javascript/application.js` → `javascript_importmap_tags` in the layout. Views are plain ERB, no view-component or per-item-type templates — `items/show.html.erb` renders a generic `<dl class="row">` attribute dump (`@item.attributes.except(...)`) since the 11 item types have very different columns (including raw JSON columns like `dmg_negation`/`resistance`/`scales_with`, shown via `.inspect`). Flash messages render once from a shared `app/views/layouts/_flash.html.erb`, not per-view.

### Testing
Minitest + fixtures (`test/fixtures/*.yml`), **not** FactoryBot/RSpec. `test/test_helpers/session_test_helper.rb` provides `sign_in_as(user)`/`sign_out`, auto-included into `ActionDispatch::IntegrationTest`. One fixture gotcha: the `ashes_of_war` table doesn't classify back to its model (`"ashes_of_war".classify` → `AshesOfWar`, not `AshOfWar`), so `test/test_helper.rb` has an explicit `set_fixture_class "ashes_of_war" => AshOfWar` — needed for any fixture-backed table whose name doesn't singularize/classify back to its actual model.

## Versioning

App version lives in the `VERSION` file at the repo root (semantic versioning) with corresponding entries in `CHANGELOG.md` — bump both together when a change is meaningful enough to note (new feature, notable fix), not for every commit.
