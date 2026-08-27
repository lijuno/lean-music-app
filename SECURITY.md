# Security Policy

## Supported versions

Security fixes are provided for the latest published release.

## Reporting a vulnerability

Do not open a public issue for a suspected vulnerability. Use GitHub's **Report a vulnerability** feature in the Security tab to open a private security advisory for this repository.

Include the affected version, macOS version, impact, reproduction steps, and any suggested mitigation. Do not include Google credentials, session cookies, notarization credentials, or unrelated personal data.

You should receive an acknowledgement within seven days. Confirmed issues will be coordinated privately until a fix is available.

## Release security

Published binaries must be built from a version tag, signed with the project's Developer ID Application certificate, notarized by Apple, stapled, Gatekeeper-validated, and accompanied by a SHA-256 checksum. Signing and notarization secrets must never be committed or exposed to pull-request workflows.
