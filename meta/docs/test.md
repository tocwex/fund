# Single Ship Testing #

## Poke Tests ##

### Basic Tests ###

These tests must be run on `~zod` in order to work!

```
=f -build-file /=fund=/lib/fund/proj/hoon
=x -build-file /=fund=/lib/fund/chain/hoon
=p *proj:f
=m *mile:f
=s *stub:f
=o *oath:f
=ad1 0x1be6.260e.5eb9.50d5.80a7.0019.6a5b.c7f1.2f4c.e3b9
=ad2 0x6e3d.b180.ad7d.ea45.08f7.766a.5c05.c406.cd6c.9dcf
=miz ~[m(title '1', summary '!', cost 10.000.000) m(title '2', summary '@', cost 20.000.000) m(title '3', summary '#', cost 30.000.000) m(title '4', summary '$', cost 40.000.000)]
=po1 p(title 't', summary 'd', assessment [our 0], milestones miz, currency sepolia-usdc:coin:x)
=sig 0xd0.c895.66e4.8bc9.0bd0.e92f.f9f2.85c5.6458.d91f.ee51.0290.2d09.eae6.6908.f0b4.6443.3d19.3121.987b.842e.8ba5.d8a5.c047.c587.d6f8.8ae2.3f23.df9e.b971.6e3d.f741.921b
=si1 `sigm:f`[sig ad1 [%& (crip (~(oath pj:f po1) our))]]
:fund &fund-poke [%proj [our %test] %init po1]
:fund &fund-poke [%proj [our %test] %bump %prop ~]
:fund &fund-poke [%proj [our %test] %bump %born ~]
:fund &fund-poke [%proj [our %test] %bump %prop ~]
:fund &fund-poke [%proj [our %test] %bump %prop `o(sigm si1)]
:fund &fund-poke [%proj [our %test] %bump %lock `o(sigm si1, xact [0 0x0], work ad2, orac ad1, safe 0x0)]
:fund &fund-poke [%proj [our %test] %mula %plej our 9.000.000 0 (crip "{<our>} plej")]
:fund &fund-poke [%proj [our %test] %mula %trib `our 9.000.000 s(xact [1 0x0]) (crip "{<our>} fill")]
:fund &fund-poke [%proj [our %test] %bump %work ~]
:fund &fund-poke [%proj [our %test] %bump %sess ~]
:fund &fund-poke [%proj [our %test] %bump %done `o(sigm si1)]
:fund &fund-poke [%proj [our %test] %bump %work ~]
:fund &fund-poke [%proj [our %test] %mula %trib `our 2.000.000 s(xact [2 0x0]) (crip "{<our>} trib")]
:fund &fund-poke [%proj [our %test] %mula %trib ~ 20.000.000 s(xact [3 0x0]) (crip "anon trib")]
:fund &fund-poke [%proj [our %test] %mula %plej our 1.000.000 4 (crip "{<our>} pass")]
:fund &fund-poke [%proj [our %test] %mula %trib `our 1.000.000 s(xact [5 0x0]) '']
:fund &fund-poke [%proj [our %test] %mula %plej our 50.000.000 6 (crip "{<our>} plej")]
:fund &fund-poke [%proj [our %test] %draw 0 [7 0x0]]
:fund &fund-poke [%proj [our %test] %redo ~ ~]
:fund &fund-poke [%proj [our %tes2] %init p(title '5', summary '%', assessment [~nec 1.000.000], currency sepolia-usdc:coin:x, milestones ~[m(title '6', summary '^', cost 1.000.000.000.000)])]
:fund &fund-poke [%proj [our %tes2] %bump %prop ~]
:fund &fund-poke [%prof ~nec %join ~]
```

After running the above, run the following to test overage behavior:

```
=s *stub:f
:fund &fund-poke [%proj [our %test] %mula %trib `our 50.000.000 s(xact [8 0x0]) '']
:fund &fund-poke [%proj [our %test] %mula %trib ~ 100.000.000 s(xact [9 0x0]) '']
```

### Deletion Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [%proj [our %test] %drop ~]
```

