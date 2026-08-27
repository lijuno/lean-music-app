# Testing

## Automated verification

Run these commands from the repository root:

```sh
./Scripts/test.sh
swift build
./Scripts/build-app.sh
./Scripts/verify-app.sh
```

Expected packaging results:

- Swift Testing passes.
- The executable builds with Swift 6.1 or later.
- The app signature verifies.
- Entitlements contain `com.apple.security.app-sandbox` and `com.apple.security.network.client`, with no broader file or server access.
- Architectures contain both `arm64` and `x86_64`.
- `Info.plist` retains the product name, bundle identifier, and macOS 14 minimum from `AGENTS.md`.

CI performs the automated subset on every pull request and default-branch push.

## Manual WebKit matrix

Never automate Google login using real credentials. Use a non-sensitive test account when manual authentication testing is necessary, and never capture cookies or account identifiers in logs or screenshots.

Record the app version, macOS version, Mac architecture, Safari version, account type/region when relevant, and result for each applicable scenario.

| Area | Scenario | Expected result |
| --- | --- | --- |
| First run | Open with no stored website data | YouTube Music loads without an unsupported-browser page |
| Authentication | Sign in, quit, and relaunch | Session remains signed in |
| Accounts | Log out, sign in again, and switch accounts | Website-controlled flows complete in-app |
| Popups | Trigger an authentication popup | Trusted Google/YouTube destination remains usable |
| Navigation | Activate an unrelated HTTPS link | Link opens in the default browser |
| Navigation | Attempt automatic external navigation | Navigation is blocked |
| Playback | Start audio, minimize the window | Playback continues |
| Playback | Close the window and reopen from Dock | Playback continues and the same web view reappears |
| Playback | Choose Quit | Process and playback stop |
| Storage | Relaunch the same bundle version | Cookies and website storage persist |
| Storage | Confirm website-data reset | Session and WebKit data are removed and home reloads |
| Storage | Cancel website-data reset | Existing session remains untouched |
| Connectivity | Disconnect during an uncached page failure | Native offline limitation appears |
| Accessibility | Navigate native controls by keyboard and VoiceOver | Controls have useful labels and usable focus order |
| Appearance | Check light/dark modes and minimum window size | Toolbar and warning remain readable |

## Release verification

In addition to the matrix, a release owner must confirm Developer ID signing, Hardened Runtime, notarization acceptance, stapling, Gatekeeper assessment, archive checksum validation, and installation on a clean macOS account. Follow `docs/RELEASING.md`; local ad-hoc builds are not public release candidates.

## Reporting results

Pull requests must distinguish automated checks, manual checks actually performed, and manual checks still required. “Not tested” is acceptable when clearly disclosed; invented results are not.
