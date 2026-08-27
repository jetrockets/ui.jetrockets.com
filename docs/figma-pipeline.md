# JetUI × Figma → Rails

Пайплайн, в котором дизайнер рисует страницу в Figma, а на выходе получается готовая
Rails-вьюха на компонентах JetUI, которую разработчик подключает к данным.

Figma: `Ultimate JR DS Beta` — `Hefn0Xzl5iTZsjU6v35TLO`

## Принятые решения

| Вопрос | Решение |
|---|---|
| Источник истины по палитре | **Figma-first.** Базовые значения берутся из `Brand colors`, `brand.css` переписывается под них |
| Модель hover / disabled / soft | **Overlay.** `Black 16%` / `Black 8%` / `Black 4%` вместо `oklch(from … calc(l - N))` |
| Шрифт | **Inter.** Правим `--font-sans` в коде |

## Архитектура

Четыре слоя, каждый следующий опирается на предыдущий:

1. **Токены** — Figma variables ↔ `brand.css`. Общий словарь.
2. **Компоненты** — паритет Figma-библиотеки и `app/components/ui/`, связанный через Code Connect.
3. **Генератор** — скилл, который читает фрейм и пишет ERB.
4. **Guardrails** — линтер + hook, физически не дающие написать кастомный CSS.

---

## Слой 1. Токены

### Что есть в Figma

- `Color tokens` (100) — примитивы, Radix 1–12: Iris, Clay, Gray, Green, Red, Amber, Blue + альфы Black/White
- `Brand colors` (19) — семантика, алиасы на примитивы, модусы Light / Dark
- `Numbers` (18) → `Spacing` (10), `Typography` (22), `Border radius` (10)
- 12 текстовых стилей, эффект `card shadow`

### Целевой brand.css

Контракт имён: Figma `Primary/Primary` → CSS `--primary` → Tailwind `bg-primary`.
Модусы `Light` / `Dark` → `:root` / `.dark`.

| CSS-переменная | Figma | Light | Dark |
|---|---|---|---|
| `--background` | `Gray/Background` | Gray 3 `#eff0f3` | Gray 1 `#111113` |
| `--foreground` | `Text/Text-primary` | Gray 12 `#1e1f24` | Gray 12 `#eeeef0` |
| `--card` | `Gray/Card` | Gray 1 `#fcfcfd` | Gray 3 `#222325` |
| `--popover` | `Gray/Card` | Gray 1 | Gray 3 |
| `--primary` | `Primary/Primary` | Iris 9 `#5b5bd6` | Iris 9 `#5b5bd6` |
| `--primary-foreground` | `Text/Text-white` | `#ffffff` | `#ffffff` |
| `--accent` | `Secondary/Secondary` | Clay 9 `#e54d2e` | Clay 9 |
| `--muted-foreground` | `Text/Text-secondary` | Gray 11 `#62636c` | Gray 11 `#b2b3bd` |
| `--border` / `--input` | `Gray/Lines` | Black 8% | White 8% (авто-инверсия) |
| `--destructive` | `State colors/Error` | Red 9 `#e5484d` | Red 9 |
| `--success` | `State colors/Success` | Green 9 `#30a46c` | Green 9 |
| `--warning` | `State colors/Warning` | Amber 8 `#e2a336` | Amber 9 `#ffc53d` |
| `--info` | `State colors/Info` | Blue 9 `#0090ff` | Blue 9 |
| `--overlay-hover` | `Conditions/Button hover` | Black 16% | White 16% |
| `--overlay-disabled` | `Conditions/Button disabled` | Black 8% | White 8% |
| `--overlay-subtle` | `Conditions/Card hover` | Black 4% | White 4% |

Инверсия Light/Dark для альф уже встроена в Figma: `Black/Black 8%` = `#000 8%` в Light
и `#fff 8%` в Dark. Отдельных dark-значений писать не нужно.

### BREAKING: смысл `secondary`

В Figma `Secondary/Secondary` = Clay 9, акцентный оранжевый. В коде `--secondary` —
светло-серый фон вторичной кнопки. Разводим:

