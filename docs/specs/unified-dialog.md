# SPEC: Unified `Dialog` component (replaces `Modal` + `Drawer`)

Status: proposed
Tracking issue: jetrockets/jet_ui#12

## User story

> As a user of Jet UI, I want `modal` and `drawer` to be one `dialog` component. I want to open an
> unlimited number of dialogs nested inside each other, on top of the native `<dialog>` element,
> while choosing `position: center | left | right | top | bottom` to emulate a drawer.
>
> Async pages must keep the plain link syntax `data: { turbo_frame: :dialog }` — even though the
> dialog and its frame are now created on the fly instead of living in the layout.

## 1. Current state

### 1.1 Two parallel implementations of the same thing

`app/components/ui/modal/` and `app/components/ui/drawer/` are near-identical copies:

| Concern | Modal | Drawer |
| --- | --- | --- |
| Root component | `Ui::Modal::Component` | `Ui::Drawer::Component` |
| Sub-components | `HeaderComponent`, `BodyComponent`, `FooterComponent` | identical trio, duplicated |
| Per-dialog Stimulus controller | `modal_controller.js` | `drawer_controller.js` (+ swipe) |
| Stack/manager controller | `modals_controller.js` | `drawers_controller.js` |
| CSS | `modal.css` (`.modal__*`) | `drawer.css` (`.drawer__*`) — same BEM tree |
| Async turbo frame | `turbo_frame_tag :modal` in layout | `turbo_frame_tag :drawer` in layout |
| Animation | `animate-slide-up` | `animate-slide-left` |

`Ui::Drawer::FooterComponent` and `Ui::Modal::FooterComponent` are byte-for-byte identical apart
from the CSS prefix. Every bug fix and every new prop has to be written twice.

### 1.2 Only one dialog can be open at a time

Both components support two modes, and both cap the stack at one:

* **Async mode** (`data: { turbo_frame: :modal }`): the layout hosts exactly one
  `<turbo-frame id="modal">` and one `<turbo-frame id="drawer">`
  (`app/views/layouts/application.html.erb`). Turbo resolves the link's target by
  `document.getElementById("modal")`, so navigating that frame again *replaces* the currently open
  dialog instead of stacking on top of it. `ModalController#close` does
  `ModalController.turboFrame.src = null` — a single global frame reference, so a nested dialog
  would tear down its own parent.
* **Sync mode** (`id:` + `click->modals#show`): `ModalsController` keeps a single
  `this.openedDialog` field. Opening a second dialog overwrites it, so the first dialog's backdrop
  and `touch*` listeners are leaked and `close` targets the wrong element.

Native `<dialog>.showModal()` already stacks correctly in the browser top layer — the limitation is
purely in our wiring.

### 1.3 Position is baked into the component identity

"Drawer" means "right edge" and nothing else. `left`, `top` and `bottom` drawers are not
expressible; `.drawer` hardcodes `fixed inset-0 left-auto` + `rounded-tl-modal rounded-bl-modal`
and the swipe gesture is hardcoded to the X axis.

### 1.4 Flash is painted *below* any open dialog

`Ui::Flash::Component` renders `<turbo-frame id="flash" class="fixed … z-[100]">` in `<body>`
(`app/components/ui/flash/component.html.erb`).

A dialog opened with `showModal()` is promoted to the **top layer**, which sits above the entire
z-index stacking context of the document, *and* marks everything outside the dialog subtree as
inert. Consequences today:

* a flash raised by a form submitted from inside a dialog is invisible — it is painted behind the
  dialog and behind its `::backdrop`;
* even if it were visible, its dismiss button would be non-interactive because the rest of the
  document is inert while a modal dialog is open.

This is the risky part of the refactor and needs an explicit mechanism, not a `z-index` bump — no
value of `z-index` can beat the top layer.

### 1.5 Other current consumers