### Error Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [%proj [our %test] %mula %plej our 30.000.000 *bloq:f (crip "{<our>} bad plej")]
:fund &fund-poke [%proj [our %test] %mula %trib `our 10.000.000 *stub:f (crip "{<our>} bad cont")]
:fund &fund-poke [%proj [our %test] %init ~]
:fund &fund-poke [%proj [our %test] %bump %born ~]
:fund &fund-poke [%proj [our %test] %bump %prop ~]
:fund &fund-poke [%proj [our %test] %bump %lock `*oath:f]
```

### Permissions Tests ###

Only run these commands after running all of the basic test commands.

```
>> ~zod
TODO
>> ~nec
TODO
```

## Scry Tests ##

Run these commands after running some number of setup commands (e.g. the basic
test commands).

### Raw Noun Tests ###

```
=f -build-file /=fund=/sur/fund/hoon
.^(? %gu /=fund=/proj/(scot %p our)/test)
.^(? %gu /=fund=/proj/(scot %p our)/gues)
.^((unit proj:proj:f) %gx /=fund=/proj/(scot %p our)/test/noun)
.^(? %gu /=fund=/meta/(scot %p our)/test)
.^(? %gu /=fund=/meta/(scot %p our)/gues)
.^((unit meta:meta:f) %gx /=fund=/meta/(scot %p our)/test/noun)
.^(? %gu /=fund=/prof/(scot %p our))
.^(? %gu /=fund=/prof/(scot %p `@p`+(`@`our)))
.^((unit prof:prof:f) %gx /=fund=/prof/(scot %p our)/noun)
.^((list addr:f) %gx /=fund=/prof/(scot %p our)/adrz/noun)
.^((unit sigm:f) %gx /=fund=/prof/(scot %p our)/addr/(scot %ux 0x0)/noun)
.^([host=(set @t) fave=(set @t) meta=(set @t) prof=(set @t)] %gx /=fund=/dbvg/brief/noun)
.^([proj=(set @t) prof=(set @t) meta=(set @t)] %gx /=fund=/dbvg/subs/noun)
```

### JSON Tests ###

```
TODO
```

## Mark Tests ##

### `&fund-poke` Mark ###

```
=f -build-file /=fund=/sur/fund/hoon
=n2p -build-tube /=fund=/noun/fund-poke
=n2pg |=(n=* !<(poke:f (n2p !>(n))))
(n2pg *poke:f)
```

```
=f -build-file /=fund=/sur/fund/hoon
=p2n -build-tube /=fund=/fund-poke/noun
=p2ng |=(p=poke:f !<(noun (p2n !>(p))))
(p2ng *poke:f)
```

# Multiple Ship Testing #

Run the basic test commands on a fake `~zod` ship, then run the following on
a fake `~nec` ship:

## Poke Tests ##

```
:fund &fund-poke [%proj [~zod %test] %join ~]
:fund &fund-poke [%proj [~zod %test] %exit ~]
```

## eAuth Tests ##

In order to test eAuth, the following test environment preparations/considerations
need to be accounted for:

- In order for the host ship to remote authenticate a given ship, the given
  ship must have had at least one successful login through its web portal.
- As of Arvo `237k`, the default `%eyre` implementation uses a 1-hour lag
  caching strategy to improve the performance of web portal requests. This
  should be removed when testing on local ships (which are frequently
  regenerated) by commenting out the `=.  time …` line in
  `/=base=/sys/vane/eyre/hoon`.
- Each ship exposes its web portal URL through the `/e/x/[time]//eauth/url`
  remote scry endpoint, which can be tested via `dojo` with the following
  command (assuming a remote ship `~zod`):
  ```
  -keen [~zod /e/x/(scot %da now)//eauth/url]
  ```
  It's good to test this endpoint as a first step when debugging issues with
  eAuth on a particular ship.

# Enable Debug Mode #

```
-fund!config & /xtra/fake/hoon
```

# Ethereum Testing #

Here are some of the basic queries that can be submitted to `%fund-watcher` (a
gentle fork of `%eth-watcher`):

```
=s -build-file /=fund=/sur/fund-watcher/hoon
.^((set path) %gx /=fund-watcher=/dogs/noun)
.^((map path config:s) %gx /=fund-watcher=/dogs/configs/noun)
.^(@ %gx /=fund-watcher=/block/…/atom)
```

Here are some basic commands to track Ethereum contract interactions:

```
::  track all %fund usdc transactions on Sepolia
:fund-watcher &fund-watcher-poke [%watch path=/fund/usdc config=['https://sepolia.drpc.org' | ~s10 ~m1 5.621.625 ~ [0xb962.e45f.3381.4833.744b.8a10.2c7c.626a.98b3.2e38]~ `6 ~]]
::  track all %fund usdc transactions to a specific safe
:fund-watcher &fund-watcher-poke [%watch path=/fund/safe config=['https://sepolia.drpc.org' | ~s10 ~m1 6.227.269 ~ [0xb962.e45f.3381.4833.744b.8a10.2c7c.626a.98b3.2e38]~ `6 ~[0x0 0x0 0x1117.bfea.1e43.d16b.a9c2.6d06.1a77.a347.3908.330e]]]
::  track all %fund azp transactins to a specific safe
:fund-watcher &fund-watcher-poke [%watch path=/fund/sazp config=['https://sepolia.drpc.org' | ~s10 ~m1 5.823.305 ~ [0xabe2.8c76.e1c9.750e.b78f.32a0.7c29.5afa.99b5.57fd]~ `6 ~[0x0 0x0 0x6e3d.b180.ad7d.ea45.08f7.766a.5c05.c406.cd6c.9dcf 0x0]]]
::  cancel the tracking for a specific path
:fund-watcher &fund-watcher-poke [%clear path=/fund/usdc]
```

# Markdown Testing #

Here are a few links to sample markdown that can be used for testing:

- [mxstbr's Markdown Test File](https://raw.githubusercontent.com/mxstbr/markdown-test-file/master/TEST.md)
- [Marked Demo](https://marked.js.org/demo/)
- [`markdown-it` Demo](https://markdown-it.github.io/)
