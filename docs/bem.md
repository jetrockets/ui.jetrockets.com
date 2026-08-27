# BEM CSS Naming

Use BEM naming for semantic CSS classes.

BEM keeps class ownership clear: a class name should show which block it belongs to, what element it styles, and whether it represents a variant or state.

## Format

```css
.block_name {}
.block_name__element {}
.block_name__element-modificator {}
```

- `block_name` is a standalone block.
- `block_name__element` is an element that belongs to the block.
- `block_name__element-modificator` is a modified state or variant.

## Naming Rules

- Use underscores inside multi-word block names: `.content_card`.
- Use `__` for elements: `.content_card__title`.
- Use `-` for modificators: `.content_card__title-muted`.
- Do not chain elements: use `.content_card__action_button`, not `.content_card__actions__button`.

## Blocks

A block is a standalone UI unit.

Examples:

```css
.content_card {}
.details_panel {}
.item_list {}
.page_header {}
```

## Elements

An element is a part of a block.

```css
.content_card {}
.content_card__media {}
.content_card__title {}
.content_card__actions {}
```

## Modificators

A modificator describes a state or variant of a block or element.

```css
.content_card-featured {}
.content_card__action_button-disabled {}
.item_list__row-selected {}
```
