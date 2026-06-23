# AGENTS.md

## Commands
- Runtime versions: Ruby (`.ruby-version`), Rails (`Gemfile`), Node (`.node-version`). Uses Yarn Classic (`yarn.lock`) — do not introduce npm lockfiles.
- Install/update Ruby deps with `bundle install`; install JS deps with `yarn install --frozen-lockfile` when matching Docker/CI behavior.
- `bin/setup --skip-server` runs bundle install if needed, `bin/rails db:prepare`, and clears logs/tmp; it does not install JS dependencies.
- `bin/dev` only execs `bin/rails server`; it does not run the Vite server. For local UI work run Rails (`bin/rails server -p 3000`) and Vite (`yarn dev` or `bin/vite dev`, port `3036`) separately, or use `Procfile.dev` with an external process manager.
- Build Vite assets with `yarn build` or `bin/vite build`; full Rails asset build is `bundle exec rake assets:precompile`.
- JS lint is `yarn standard` (StandardJS). Ruby/ERB checks are `bin/rubocop` and `bundle exec erb_lint`; security checks are `bin/brakeman` and `bin/bundler-audit`.
- Do not assume `bin/ci` is a green all-check command: `config/ci.rb` calls `bin/importmap audit`, but this Vite app has no `bin/importmap`.
- There is currently no `test/` or `spec/` directory; verify changes with focused lint/build/boot checks unless you add tests.

## App Shape
- This is a Rails app for a reusable UI component library, not a packaged gem. Main public pages are documentation and examples under explicit routes in `config/routes.rb` (`/ui`, `/ui/*`, `/ui/form_builders/*`, `/ui/kit/*`) plus the theme builder at `/builder`.
- SQLite databases live under `storage/*.sqlite3`; `config/database.yml` is the source of truth.
- Production deploy is Kamal via `.github/workflows/01.deploy_production.yaml` and `config/deploy.yml`; image build uses `asset_path: /rails/public/vite/assets` and secrets `RAILS_MASTER_KEY`, `KAMAL_REGISTRY_USERNAME`, `KAMAL_REGISTRY_PASSWORD`.

## Components And Docs
- UI components live in `app/components/ui/<name>/`; main classes are `Ui::<Name>::Component`, and slot/subcomponents are nested `*Component` classes in the same folder.
- Components render through the `ui` helper (`app/helpers/ui_helper.rb`), which resolves helper names by constantizing `Ui::<helper.camelize>::Component` first, then nested component names. Match helper names to class paths, e.g. `ui.turbo_confirm` -> `Ui::TurboConfirm::Component`, `ui.card_header` -> `Ui::Card::HeaderComponent`.
- Component JS/CSS inside `app/components/**/*.js` and `app/components/**/*.css` is auto-imported by `app/assets/entrypoints/application.js`; put component-specific assets beside the component instead of adding manual imports.
- Documentation pages are not generated from routes automatically. Adding a documented component usually needs the component folder, `component.yml`, an explicit route/controller action, and an `app/views/ui/*.html.erb` page that calls `render_component_*` helpers.
- `component.yml` examples/previews are rendered as inline ERB by `ComponentDocsHelper`; keep snippets executable, not pseudocode. Form-builder docs are loaded from `app/components/form_builders/<name>/component.yml` even though their Ruby code lives under `app/lib/form_builders`.

## Frontend Gotchas
- Vite source root is `app/assets` (`config/vite.json`); existing JS imports use the `~` alias for paths under `app/assets`.
- Tailwind CSS 4 is configured in CSS, not `tailwind.config.js`: see `app/assets/entrypoints/tailwind.css`, `app/assets/stylesheets/tailwind/*`, and `tailwindcss_safelist.txt`.
- Stimulus controllers under `app/assets/controllers/**/*_controller.js` and component controllers are imported eagerly, but controllers register themselves with `stimulus.register(...)`; follow that pattern.
- `ApplicationHelper#form_with` sets the default `form` class and `FormBuilders::DefaultFormBuilder`; custom form fields are in `app/lib/form_builders/fields`.
