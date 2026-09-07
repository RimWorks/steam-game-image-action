# AGENTS.md

## AI usage

We don't vibecode here. Use AI if it helps, but read what it wrote and understand it before
it lands. You own what ships, whether or not a model typed it.

We can't stop anyone from working the way they want to. We can set guardrails so what lands
is as good as it can be. The rest of this file is those guardrails. Run the tests, match the
code around yours, stay inside the request, and report failures instead of guessing past them.

If AI helped with a commit in any way, add an `AI-assisted: <tool name>` trailer to the
commit message.

Agents: if the user commits by hand, remind them to add the trailer.

## Project overview

A GitHub Action that downloads a Steam game with `steamcmd` and pushes it as a private OCI
image to a registry you control, so CI can build mods against the real game assemblies and
launch the game in a container. It defaults to RimWorld (app `294100`) but works for any Steam
app you own. Most of the logic lives in `action.yml` and the bash under `scripts/`. See
`README.md` for the inputs and `examples/` for consumer workflows.

## Project structure

- `action.yml` - the composite action: inputs, outputs, and most of the logic
- `scripts/` - bash helpers: `build-image.sh`, `published-buildid.sh`, `steam-login.sh`,
  `run-headless-windows.sh`
- `Dockerfile.runtime-base`, `Dockerfile.runtime-base-proton` - the runtime base images
- `tests/` - bash tests and fixtures
- `examples/` - example workflows for consumers

## Setup & build

```bash
npm install    # devDependencies only, for semantic-release
# There is no build step. The action is action.yml plus bash.
```

## Testing

```bash
bash tests/test-published-buildid.sh   # the parser tests
shellcheck scripts/*.sh tests/*.sh     # shell lint
actionlint                             # workflow lint
```

- Run all three before committing. They are exactly what CI runs.
- Never delete, weaken, or rewrite a test to make a change pass.
- Do not claim that an interrupted or timed-out run passed.

## Code style

- Linter: shellcheck for shell, actionlint for workflows. There is no formatter, so follow the
  patterns already in neighboring scripts: `#!/usr/bin/env bash` and a short comment saying
  what the script is for.
- Do not add comments that restate the code.
- Do not reformat code you are not otherwise changing.

## Git workflow

- Work on `main`. This repo has no feature branches and no pull requests.
- Commit format: Conventional Commits, one line, lowercase.
- Never commit, push, or open a PR unless asked.
- All CI checks must pass. semantic-release tags a release from every push to `main`.

## Boundaries

- Do not modify unrelated files or widen scope beyond the request.
- Do not add dependencies without asking.
- Never commit secrets, API keys, or .env files. Steam credentials and registry tokens come
  from repository secrets.
- Never make the built game image public, and never commit game binaries. Redistributing a
  publisher's binaries is not allowed; only the tooling here is MIT.
- If a command fails, report the failure. Do not guess or present assumptions as confirmed
  results.