* `Ui::TurboConfirm::Component` renders `ui.modal id: "turbo-confirm"` with a `method="dialog"`
  form. It must be able to appear **above** an already-open dialog (e.g. a destructive action
  inside a drawer).
* `<body data-controller="sidebar modals drawers highlight">` wires both managers globally.

## 2. Goals

1. One component — `Ui::Dialog::Component` — with `position: :center | :left | :right | :top | :bottom`.
2. Unlimited nesting: a dialog opened from inside a dialog stacks above it; closing pops one level
   and restores focus to the trigger.
3. Native `<dialog>` + `showModal()` as the only mechanism (top layer, focus trap, `Esc`,
   `::backdrop`, focus restore come for free).
4. **Keep the declarative link syntax** `data: { turbo_frame: :dialog }`. Authors must not have to
   allocate frame ids, wire Stimulus actions or know that the frame is created at click time.
5. Flash / toasts always visible **and interactive** above the whole dialog stack.
6. Backwards-compatible deprecation path for `ui.modal` / `ui.drawer` and for the existing
   `turbo_frame: :modal` / `:drawer` link values.

## 3. Non-goals

* Non-modal (`show()`) dialogs, popovers and dropdowns — unchanged, out of scope.
* Redesigning the visual language. Existing `.modal__*` visuals are the baseline for `.dialog__*`.
* A `<turbo-stream action="dialog">` server-driven open. Nice to have, tracked separately.
* Reflecting dialog state in browser history (see open question 6).

## 4. Public API

### 4.1 Component

```erb
<%= ui.dialog(
      title: "Edit profile",
      subtitle: "Update your account details",
      position: :right,     # :center (default) | :left | :right | :top | :bottom
      size: :lg,            # sm md lg xl 2xl(default) 3xl 4xl 5xl 6xl | :full
      id: "edit-profile",   # required only for sync dialogs
      closable: true,       # render the × button
      dismissible: true,    # allow Esc + backdrop click to close
      swipe: true           # swipe-to-dismiss on touch, edge positions only
    ) do %>
  <%= ui.dialog_body do %>…<% end %>
  <%= ui.dialog_footer(justify: :end) do %>…<% end %>
<% end %>
```

`ui.dialog_header`, `ui.dialog_body`, `ui.dialog_footer` keep the exact prop lists of the current
`modal_*` / `drawer_*` sub-components (`direction`, `align`, `justify`, `bordered`, `class`).

### 4.2 Semantics of `position` and `size`

| `position` | Anchoring | `size` controls | Enter animation | Swipe axis |
| --- | --- | --- | --- | --- |
| `:center` | centered, `h-fit` | width | slide-up + fade | — |
| `:right` | `inset-y-0 right-0`, full height | width | slide from right | → |
| `:left` | `inset-y-0 left-0`, full height | width | slide from left | ← |
| `:top` | `inset-x-0 top-0`, full width | height | slide from top | ↑ |
| `:bottom` | `inset-x-0 bottom-0`, full width | height | slide from bottom | ↓ |

Corner radii follow the anchored edges (`:right` → `rounded-l-modal`, `:bottom` → `rounded-t-modal`,
`:center` → `rounded-modal`).

`ui.drawer(...)` ≡ `ui.dialog(position: :right, ...)`; `ui.modal(...)` ≡ `ui.dialog(position: :center, ...)`.

### 4.3 Triggers

**Async — unchanged link syntax:**

```erb
<%= ui.btn "Edit", url: edit_post_path(post), data: { turbo_frame: :dialog } %>

<%# still works — presets position, deprecated %>
<%= ui.btn "Edit", url: edit_post_path(post), data: { turbo_frame: :modal } %>
<%= ui.btn "Edit", url: edit_post_path(post), data: { turbo_frame: :drawer } %>
```

Works on `a`, `button` and `form` (via `data-turbo-frame` on the form or on the submitter).

**Sync — dialog markup already on the page:**

```erb
<%= ui.btn "Open", data: { action: "click->dialogs#open", dialogs_id_param: "edit-profile" } %>
```

