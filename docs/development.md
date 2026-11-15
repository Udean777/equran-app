# Development

## Requirements

- [Bun](https://bun.sh) 1.3.11 (the only package manager; never use npm, yarn, or pnpm)
- Node.js LTS (needed by the Expo CLI internals)
- Android Studio with an SDK and emulator or device, and JDK 17
- Xcode, only for iOS builds

## Setup

```bash
bun install
bunx expo prebuild      # regenerate android/ and ios/ after plugin or config changes
bun run android         # build, install, and start Metro
```

## Commands

| Command | Purpose |
|---|---|
| `bun start` | Metro / dev client |
| `bun run android` / `bun run ios` | Local native build and install |
| `bun run lint` | ESLint and Prettier check |
| `bun run lint:fix` | Autofix both |
| `bun run typecheck` | `tsc --noEmit` |
| `bun run test` | Jest, pinned to `TZ=Asia/Jakarta` |
| `bun expo install <pkg>` | Add an SDK-compatible dependency |

A change is done when `bun run lint && bun run typecheck && bun run test` passes. CI
(`.github/workflows/ci.yml`) runs the same three on every PR and push to `main`.

## Conventions

The binding rules are in [AGENTS.md](../AGENTS.md). In short:

- TypeScript `strict`, no `any`, zod at every boundary.
- NativeWind `className` only, with tokens from `tailwind.config.js`.
- Every user-facing string goes through i18next with both `id` and `en` keys.
- Business rules live in `domain/` with a test.
- Lists use FlashList.

## Hafalan service

The setoran scoring API is deployed at
[ssajudn-equran-hafalan-api.hf.space](https://ssajudn-equran-hafalan-api.hf.space). To run it
locally see [server/README.md](../server/README.md). Without it, setoran shows a retryable error.

## Updating screenshots

Screenshots in `docs/screenshots/` are 1080×2436 device captures used by the README. Replace the
file in place, keeping the name.
