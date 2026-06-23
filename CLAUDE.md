# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Sources of truth

Check these files for the exact runtime versions:

- Ruby: `.ruby-version`
- Rails: `Gemfile` (`gem "rails"` line), `config/application.rb` (`config.load_defaults`)
- Node: `.node-version`
- JS deps and scripts: `package.json` (Yarn Classic — `yarn.lock` is the lockfile, do not introduce npm lockfiles)

## What this app actually is

A Rails app that hosts a reusable UI component library and its documentation site (it is **not** a packaged gem). Public pages are component docs and examples under explicit routes in `config/routes.rb` (`/ui`, `/ui/*`, `/ui/form_builders/*`, `/ui/kit/*`) plus a theme builder at `/builder`. SQLite databases live under `storage/*.sqlite3`; `config/database.yml` is the source of truth.

## Commands

- `bundle install` — Ruby deps. `yarn install --frozen-lockfile` — JS deps (matches Docker/CI).
- `bin/setup --skip-server` — runs bundle install if needed, `bin/rails db:prepare`, clears logs/tmp. Does **not** install JS deps.
- `bin/dev` — only execs `bin/rails server` (it does **not** also start Vite). For local UI work, run Rails (`bin/rails server -p 3000`) and Vite (`yarn dev` or `bin/vite dev`, port `3036`) in separate terminals, or use `Procfile.dev` with an external process manager.
- `yarn build` / `bin/vite build` — build Vite assets. `bundle exec rake assets:precompile` — full Rails asset build.
- Lint/security: `yarn standard` (StandardJS), `bin/rubocop` (Rails Omakase), `bundle exec erb_lint`, `bin/brakeman`, `bin/bundler-audit`.
- Do **not** assume `bin/ci` is a green all-check command: `config/ci.rb` calls `bin/importmap audit`, but this Vite app has no `bin/importmap`.
- There is currently **no `test/` or `spec/` directory**. Verify changes with focused lint/build/boot checks unless you add tests.

## Components and the `ui` helper

UI components live in `app/components/ui/<name>/`. The main class is `Ui::<Name>::Component`; slot/subcomponents are nested `*Component` classes in the same folder (e.g. `Ui::Card::HeaderComponent` in `app/components/ui/card/header_component.rb`). Base class is `ApplicationComponent` (`app/components/application_component.rb`), which extends `ViewComponent::Base` and includes `Turbo::FramesHelper`.

Components are rendered via the `ui` helper (`app/helpers/ui_helper.rb`). The helper resolves names by trying:

1. `Ui::<helper.camelize>::Component` (e.g. `ui.btn` → `Ui::Btn::Component`, `ui.turbo_confirm` → `Ui::TurboConfirm::Component`)
2. Falling back to `Ui::<first_part>::<rest>Component` (e.g. `ui.card_header` → `Ui::Card::HeaderComponent`)

When adding a helper name, **match this resolution order** — pick a class path one of those forms maps to, otherwise the helper will raise.

When authoring a component, follow the existing convention: build the class list with Rails' `class_names` helper, and accept `variant:`, `size:`, `url:`, and boolean modifiers, merging any caller-supplied `class:` (e.g. `Ui::Btn::Component` in `app/components/ui/btn/component.rb`).

The first positional `String` arg is treated as block content:

```erb
<%= ui.btn("Click me", variant: :default) %>
<%= ui.alert(title: "Warning", variant: :warning) { "Message" } %>
<%= ui.card do %>
  <%= ui.card_header { ui.card_title("Title") } %>
  <%= ui.card_body { "Content" } %>
<% end %>
```

### Per-component file layout

```
app/components/ui/<name>/
├── component.rb              # main class (Ui::<Name>::Component)
├── component.html.erb        # template (only if needed; many use call/content_tag)
├── component.css             # styles, auto-imported
├── component_controller.js   # Stimulus controller (if interactive)
├── component.yml             # docs metadata (props, slots, examples)
└── <slot>_component.rb       # nested slot/subcomponent classes
```

Component JS/CSS under `app/components/**/*.{js,css}` is **auto-imported** by `app/assets/entrypoints/application.js` via `import.meta.glob(..., { eager: true })`. Put component-specific assets next to the component — do not add manual imports.

## Documentation pages

Documentation pages are **not** generated automatically from routes or `component.yml`. To document a new component you typically need:

1. The component folder under `app/components/ui/<name>/` with `component.yml`.
2. An explicit route in `config/routes.rb` under `namespace :ui`.
3. A view at `app/views/ui/<name>.html.erb` that calls `render_component_*` helpers from `ComponentDocsHelper` (`app/helpers/component_docs_helper.rb`).

`component.yml` examples and previews are rendered as **inline ERB** by `ComponentDocsHelper` — keep snippets executable, not pseudocode. Form-builder docs are loaded from `app/components/form_builders/<name>/component.yml` even though the Ruby code lives under `app/lib/form_builders/`.

`component.yml` shape:

```yaml
name: ComponentName
description: Brief description
props:
  - name: variant
    type: Symbol
    default: ":default"
    values: [":default", ":outline"]
    description: What it controls
slots:
  - name: card_header
    description: Header slot
examples:
  - name: Basic
    code: |
      <%= ui.component_name("text") %>
```

## Form builders

The default `form_with` is wired in `app/helpers/application_helper.rb` to use `FormBuilders::DefaultFormBuilder` and add a default `form` class. Custom field implementations live in `app/lib/form_builders/fields/` (text, select, choices, easepick, toggler, check_box, radio_button, etc.). Form-builder docs live alongside `app/components/form_builders/<name>/component.yml`.

## Frontend gotchas

- Vite source root is `app/assets` (`config/vite.json`). JS imports use the `~` alias for paths under `app/assets`.
- **Tailwind CSS 4** is configured in CSS, not `tailwind.config.js`: see `app/assets/entrypoints/tailwind.css`, `app/assets/stylesheets/tailwind/*`, and `tailwindcss_safelist.txt`.
- Stimulus controllers under `app/assets/controllers/**/*_controller.js` and component controllers are eagerly imported, but each controller registers itself with `stimulus.register(...)`. Follow that pattern for new controllers.

## Auth

Uses Rodauth (`rodauth-rails` + `rodauth-omniauth`). Authenticated routes are wrapped in `constraints Rodauth::Rails.authenticate do ... end` in `config/routes.rb`.

## Deploy

Production deploy is Kamal via `.github/workflows/01.deploy_production.yaml` and `config/deploy.yml`. Image build uses `asset_path: /rails/public/vite/assets` and secrets `RAILS_MASTER_KEY`, `KAMAL_REGISTRY_USERNAME`, `KAMAL_REGISTRY_PASSWORD`.

## Custom agents

`.claude/agents/frontend.md` — for building pages from existing UI components without writing new CSS. Use the per-component `component.yml` files as the API reference.
