## Summary

Describe the user-visible change and why it is needed.

Closes #

## Risk

Describe effects on authentication, WebKit storage, navigation, playback, sandboxing, or release packaging.

## Automated verification

- [ ] `./Scripts/test.sh`
- [ ] `swift build`
- [ ] `./Scripts/build-app.sh`
- [ ] `./Scripts/verify-app.sh`

List commands actually run and their results.

## Manual verification

List applicable scenarios from `docs/TESTING.md`, their environment, and results. Explicitly identify checks that still require a human.

## Handoff checklist

- [ ] I read and followed `AGENTS.md`.
- [ ] The change stays within `docs/DECISIONS.md`, or adds an approved decision entry.
- [ ] Relevant deterministic behavior has tests.
- [ ] User-visible behavior is recorded under `Unreleased` in `CHANGELOG.md`.
- [ ] No credentials, cookies, or release artifacts included
- [ ] Bundle identity, sandbox access, and navigation boundaries remain intact.
- [ ] I did not tag, sign, notarize, or publish without explicit owner authorization.
