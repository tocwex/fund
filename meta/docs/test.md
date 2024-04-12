# Single Ship Testing #

## Poke Tests ##

### Basic Tests ###

```
=f -build-file /=fund=/lib/fund/hoon
=p *proj:f
=m *mile:f
=s *stub:f
=o *oath:f
=ad1 0x1be6.260e.5eb9.50d5.80a7.0019.6a5b.c7f1.2f4c.e3b9
=ad2 0x6e3d.b180.ad7d.ea45.08f7.766a.5c05.c406.cd6c.9dcf
=miz ~[m(title '1', summary '!', cost .10) m(title '2', summary '@', cost .20) m(title '3', summary '#', cost .30) m(title '4', summary '$', cost .40)]
=po1 p(title 't', summary 'd', assessment [our .0], milestones miz)
=sig 0x50.e8f5.4d20.8151.83ac.c95f.3e15.92e8.8110.f09b.1a16.a529.6374.7e80.97e2.3591.130e.72d2.c822.e831.2223.d6ee.aa13.3f8a.60cd.fd62.754f.0218.bd9f.c060.a3ee.2b9e.ae1c
=si1 `sigm:f`[sig ad1 [%& (crip (~(oath pj:f po1) our))]]
:fund &fund-poke [[our %test] %init ~]
:fund &fund-poke [[our %test] %init `po1]
:fund &fund-poke [[our %test] %bump %prop ~]
:fund &fund-poke [[our %test] %bump %born ~]
:fund &fund-poke [[our %test] %bump %prop ~]
:fund &fund-poke [[our %test] %bump %prop `o(sigm si1)]
:fund &fund-poke [[our %test] %bump %lock `o(sigm si1, xact [0 0x0], work ad2, orac ad1, safe 0x0)]
:fund &fund-poke [[our %test] %mula %plej our .9 0 (crip "{<our>} plej")]
:fund &fund-poke [[our %test] %mula %trib `our .9 s(xact [1 0x0]) (crip "{<our>} fill")]
:fund &fund-poke [[our %test] %bump %work ~]
:fund &fund-poke [[our %test] %bump %sess ~]
:fund &fund-poke [[our %test] %bump %done `o(sigm si1)]
:fund &fund-poke [[our %test] %bump %work ~]
:fund &fund-poke [[our %test] %mula %trib `our .2 s(xact [2 0x0]) (crip "{<our>} trib")]
:fund &fund-poke [[our %test] %mula %trib ~ .20 s(xact [3 0x0]) (crip "anon trib")]
:fund &fund-poke [[our %test] %mula %plej our .1 4 (crip "{<our>} pass")]
:fund &fund-poke [[our %test] %mula %trib `our .1 s(xact [5 0x0]) '']
:fund &fund-poke [[our %test] %mula %plej our .50 6 (crip "{<our>} plej")]
:fund &fund-poke [[our %test] %draw 0 [7 0x0]]
:fund &fund-poke [[our %tes2] %init ~]
:fund &fund-poke [[our %tes2] %init `p(title '5', summary '%', image `'https://picsum.photos/200', assessment [~nec .1], milestones ~[m(title '6', summary '^', cost .1e6)])]
:fund &fund-poke [[our %tes2] %bump %prop ~]
```

After running the above, run the following to test overage behavior:

```
=s *stub:f
:fund &fund-poke [[our %test] %mula %trib `our .50 s(xact [8 0x0]) '']
:fund &fund-poke [[our %test] %mula %trib ~ .100 s(xact [9 0x0]) '']
```

### Deletion Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [[our %test] %drop ~]
```

### Error Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [[our %test] %mula %plej our .30 0 (crip "{<our>} bad plej")]
:fund &fund-poke [[our %test] %mula %trib `our .10 [1 0x0 0x0] (crip "{<our>} bad cont")]
:fund &fund-poke [[our %test] %init ~]
:fund &fund-poke [[our %test] %bump %born ~]
:fund &fund-poke [[our %test] %bump %prop ~]
:fund &fund-poke [[our %test] %bump %lock `[0 0x0 0x0 0x0]]
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
