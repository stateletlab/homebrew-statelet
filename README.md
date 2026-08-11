# Statelet Homebrew tap

Homebrew formulae for [Statelet](https://github.com/stateletlab/statelet) — agent
memory with KV, vector search, and temporal causal graphs in one database.

```bash
brew tap stateletlab/statelet
brew install statelet
brew services start statelet
```

That installs the server binaries and the admin UI, and starts a local cluster
under launchd. Then:

| | |
|---|---|
| admin UI | <http://127.0.0.1:9380> |
| gRPC | `127.0.0.1:9379` |
| Redis protocol | `redis-cli -p 6379` |
| CLI | `statelet-cli` |

The Python client is separate: `pip install statelet-sdk`.

## How this repository is updated

`Formula/statelet.rb` is generated, not hand-written. The
[`Publish Packages`](https://github.com/stateletlab/statelet-longmemeval/blob/master/.github/workflows/publish-packages.yml)
workflow builds the release binaries, computes their SHA-256s, points the
formula at the matching GitHub Release, and pushes the result here. Edit it by
hand and the next release will overwrite you; change the generator instead.

Licensed under Apache-2.0.