### 4.4 JS API and events

`window.JetUI.dialogs` → `open({ url, position, size, id })`, `close(id?)`, `closeAll()`, `stack`.

Events bubble from the `<dialog>` element: `jet-ui:dialog:open`, `jet-ui:dialog:opened`,
`jet-ui:dialog:close`, `jet-ui:dialog:closed`, each with `detail: { id, depth, position }`.

## 5. Architecture

### 5.1 Files

```
app/components/ui/dialog/
├── component.rb            # Ui::Dialog::Component
├── header_component.rb
├── body_component.rb
├── footer_component.rb
├── dialog.css              # .dialog, .dialog-<position>, .dialog__{header,body,footer,close}
├── dialog_controller.js    # per-<dialog> behaviour: backdrop click, swipe, close, cleanup
├── dialogs_controller.js   # stack manager on <body>: frame adoption, depth, flash portal
└── component.yml
```

Removed after the deprecation window: `app/components/ui/modal/*`, `app/components/ui/drawer/*`.

### 5.2 Layout

```erb
<body data-controller="sidebar dialogs highlight">
  …
  <%= ui.flash %>
  <%= ui.turbo_confirm %>

  <div id="dialogs" data-dialogs-target="root" data-turbo-permanent data-turbo-cache="false">
    <%# the sentinel: the only frame a link can address by id %>
    <%= turbo_frame_tag :dialog, data: { dialogs_target: "sentinel" } %>
  </div>
</body>
```

`turbo_frame_tag :modal` and `turbo_frame_tag :drawer` are replaced by a **single sentinel frame**
`<turbo-frame id="dialog">`, which is what `data-turbo-frame="dialog"` resolves to. It is never the
frame that stays open — it is adopted, filled, renamed and respawned on every open (§5.3).

`data-turbo-permanent` keeps the open stack alive across a morph refresh; `data-turbo-cache="false"`
keeps stale dialogs out of Turbo Drive cache previews.

### 5.3 Async open flow — sentinel frame adoption

This is the crux of the change: Turbo resolves `data-turbo-frame="dialog"` by
`document.getElementById("dialog")` at click time, so a frame created *after* the click would never
be found. Instead of creating a frame, we **adopt the existing sentinel into a freshly created
`<dialog>` shell before Turbo runs**, and rename it once loaded.

1. `DialogsController` registers its interceptor on **`window` with `capture: true`**. Capture
   propagation is `window → document → … → target`, and Turbo intercepts clicks on `document`, so
   our handler is guaranteed to run **before** Turbo sets the frame's `src`.
2. The handler resolves
   `event.target.closest('[data-turbo-frame="dialog"], [data-turbo-frame="modal"], [data-turbo-frame="drawer"]')`
   (for `submit`, the submitter's `data-turbo-frame` wins over the form's). It reads
   `data-dialog-position` / `data-dialog-size`, defaulting from the frame alias
   (`modal` → `:center`, `drawer` → `:right`, `dialog` → `:center`).
3. It does **not** `preventDefault` — Turbo must still perform the navigation. Synchronously it:
   * builds the shell and appends it to `#dialogs`;
   * **moves the sentinel frame node into the shell's panel** (`panel.append(sentinel)`);
   * calls `shell.showModal()`, pushes onto `stack`, re-portals flash (§6).

   ```html
   <dialog class="dialog dialog-right" data-controller="dialog"
           data-dialog-position-value="right" data-dialog-depth-value="1"
           data-dialog-remote-value="true">
     <div class="dialog__panel">
       <turbo-frame id="dialog" data-dialogs-pending>
         <!-- skeleton / spinner -->
       </turbo-frame>
       <div data-dialogs-target="flashSlot"></div>
     </div>
   </dialog>
   ```
4. Turbo's own listener then runs, finds `#dialog` (now inside the open shell), sets `src` and
   fetches with the `Turbo-Frame: dialog` header.
