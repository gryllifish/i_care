# ICare

Shared care of an older relative between several caregivers: which
medications they take, whether today's doses were given, by whom and when,
pill stock, and medical appointments with visit notes.

> **Work in progress.** The scaffold is in place; features are being built
> in phases (see `.claude/steering/product.md`).

**ICare does not give medical advice.** It records what caregivers do.
Every warning uses values entered by the user. Follow the instructions of
the treating doctor or pharmacist.

## Notes
- **Offline-first event log.** Every action is an immutable event, so
  devices merge by set union and conflicts (a dose given twice from two
  offline phones) show up instead of being overwritten. Design:
  [`docs/backend.md`](docs/backend.md).
- **Simulated remote, real contract.** The demo syncs through an
  in-process server with latency and an offline switch, behind the same
  `SyncGateway` a Firestore implementation will use. The demo needs no
  accounts and costs nothing to host.

## Running
```sh
flutter run --dart-define-from-file=env/dev.json   # copy env/dev.json.example first
scripts/verify.sh                                  # codegen, l10n, format, analyze, tests
```

## License
MIT