- `Secondary/Secondary` (Clay) → `--accent`
- текущий серый `--secondary` остаётся как есть (Gray 3 / Gray 4)
- вариант кнопки `variant: :secondary` **сохраняет** текущий вид
- для акцента добавляется новый `variant: :accent`

Иначе все существующие `ui.btn variant: :secondary` молча станут оранжевыми.

### Реализация overlay-модели

`*-hover` из `theme.css` удаляются, вместо них накладывается слой поверх любого фона:

```css
.btn:hover {
  background-image: linear-gradient(var(--overlay-hover), var(--overlay-hover));
}
```

Работает на любом `background-color`, не требует пересчёта на каждый вариант и
один в один воспроизводит то, что видит дизайнер.

### Числовые шкалы — сходятся без правок

- `Border radius`: кнопки 24px→6, 36px→8, 48px→10 = множители `0.75 / 1 / 1.25`.
  Достаточно выставить `--radius-btn: 8px`, `--radius-btn-*` уже совпадают.
- `Spacing`: 0/2/4/8/12/16/24/28/32/48 — чистая 4px-шкала Tailwind.
- `Typography`: 12 стилей (headline 0–3, text, medium, description, small × regular/bold)
  маппятся на `.h1`–`.h6` из `components/typography.css` + `text-*` утилиты.

### Инструмент

`bin/jetui tokens`:
- `--pull` — читает Figma через Plugin API, сверяет с `brand.css`, падает на расхождении
- `--push` — заливает изменения из `brand.css` обратно
- `--check` — режим CI

---

## Слой 2. Компоненты и Code Connect

### Паритет

В Figma 16 компонентных страниц, в коде 29 `ui.*` + 8 form-билдеров.

Расхождения имён, которые надо свести:

| Figma | Код |
|---|---|
| `buttons` | `btn` |
| `Loader` | `spinner` |
| `Toasts` | `flash` |
| `Checkmark` | `checkbox` |
| `Search` | `text_field` + иконка |
| `Divider` | CSS-класс `.divider`, не компонент |

Нет в Figma: `card`, `modal`, `drawer`, `table`, `tooltip`, `popover`, `avatar`,
`breadcrumbs`, `empty`, `header`, `sidebar`, `navbar`, `stat`, `stepper`, `timeline`,
`list`, `clipboard`, `group`, `turbo_confirm`.

Правило именования: **Figma component properties = Ruby kwargs.** `Button` получает
свойство `variant` со значениями `default | outline | secondary | accent | danger |
ghost | link` и `size` = `xs | sm | md | lg` — ровно как в `btn/component.yml`.
Когда имена совпадают, перевод дизайна в код становится механическим.

### Манифест

`bin/jetui manifest` собирает все `component.yml` + form-билдеры в один
`jetui.manifest.json`: хелпер, props, допустимые значения, слоты, примеры.
Один файл вместо 37 обращений к диску.

### Code Connect

Каждая Figma-нода мапится на ERB-сниппет (`add_code_connect_map`, label `Markdown` —
ERB в списке нет, но шаблон отдаёт нужный текст). После этого `get_design_context`
на фрейме возвращает готовое `<%= ui.btn "Save", variant: :default %>` вместо
div-супа с хардкод-стилями. Здесь основная ценность всего проекта.

---

## Слой 3. Генератор

Скилл `/figma-page <url>`, детерминированная процедура:

1. `get_metadata` — структура фрейма
2. `get_design_context` — уже с Code Connect
3. `get_variable_defs` — какие токены задействованы
4. `get_screenshot` — визуальный референс
5. Маппинг нод на манифест, неопознанное собирается layout-обёртками
6. Запись в `app/views/ui/screens/<name>.html.erb`
7. Прогон линтера, самопочинка
8. Рендер + сравнение скриншота с Figma, итерация

Экраны живут отдельно от прикладных вьюх — дизайнер итерирует, не трогая
рабочий код. Разработчик забирает готовое и подключает данные.

---

## Слой 4. Guardrails

Три уровня, от структурного к диалоговому.

### A. Структурный