5. Server side: `Ui::Dialog::Component` detects `helpers.turbo_frame_request?` and renders
   `turbo_frame_tag :dialog` + header/body/footer — **no** `<dialog>` element, because the shell
   already exists on the client. The frame id is always the literal `dialog`, so the server never
   needs to know the stack depth. Outside a frame request it degrades to an inline page section
   (today's `.modal-page` behaviour).
6. On `turbo:frame-load` for that frame the manager **promotes** the level:
   * `frame.id = "dialog-#{++counter}"` and `data-dialogs-pending` is dropped — the level now owns a
     uniquely identified frame;
   * a **fresh** `<turbo-frame id="dialog">` sentinel is appended to `#dialogs`, freeing the id for
     the next level.

**Why the rename is required.** Two open levels both carrying `id="dialog"` would make
`getElementById` return the first one, so closing level 2 would orphan level 1's frame — precisely
the bug class that limits the current implementation to one dialog.

**Why the rename is safe.** Links and forms *inside* a dialog resolve `_self` by DOM ancestry, not
by id, so they keep re-rendering their own level. The only thing that resolves by id is an explicit
`data-turbo-frame="dialog"`, which now hits the fresh sentinel — i.e. it opens a nested dialog,
which is exactly the desired semantic.

Net effect: `<%= ui.btn "Edit", url: …, data: { turbo_frame: :dialog } %>` inside a dialog opens the
next level, with no ids to manage and no depth limit.

### 5.4 Turbo frame lifecycle and edge cases

| Situation | Behaviour |
| --- | --- |
| Double / rapid click on the same trigger | The sentinel is marked `data-dialogs-pending` on adoption. A click that resolves to a *pending* sentinel does **not** create a second shell — Turbo simply re-navigates the same frame, preserving today's "replace at the same level" behaviour. |
| `turbo:frame-missing` (redirect to sign-in, error page, response without the frame) | Close and remove the shell, restore a clean sentinel to `#dialogs`, then let Turbo fall back to its `_top` visit. Never leave an empty dialog on screen. |
| `turbo:fetch-request-error` | Same teardown, plus a flash with the failure. |
| Server responds with a full page (no matching frame) | Same as `turbo:frame-missing`. |
| Link inside a dialog with `data-turbo-frame="_top"` | Full navigation; `closeAll()` runs on `turbo:before-visit`. |
| `turbo:before-cache` | `closeAll()`; `#dialogs` also carries `data-turbo-cache="false"` so a restored preview never flashes a stale dialog. |
| Morph refresh (`turbo_refreshes_with method: :morph`) while dialogs are open | `#dialogs` is `data-turbo-permanent`, so the open stack survives; the flash frame is un-portaled before render and re-portaled after (§6.2). |
| Frame `src` reset | No longer needed. Closing a level removes its whole subtree (shell + its renamed frame), so there is no shared frame to reset — unlike today's `turboFrame.src = null`. |
| Nested dialog rendering another dialog server-side | Invariant: at most one `<turbo-frame id="dialog">` exists at any time, and it is either free in `#dialogs` or `data-dialogs-pending` inside the newest shell. |

### 5.5 Sync open flow

`ui.dialog(id: "x")` renders a closed `<dialog id="x" data-controller="dialog">` in place.
`dialogs#open` with `dialogs_id_param` looks it up, pushes it on the stack and calls `showModal()`.
On close it is **not** removed from the DOM (unlike remote dialogs) so it can be reopened.

### 5.6 Close flow

`dialog#close()` → `element.close()`. The native `close` event drives the teardown so that `Esc`
and `<form method="dialog">` follow the same path:

1. pop from `stack` (assert it is the top; otherwise close descendants first);
2. detach listeners;
3. if `remote`, remove the shell — including its renamed frame — from the DOM;
4. re-portal flash to the new top of the stack, or back to `<body>` when the stack is empty;
5. dispatch `jet-ui:dialog:closed`. Focus restore is native.

`dialogs#closeAll` runs on `turbo:before-visit` / `turbo:before-cache`, so a full page navigation
never leaves orphaned dialogs or frames behind.

### 5.7 Backdrop of a stack

Only the **bottom-most** dialog paints the dimmed `::backdrop` (`bg-overlay`); every nested dialog
gets a transparent backdrop, driven by `data-dialog-depth-value`:

```css
.dialog::backdrop { background: var(--overlay); }
.dialog[data-depth]:not([data-depth="0"])::backdrop { background: transparent; }
```

Otherwise five nested dialogs stack five overlays and the page goes black.

### 5.8 CSS containing-block constraint (important)

The `<dialog>` element itself must never carry `transform`, `translate`, `scale`, `filter`,
`backdrop-filter`, `perspective`, `contain` or `will-change` — neither at rest **nor during the
enter/leave animation**. Any of those makes the `<dialog>` a containing block for
`position: fixed` descendants, which would break the flash portal (§6) and the sticky
header/footer. All motion is therefore applied to the inner `.dialog__panel` wrapper, and the
current `animate-slide-*` classes move from the dialog to the panel.

Entry/exit uses `@starting-style` + `transition-behavior: allow-discrete` on `display` and
`overlay` so the leave animation is not cut off by the top-layer removal.

## 6. Flash above the dialog stack

### 6.1 The constraint

The top layer is not part of the z-index tree: no `z-index` can lift `<body>` content above an
open modal dialog. In addition, `showModal()` makes everything outside the topmost dialog subtree
inert, so even a visible toast would be unclickable.

### 6.2 Chosen approach — portal the flash container into the topmost dialog

`DialogsController` owns the flash container (`turbo-frame#flash`) and moves it:

* on open → into the `[data-dialogs-target="flashSlot"]` of the newest shell (a zero-size slot
  rendered at the end of every `.dialog__panel`);
* on close → to the new top dialog, or back to `<body>` when the stack empties.

Because the frame is then a descendant of the topmost (non-inert) dialog, it is painted in the top
layer **and** fully interactive. It keeps `position: fixed` and stays viewport-anchored — this is
exactly why §5.8 forbids transforms on the `<dialog>` element.

Turbo interactions to handle explicitly:

* the frame keeps `id="flash"`, so `turbo_stream.update :flash` / `target: :_top` keep working from
  any nesting depth, including a form submitted inside dialog N;
* on `turbo:before-render` and `turbo:before-morph` the frame is moved back to `<body>` and
  re-portaled after render, so morphing never sees it in an unexpected parent;
* `refresh: :morph` on the frame is preserved.

### 6.3 Alternative considered — `popover="manual"` (top layer, no DOM move)

`<div id="flash" popover="manual">` + `showPopover()` also lands in the top layer, and re-promoting
it (`hidePopover(); showPopover()`) after each dialog open keeps it above the stack. No DOM
relocation and no Turbo morph conflicts.

Rejected as the primary mechanism because a popover outside the topmost dialog is still **inert**
while a modal dialog is open: the toast would be visible but its dismiss button dead (auto-dismiss
would still fire). Keep as a documented fallback if the portal proves fragile with Turbo morphing.

### 6.4 `turbo_confirm`

`Ui::TurboConfirm::Component` becomes `ui.dialog id: "turbo-confirm", position: :center` and is
opened through `dialogs#open`, so a confirmation raised from inside a drawer stacks above it
instead of replacing it.

## 7. Migration

| Old | New | Window |
| --- | --- | --- |
| `ui.modal(...)` | `ui.dialog(position: :center, ...)` | shim, deprecation warning |
| `ui.drawer(...)` | `ui.dialog(position: :right, ...)` | shim, deprecation warning |
| `ui.modal_header/body/footer` | `ui.dialog_header/body/footer` | shim |
| `data: { turbo_frame: :modal }` | `data: { turbo_frame: :dialog, dialog_position: :center }` | alias kept, presets `:center` |
| `data: { turbo_frame: :drawer }` | `data: { turbo_frame: :dialog, dialog_position: :right }` | alias kept, presets `:right` |
| `click->modals#show` | `click->dialogs#open` | alias action, warns |
| `click->drawers#show` | `click->dialogs#open` | alias action, warns |
| `turbo_frame_tag :modal` / `:drawer` in layout | `turbo_frame_tag :dialog` sentinel in `#dialogs` | layout change |
| `.modal__*` / `.drawer__*` CSS | `.dialog__*` | old classes aliased |

Because `modal` and `drawer` stay valid values of `data-turbo-frame`, **existing async links need no
edits at all** — they keep opening, now with a real stack underneath.

`ui.modal` / `ui.drawer` stay as thin subclasses of `Ui::Dialog::Component` that only preset
`position`, emit `ActiveSupport::Deprecation` and are dropped in the next major.

## 8. Acceptance criteria

1. `ui.dialog` renders a native `<dialog>` for all five positions and matches the current visual
   design for `:center` (was modal) and `:right` (was drawer).
2. A link with `data: { turbo_frame: :dialog }` opens an async dialog with no Stimulus action on the
   link; `:modal` and `:drawer` keep working and preset `:center` / `:right`.
3. Opening a dialog from a link **inside** an open dialog stacks it above; the parent stays mounted
   and re-appears unchanged when the child closes. Verified at depth ≥ 3.
4. At any moment exactly one `<turbo-frame id="dialog">` exists in the document — free in `#dialogs`
   or pending inside the newest shell — and every open level owns a uniquely-id'd frame.
5. A form inside dialog N targeting `_self` re-renders only dialog N and leaves the rest of the
   stack untouched.
6. `turbo:frame-missing`, a fetch error, or a full-page response tears the shell down, restores a
   clean sentinel, and never leaves an empty dialog on screen.
7. `Esc` and a backdrop click close only the topmost dialog (and only when `dismissible: true`).
8. Closing a dialog restores focus to the element that opened it.
9. Exactly one dimmed backdrop is visible regardless of stack depth.
10. A flash raised from a form submitted inside a dialog at any depth is **visible and clickable**
    above the whole stack, and its auto-dismiss works.
11. Flash survives a Turbo morph refresh while a dialog is open, and ends up back in `<body>` after
    the stack empties.
12. `turbo_confirm` opens above an already-open dialog and returns its value to Turbo correctly.
13. Swipe-to-dismiss works on touch for `:left/:right` (X axis) and `:top/:bottom` (Y axis), and is
    disabled for `:center`.
14. Turbo navigation (`turbo:before-visit`) and caching (`turbo:before-cache`) close and clean up the
    whole stack; a cached preview never shows a stale dialog.
15. Without JS, or outside a Turbo frame request, a dialog URL renders as a normal page.
16. `ui.modal` and `ui.drawer` keep working through the shims; existing docs pages render unchanged.
17. `component.yml` documents `dialog` at `/ui/components/dialog` with a per-position preview.
18. `bundle exec rubocop`, `bundle exec erb_lint` and `npm run standard` pass.

## 9. Open questions

1. Does `size` for `:top` / `:bottom` map to height tokens, or do we add an explicit `height:` prop?
2. Should nested dialogs be visually offset/scaled (iOS-sheet style) instead of plainly overlapping?
3. Do we cap the stack depth in practice (e.g. warn after 5) to catch runaway recursion?
4. Portal vs `popover` for flash — confirm the portal survives `refresh: :morph` under real usage
   before we drop the fallback.
5. Do we want an explicit `data-dialog-replace="true"` to force "reuse the current level" for a
   trigger *inside* a dialog, instead of stacking? (The pending-sentinel rule already covers the
   double-click case, but not an intentional same-level navigation from a nested link.)
6. Should the stack be reflected in browser history so that Back closes the top dialog? Out of scope
   for the first pass, but the design should not preclude it.
