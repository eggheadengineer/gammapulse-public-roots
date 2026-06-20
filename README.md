# GammaPulse — Public Merkle Roots

This repository is the public, tamper-evident anchor for [GammaPulse](https://gammapulse.tech)'s forward-tested trading-signal record.

One line is committed per trading day. The line contains:

```
YYYY-MM-DD <merkle_root_hex> <signal_count> <outcome_count> <engine_version>
```

Each day's Merkle root is computed over every `signal_ledger` and `outcome_ledger` row whose ET signal date matches that day. The `details/` directory contains the per-date JSON sidecar with the actual leaf hashes — enough information for any third party to recompute the root and verify our claims.

## How to verify

```bash
git clone https://github.com/eggheadengineer/gammapulse-public-roots
cd gammapulse-public-roots
./verify.sh 2026-06-19
```

`OK` means the published root matches the recomputed root from the details file. `MISMATCH` means we (or someone) modified the data after publication — alarm condition.

## Why this exists

Most "signal services" let you take their performance claims on faith. We don't. Every claim we make about our track record traces back to a cryptographically chained ledger, with the daily root anchored here. If we ever silently edit a historical claim, the chain breaks and the published roots no longer verify.

That's the entire point.

## Where the rest lives

- **Live signals + scoreboard:** [gammapulse.tech](https://gammapulse.tech)
- **Methodology:** [gammapulse.tech/methodology](https://gammapulse.tech/methodology) (coming soon)
- **Daily picks (free):** [X @gammapulsetech](https://x.com/gammapulsetech) · [Discord](https://discord.gg/vq9rSwmQRy)

## Disclaimer

GammaPulse provides market observations and signal analysis. It is not investment advice, an offer to buy or sell securities, or a recommendation that any security is suitable for any specific person. Past performance does not guarantee future results. Trading involves substantial risk of loss and is not suitable for everyone. We are not registered investment advisers. You are solely responsible for your own trading decisions and any resulting outcomes.