В Tailwind v4 стереть дефолтную палитру через `--color-*: initial;` в `@theme`.
Тогда `bg-gray-100` и `text-red-500` физически не скомпилируются — останутся только
семантические токены. Требует предварительного аудита существующих вьюх.

### B. Линтер `bin/jetui lint`

Разрешено:
- **layout-утилиты на обычных `<div>` / `<section>`** — `flex`, `grid`, `gap-*`, `p-*`,
  `space-*`, `items-*`, `justify-*`, `col-span-*` и брейкпоинт-варианты
- **на `ui.*` компонентах только внешняя геометрия** — `m*`, `w-*`, `max-w-*`, `flex-1`,
  `grow`, `shrink`, `self-*`, `order-*`, `hidden`, `col-span-*`

Запрещено всегда:
- `style="…"`, `<style>`
- произвольные значения `[#ff0000]`, `[12px]`, `[calc(…)]`, `!important`
- сырые цвета палитры Tailwind
- новые файлы в `app/assets/stylesheets/**` и `app/components/ui/**/*.css`
- сырые `<button>`, `<input>`, `<select>`, `<table>` вместо компонентов
- классы вида `bg-*`, `text-*`, `p-*`, `border*`, `rounded*`, `shadow*`, `font-*`,
  `ring-*` в `class:` у `ui.*`

Пример: `ui.btn "Save", class: "mt-2"` — можно. `ui.btn "Save", class: "bg-blue-600 px-8"` — нет.

Плюс path-based правило: ветка со сгенерированными экранами вообще не имеет права
трогать `app/assets/stylesheets/` и `app/components/`.

### C. Hook в Claude Code

`PostToolUse` на `Write|Edit` для `*.erb` дёргает линтер и возвращает ошибку прямо
в диалог. Агент чинит себя сам, до ревью. Это то, что превращает правило из
пожелания в закон.

---

## Порядок работ

**Этап 0 — гигиена Figma** (механика, без вкусовых решений)
- Исправить опечатки: `White/Always Whtie`, `line-hight/*` (×8), `font-size/describtion`
- Проставить `scopes` вместо `ALL_SCOPES` у всех 179 переменных; примитивы `Color tokens`
  скрыть из пикера, чтобы дизайнер выбирал только семантику

**Этап 1 — токены**
- Переписать `brand.css` по таблице выше
- Перевести `*-hover` на overlay-модель
- `--font-sans: Inter`, подключить шрифт
- Завести в Figma недостающие: `muted`, `popover`, `overlay`, `input-focus`, `ring`,
  soft/border-варианты статусов
- `bin/jetui tokens --check` в CI

**Этап 2 — документация компонентов**
- `component.yml` для 8 form-билдеров (`text_field`, `text_area`, `select`, `checkbox`,
  `radio_button`, `toggler`, `choices`, `easepick`) — сейчас они невидимы для AI,
  а формы это половина любого экрана
- `bin/jetui manifest`

**Этап 3 — паритет библиотеки**
- Свести имена компонентов и свойств
- Дорисовать недостающие в Figma
- Решить судьбу `divider`: сделать `ui.divider` или оставить CSS-классом

**Этап 4 — Code Connect** на все компоненты

**Этап 5 — guardrails**: линтер, hook, аудит вьюх, `--color-*: initial`

**Этап 6 — генератор**: скилл `/figma-page`, апгрейд `.claude/agents/frontend.md`
под манифест и линтер, визуальная верификация

**Этап 7 — обратное направление**: `generate_figma_design` — когда разработчик
добавил компонент в код, он уезжает в Figma

## Риски

- **Иконки.** 326 heroicons в коде рендерятся как `icon-<name>`. В Figma набор должен
  быть ровно heroicons с идентичными именами, иначе нужна таблица соответствий,
  которая будет вечно протухать.
- **Смена палитры затрагивает весь продукт.** Переход на Iris/Clay — не косметика,
  нужен визуальный прогон всех существующих страниц.
- **Figma MCP работает через десктоп.** `get_variable_defs` требует выделения в
  приложении; полный дамп только через Plugin API при открытом файле. Для CI нужен
  REST `GET /v1/files/:key/variables/local` — это Enterprise-план.
