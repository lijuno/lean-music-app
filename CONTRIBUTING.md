# Contributing

Thank you for helping improve lean-music-app.

## Before opening a change

- Search existing issues and pull requests.
- Keep the app dependency-free unless a dependency has a clear security and maintenance benefit.
- Do not add scraping, media extraction, ad blocking, telemetry, undocumented YouTube APIs, or custom download behavior.
- Preserve the unmodified YouTube Music page and the visible source attribution it provides.
- Never commit credentials, cookies, signing certificates, provisioning data, or generated release bundles.

## Verify locally

```sh
./Scripts/test.sh
swift build
./Scripts/build-app.sh
./Scripts/verify-app.sh
```

For WebKit changes, use the applicable manual matrix in `docs/TESTING.md`. Never claim a manual check passed unless it was actually performed.

## Pull requests

Explain the user-visible change, risks, automated verification, manual verification, and checks still required. Keep unrelated changes separate. By contributing, you agree that your contribution is licensed under the MIT License.

Automated contributors must follow `AGENTS.md`. Architecture or product-boundary changes require a decision-log entry.
