## Summary

Describe the user-visible change and why it is needed.

## Risk

Describe effects on authentication, WebKit storage, navigation, playback, sandboxing, or release packaging.

## Verification

- [ ] `swift run LeanMusicAppChecks`
- [ ] `swift build`
- [ ] `./Scripts/build-app.sh`
- [ ] Relevant manual WebKit behavior tested
- [ ] No credentials, cookies, or release artifacts included
