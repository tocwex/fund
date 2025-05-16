## Notes on RPC Endpoints

### Query Time for Old Projects

Using a step size of `8.150` for `1.752.907` blocks (`216` steps) took `~2m45s`
(`~.75s` per step; `9.5e-05s` per block).

This block range of `1.752.907` blocks was accumulated over the course of `244`
days (`~7185` blocks per day). If the block rate is constant, then this window
would expand to `2.622.292` blocks in a year. If the step rate is constant,
this would take `%chain-watcher` about `~4m7s` to fully query.

Thus, a `%chain-watcher` timeout of `10m` is safe for about 2.5 years of lag
time.

### Query Count for Old Projects

When performing total chain state queries over 3 older projects, the process
took about `1.500` queries (for a query width of `8.150` logs per query).

### Query Rate for All Projects

Each project queries its chain state at a rate of `~2m`. Thus, for `N` projects,
the total query rate per month is `N*86.400`, or `4.320.000` for ~50 projects.

    [%scan-herz !>(~m2)]
    [%scan-tout !>(~m10)]
