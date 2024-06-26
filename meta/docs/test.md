# Single Ship Testing #

## Poke Tests ##

### Basic Tests ###

These tests must be run on `~zod` in order to work!

```
=f -build-file /=fund=/lib/fund/hoon
=p *proj:f
=m *mile:f
=s *stub:f
=o *oath:f
=c `coin:f`[11.155.111 0xb962.e45f.3381.4833.744b.8a10.2c7c.626a.98b3.2e38 %usdc %usdc 6]
=ad1 0x1be6.260e.5eb9.50d5.80a7.0019.6a5b.c7f1.2f4c.e3b9
=ad2 0x6e3d.b180.ad7d.ea45.08f7.766a.5c05.c406.cd6c.9dcf
=miz ~[m(title '1', summary '!', cost 10.000.000) m(title '2', summary '@', cost 20.000.000) m(title '3', summary '#', cost 30.000.000) m(title '4', summary '$', cost 40.000.000)]
=po1 p(title 't', summary 'd', assessment [our 0], milestones miz, currency c)
=sig 0x37.77bb.ef64.9e5e.c3e7.8923.e4c1.0b40.5c6c.1ba3.bb02.a201.6ad2.b9da.dd26.68ad.2c2a.4c43.5005.d3ca.e1f5.e59c.bbb8.658f.5431.4505.190c.5fa2.362c.1fb3.d165.ae03.4e1b
=si1 `sigm:f`[sig ad1 [%& (crip (~(oath pj:f po1) our))]]
:fund &fund-poke [[our %test] %init ~]
:fund &fund-poke [[our %test] %init `po1]
:fund &fund-poke [[our %test] %bump %prop ~]
:fund &fund-poke [[our %test] %bump %born ~]
:fund &fund-poke [[our %test] %bump %prop ~]
:fund &fund-poke [[our %test] %bump %prop `o(sigm si1)]
:fund &fund-poke [[our %test] %bump %lock `o(sigm si1, xact [0 0x0], work ad2, orac ad1, safe 0x0)]
:fund &fund-poke [[our %test] %mula %plej our 9.000.000 0 (crip "{<our>} plej")]
:fund &fund-poke [[our %test] %mula %trib `our 9.000.000 s(xact [1 0x0]) (crip "{<our>} fill")]
:fund &fund-poke [[our %test] %bump %work ~]
:fund &fund-poke [[our %test] %bump %sess ~]
:fund &fund-poke [[our %test] %bump %done `o(sigm si1)]
:fund &fund-poke [[our %test] %bump %work ~]
:fund &fund-poke [[our %test] %mula %trib `our 2.000.000 s(xact [2 0x0]) (crip "{<our>} trib")]
:fund &fund-poke [[our %test] %mula %trib ~ 20.000.000 s(xact [3 0x0]) (crip "anon trib")]
:fund &fund-poke [[our %test] %mula %plej our 1.000.000 4 (crip "{<our>} pass")]
:fund &fund-poke [[our %test] %mula %trib `our 1.000.000 s(xact [5 0x0]) '']
:fund &fund-poke [[our %test] %mula %plej our 50.000.000 6 (crip "{<our>} plej")]
:fund &fund-poke [[our %test] %draw 0 [7 0x0]]
:fund &fund-poke [[our %tes2] %init ~]
:fund &fund-poke [[our %tes2] %init `p(title '5', summary '%', image `'https://picsum.photos/200', assessment [~nec 1.000.000], milestones ~[m(title '6', summary '^', cost 1.000.000.000.000)])]
:fund &fund-poke [[our %tes2] %bump %prop ~]
```

After running the above, run the following to test overage behavior:

```
=s *stub:f
:fund &fund-poke [[our %test] %mula %trib `our 50.000.000 s(xact [8 0x0]) '']
:fund &fund-poke [[our %test] %mula %trib ~ 100.000.000 s(xact [9 0x0]) '']
```

### Deletion Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [[our %test] %drop ~]
```

### Error Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [[our %test] %mula %plej our 30.000.000 *bloq:f (crip "{<our>} bad plej")]
:fund &fund-poke [[our %test] %mula %trib `our 10.000.000 *stub:f (crip "{<our>} bad cont")]
:fund &fund-poke [[our %test] %init ~]
:fund &fund-poke [[our %test] %bump %born ~]
:fund &fund-poke [[our %test] %bump %prop ~]
:fund &fund-poke [[our %test] %bump %lock `*oath:f]
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
.^(bean %gu /=fund=/proj/(scot %p our)/test)
.^(bean %gu /=fund=/proj/(scot %p our)/gues)
.^((unit proj:f) %gx /=fund=/proj/(scot %p our)/test/noun)
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
:fund &fund-poke [[~zod %test] %join ~]
:fund &fund-poke [[~zod %test] %exit ~]
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

# Ethereum Testing #

```
=rpc 'https://eth.drpc.org'
=rpc 'https://sepolia.drpc.org'
=bloq .^(@udblocknumber %gx /=eth-watcher=/block/azimuth/noun)
=addr …
:eth-watcher &eth-watcher-poke [%watch path=/fund/xact/[addr] config=[rpc ~m1 ~m5 bloq ~ [addr]~ ~ ~]]
```

# Markdown Testing #

Here are a few links to sample markdown that can be used for testing:

- [mxstbr's Markdown Test File](https://raw.githubusercontent.com/mxstbr/markdown-test-file/master/TEST.md)
- [Marked Demo](https://marked.js.org/demo/)
- [`markdown-it` Demo](https://markdown-it.github.io/)
