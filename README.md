# Qurva RN

React Native + Expo rewrite of the Qurva app (Quran reader, murattal audio, prayer times,
qibla, hafalan tracker). Portfolio slice, not feature parity with the original Flutter app,
which is archived in the gitignored `backup/` folder as a behavioural reference.

- `design.md` — scope, stack, architecture, data contract.
- `AGENTS.md` — coding rules for agents.

## Run

```bash
bun install
bunx expo prebuild      # regenerate android/ and ios/ after plugin changes
bun run android         # or: bun run ios
```

`bun run lint && bun run typecheck && bun run test` must pass before a change is done.

The hafalan compare API lives in `server/` and on
[HF Spaces](https://ssajudn-equran-hafalan-api.hf.space); the app degrades to a demo result
when it is unreachable.
