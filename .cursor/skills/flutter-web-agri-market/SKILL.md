---
name: flutter-web-agri-market
description: >-
  Enforces professional Flutter for Web development and this repo's stack and
  UI conventions (GetX, design tokens, reusable widgets, responsiveness). Use
  when writing or editing Dart/Flutter code in this project, adding screens or
  widgets, or when the user mentions Flutter Web, GetX, seller/buyer features,
  or project coding standards.
---

# Flutter Web — Agri Market project rules

## Role

Act as a **professional Flutter (Web) developer**. Apply the rules below **strictly** on every Flutter/Dart task in this repository. **Canonical Cursor rules**: `.cursor/rules/agri-market-flutter-standards.mdc` (always apply). If anything conflicts with generic advice, **follow those project rules**.

## Stack and architecture

- **State management**: GetX only — no `setState`, `StreamBuilder`, or `FutureBuilder` for app state (bindings, controllers, routes as the project already uses).
- **Widgets**: **StatelessWidget only** — do not add `StatefulWidget`.
- **Scope**: Never break existing behavior; only the exact changes requested; no drive-by refactors or unrelated edits.
- **Packages**: Use current stable versions. **Ask the user before adding** a new dependency.

## Design system

- **Colors and spacing tokens**: Always **AppColors** and **AppSizes** (or equivalent project constants); do not hardcode themeable colors/sizes. If a new token is needed, add it in the constants file and note it in the response.
- **Reusable UI**: Prefer **AppContainer**, **AppText**, **AppElevatedButton**, and other shared widgets — avoid raw Material/Cupertino for app chrome when a project widget exists.
- **AppContainer sizing**: Use **numeric literals** for dimensions/padding inside `AppContainer` (e.g. `40`), not `AppSizes.space40`-style indirection unless that file already uses it consistently.
- **New shared widgets**: Small pieces go in **separate files** under the screen’s `widgets/` folder; mention new shared widgets in the response.

## Layout and Web

- **Responsive UI**: Mandatory for Web — **Expanded**, **Flexible**, **LayoutBuilder**, constraints, breakpoints.
- **Performance**: Keep code light; avoid unnecessary rebuilds and heavy work on the UI thread.
- **Performance-first (mandatory)**: **Minimal rebuild** (narrow `Obx`), `const` where possible, no heavy work in `build()`, prefer `Get.lazyPut` / `lazyPutFind` over eager `Get.put`, controllers scoped per route/dialog with cleanup where appropriate.

## Loading & empty UX (automatic — never skip)

Apply on **every** new or edited screen, list, grid, table, and dialog — do not skip for “small” UIs:

- **Action buttons**: `AppElevatedButton(isLoading: …)` or **`AppInlineProgress`** for compact row/chip actions (`lib/common/loading/app_feature_loading_widgets.dart`).
- **Lists / grids**: skeleton while loading — e.g. **`AppSkeletonListColumn`**, `AppListSkeleton`, `AppCardGridSkeleton`, or `lib/common/loading/` helpers.
- **Empty lists**: **`AppEmptyListState`** (or the feature’s established empty widget) when data is empty and not loading.
- **Per-row actions**: controller field such as **`RxnString` `rowActionKey`** holding `"$rowId|$actionSlug"` so only that row shows a spinner.

Do **not** add Lottie or heavy animation assets for loading.

## Typography (global)

Apply consistently across screens and new widgets:

| Use              | Size | Weight   |
|------------------|------|----------|
| Caption / badges | 12px | as needed |
| Secondary        | 14px | 400–500  |
| Body / primary   | 16px | 400–500  |
| Card titles      | 18px | 500–600  |
| Section headings | 20px | 600      |
| Page headings    | 24px | 600–700  |

- **Line height**: 1.4–1.6 where configurable.
- **Overflow**: Use `maxLines` and `TextOverflow.ellipsis` where text can truncate.
- **Badges/tags**: 12px, tight padding, background sized to content.

## Workflow reminders

- Read nearby files before editing; match naming, imports, and abstraction level.
- For **UI-only** new pages: build modular section widgets; avoid touching unrelated modules.
- For **reverts**: restore specified components to prior behavior; do not redesign adjacent UI.

## When rules are unclear

Prefer matching **existing patterns in the same feature folder** over inventing new ones. If a rule cannot be satisfied without a tradeoff (e.g. GetX vs StatelessWidget), state the tradeoff briefly and follow the pattern already dominant in that screen.
