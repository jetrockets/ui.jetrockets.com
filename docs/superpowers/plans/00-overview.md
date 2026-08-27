## Code style (37signals-aligned)
- **Rich models, thin controllers**: state logic in models/scopes; controllers orchestrate + respond `turbo_stream`/`html`. A `NewspaperScoped` controller concern (or `Acc::BaseController`) supplies `current_member` + shared frame rendering.
- **State as records**: `IgnoredBirthday` is a record (who/when), queried via `joins`/`where.missing` — not a boolean.
- **POROs over query/service objects**: model-adjacent `Newspaper::*` read models; no `app/queries`, no service objects.
- **Bang methods, `Current` context, minimal callbacks, semantic scopes, defaults via lambdas.**
- **Deliberate deviations (project conventions win):** keep **ViewComponent** (37signals would use partials), **Pundit** (vs model predicates), **Sidekiq + sidekiq-scheduler** (vs Solid Queue), and **AR encryption** conventions. Per the 37signals skill's own rule, project conventions override its defaults.
