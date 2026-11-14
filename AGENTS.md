# AGENTS.md

Instructions for AI coding agents working in this repository.

## Read first

1. `design.md` — scope, stack, architecture, data contract. It is the source of truth for _what_ to build.
2. This file — _how_ to write the code.

If a request conflicts with `design.md`, ask before coding. Do not silently expand scope.

## Repository layout

- `src/` — the Expo app (see `design.md` §3 for the layer rules).
- `server/` — FastAPI hafalan service. Do not modify unless the task is about the backend.
- `backup/` — archived Flutter app, gitignored. **Read-only reference.** Never edit, import from, or "fix" it. It exists only so behaviour can be compared.

## Commands

Run these after scaffolding; keep `package.json` scripts identical to this list.

```bash
bun install                # install (only bun.lock is committed)
bun start                  # Metro / dev client
bun run android            # local build + install
bun run ios                # local build + install
bun run lint               # eslint + prettier check
bun run lint:fix           # eslint --fix + prettier --write
bun run typecheck          # tsc --noEmit
bun run test               # jest (jest-expo)
bun expo install <pkg>     # add an Expo-compatible dependency version
bunx expo prebuild         # regenerate android/ and ios/
```

A task is not finished until `bun run lint && bun run typecheck && bun run test` passes.

## Package manager

**Bun is the only package manager.** Do not run `npm`, `npx`, `yarn`, or `pnpm` in this repo.

- One lockfile only: `bun.lock`. Never commit `package-lock.json`, `yarn.lock`, or `pnpm-lock.yaml`; delete them if they appear.
- Install Expo packages with `bun expo install <pkg>`, not `bun add` — it resolves the version matching the SDK.
- Bun does not run lifecycle scripts by default. A dependency whose `postinstall` matters (native codegen, patches, Sentry CLI) must be listed in `trustedDependencies` in `package.json`, then reinstalled from a clean `node_modules`.
- Keep `packageManager` in `package.json` and the `bun` field in `eas.json` on the same version, so the lockfile and fingerprint match in CI. If `patchedDependencies` is used, add `**/node_modules/**/.bun-tag-*` to `.fingerprintignore`.
- Bun running `expo` still requires Node.js LTS installed (template download and prebuild use `npm pack` under the hood).
- Tests run on Jest via `jest-expo`; do not switch to `bun test` (its API differs and RN testing libraries expect jest-compatible globals).

## Non-negotiable rules

**TypeScript**

- `strict` on. No `any`, no `as unknown as`, no `@ts-ignore`, no non-null `!` on values that can be absent.
- Parse, don't validate: every external payload (API, SQLite read, form input, notification data) crosses a zod schema. Types come from `z.infer`, never hand-written duplicates.
- Prefer unions over `enum`. Prefer `readonly` and immutable updates over mutation.
- No `export default` except expo-router route files and config files (`app.config.ts`, `tailwind.config.js`, `metro.config.js`).

**React**

- Components are functions with typed props. No `React.FC`, no `children: any`.
- One component per file; file name = component name in kebab-case (`surah-card.tsx`).
- `useEffect` is for synchronising with the outside world only (subscriptions, listeners, imperative natives). Never for derived state, never for fetching.
- Every subscription/effect returns its cleanup. Every async effect guards against unmount and uses `AbortController`.
- No prop drilling past two levels; use a feature hook or zustand.
- Keep hooks under ~60 lines. A hook that both fetches and formats and navigates is a design bug.
- Lists use `@shopify/flash-list`. Never `ScrollView` + `.map()` for data lists.
- No inline object/array/function props passed to memoised children in hot paths. No `useMemo`/`useCallback` by reflex; add them when measured or when a dependency array demands it.

**NativeWind**

