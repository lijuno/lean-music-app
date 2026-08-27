# Roadmap

Roadmap items are intentionally small and must preserve the boundaries in `AGENTS.md` and `docs/DECISIONS.md`. GitHub Issues are the executable backlog and should contain acceptance criteria before implementation begins.

## Maintenance priorities

- Track compatibility across supported macOS and Safari/WebKit releases.
- Expand deterministic tests whenever navigation or identity behavior changes.
- Improve keyboard and VoiceOver behavior in the native toolbar and warning UI.
- Keep build, signing, notarization, and GitHub release instructions reproducible.
- Improve diagnostics only when they remain local, non-sensitive, and user-controlled.

## Explicitly out of scope

- Local audio playback or library management
- Custom YouTube downloads or offline-media extraction
- Page modification, ad blocking, scraping, or undocumented APIs
- Telemetry, analytics, accounts, or a project-operated backend
- Automatic self-updating in version 1

## Intake rule

New work belongs in a GitHub Issue labeled by risk and verification needs. Features that change a non-goal require an owner decision and a decision-log update before code is written.