- Styling is `className` only. No `StyleSheet.create`, no inline `style` except genuinely dynamic values (animated transforms, measured sizes).
- No hardcoded hex colours, spacing, or font sizes in JSX. Extend tokens in `tailwind.config.js` and use them (`bg-surface`, `text-muted`, `p-4`).
- Conditional classes go through `clsx`/`cn()`; no string concatenation inside `className`.
- Third-party components that need styling are wrapped once with `cssInterop` in `src/components/`, not patched at every call site.

**Data and state**

- Server data lives in TanStack Query. Never copy it into zustand or `useState`. UI state only in zustand.
- Query keys are defined once per feature; no inline array literals at call sites.
- Widgets/screens never call `fetch`, `axios`, or `db.execute` directly. They call feature hooks; hooks call repositories.
- Repositories return `Result<T, AppError>` (`src/lib/result.ts`). They never throw for expected failures and never format user-facing strings.
- Mappers between wire shape, DB row, and domain type live in `data/`. Do not scatter field renames across the codebase.
- Business rules (muraja'ah intervals, ayah numbering, prayer inputs, scoring thresholds) live in `domain/` with a test. They must not import React or React Native.

**Platform and native**

- `android/` and `ios/` are committed and generated by prebuild. Never hand-edit native files: write a config plugin, or stop and explain why a plugin is not possible.
- New native permission or service = update the config plugin + `design.md` in the same change.
- Notifications that model a series (prayer, muraja'ah) must persist their identifiers and cancel before rescheduling.
- Background work assumes the OS may kill it. Idempotent, no "run once at app start" assumptions.

**Accessibility and i18n**

- Every interactive element has an accessible role and label; icon-only buttons require `accessibilityLabel`.
- Minimum touch target 44×44 pt.
- No user-facing string literals in components. All copy goes through i18next (`id` + `en`). Missing translation = broken build assumption: add both keys in the same commit.

**Testing**

- New pure logic (calculation, parser, interval, mapper) ships with a Jest test.
- Bug fix ships with the test that would have caught it.
- Tests assert behaviour, not implementation details (no snapshot of a whole screen, no asserting internal state names).

## Banned patterns

| Don't                                      | Do instead                                       |
| ------------------------------------------ | ------------------------------------------------ |
| `useEffect(() => { fetchX() }, [])`        | `useQuery` in a feature hook                     |
| mirroring query data into a store          | read from the query cache                        |
| `setTimeout` polling                       | query `refetchInterval` or a listener            |
| `console.log` in committed code            | the `src/lib/logger.ts` wrapper                  |
| `moment`, full `lodash` imports            | `Date` + `date-fns` subset, named imports        |
| duplicating a mapper in two features       | one mapper in `data/`, reused                    |
| a wrapper/abstraction used once            | inline it; extract at the third use              |
| `AsyncStorage` for anything large          | SQLite for data, MMKV for preferences            |
| nested ternaries in JSX                    | early return or a small `switch` component       |
| `/* TODO */` without an owner and a reason | an issue reference, or don't merge it            |
| a `shortcut:` limit left silent            | `// shortcut: <limit>, upgrade when <condition>` |

## Boundaries

- Do not touch `backup/`, `.git`, or `server/` unless explicitly asked.
- Do not add a dependency for a few lines of code. Before adding one, check it is maintained (`bun pm view <pkg> version`, repo not archived) and mention the choice in the PR description.
- Do not adopt release candidates or preview tags (e.g. `nativewind@5`).
- Do not reformat unrelated files, rename things, or "clean up" outside the task's reach.
- Ask before changing `design.md` scope, app identifier, or anything under `android/`/`ios/`.

## Definition of done

1. Change matches the requested scope, nothing extra.
2. `lint`, `typecheck`, `test` pass.
3. Layer rule holds: `presentation → domain ← data`; domain stays framework-free.
4. No new banned pattern, no duplicated logic, no dead code left behind.
5. Non-trivial logic has a test; a fixed bug has a regression test.
6. `design.md` updated if a contract, dependency, or platform behaviour changed.
