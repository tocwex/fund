# Single Ship Testing

## Poke Tests

### Basic Tests

These tests must be run on `~zod` in order to work!

```
-fund!config & /xtra/fake/hoon
=f -build-file /=fund=/lib/fund/proj/hoon
=x -build-file /=fund=/lib/fund/chain/hoon
=p *proj:f
=m *mile:f
=s *stub:f
=o *oath:f
=ad1 0x1be6.260e.5eb9.50d5.80a7.0019.6a5b.c7f1.2f4c.e3b9
=ad2 0x6e3d.b180.ad7d.ea45.08f7.766a.5c05.c406.cd6c.9dcf
=po-tes1 p(title '1', summary 'd', assessment [our 0], milestones ~[m(title '1', summary '!', cost 10.000.000) m(title '2', summary '@', cost 20.000.000) m(title '3', summary '#', cost 30.000.000) m(title '4', summary '$', cost 40.000.000)], payment (~(got by smap:x) 11.155.111 'fundUSDC'))
=si-tes1 `sigm:f`[0xa3.56fd.ca10.f4f3.62e8.814b.9283.f728.2d54.e144.5e04.d5bf.ff7b.db8a.13d6.82b7.eb1d.08d5.f7bc.b180.526b.3fad.fdca.283e.9daa.65a0.ca06.a39b.9b1d.58a7.058a.1099.981b ad1 [%& (crip (~(oath pj:f po-tes1) our))]]
:fund &fund-poke [%proj [our %tes1] %init po-tes1]
:fund &fund-poke [%proj [our %tes1] %bump %prop ~]
:fund &fund-poke [%proj [our %tes1] %bump %born ~]
:fund &fund-poke [%proj [our %tes1] %bump %prop ~]
:fund &fund-poke [%proj [our %tes1] %bump %prop `o(sigm si-tes1)]
:fund &fund-poke [%proj [our %tes1] %bump %lock `o(sigm si-tes1, xact [0 0x0], work ad2, orac ad1, safe 0x0)]
:fund &fund-poke [%proj [our %tes1] %mula %plej our 9.000.000 0 (crip "{<our>} plej")]
:fund &fund-poke [%proj [our %tes1] %mula %trib `our 9.000.000 s(xact [1 0x0]) (crip "{<our>} fill")]
:fund &fund-poke [%proj [our %tes1] %bump %work ~]
:fund &fund-poke [%proj [our %tes1] %bump %sess ~]
:fund &fund-poke [%proj [our %tes1] %bump %done `o(sigm si-tes1)]
:fund &fund-poke [%proj [our %tes1] %bump %work ~]
:fund &fund-poke [%proj [our %tes1] %mula %trib `our 2.000.000 s(xact [2 0x0]) (crip "{<our>} trib")]
:fund &fund-poke [%proj [our %tes1] %mula %trib ~ 20.000.000 s(xact [3 0x0]) (crip "anon trib")]
:fund &fund-poke [%proj [our %tes1] %mula %plej our 1.000.000 4 (crip "{<our>} pass")]
:fund &fund-poke [%proj [our %tes1] %mula %trib `our 1.000.000 s(xact [5 0x0]) '']
:fund &fund-poke [%proj [our %tes1] %mula %plej our 50.000.000 6 (crip "{<our>} plej")]
:fund &fund-poke [%proj [our %tes1] %draw 0 [7 0x0]]
:fund &fund-poke [%proj [our %tes1] %redo ~ ~]
:fund &fund-poke [%proj [our %tes2] %init p(title '5', summary '%', assessment [~nec 1.000.000], payment (~(got by smap:x) 11.155.111 'fundUSDC'), milestones ~[m(title '6', summary '^', cost 1.000.000.000.000)])]
:fund &fund-poke [%proj [our %tes2] %bump %prop ~]
:fund &fund-poke [%prof ~nec %join ~]
```

After running the above, run the following to test overage behavior:

```
=s *stub:f
:fund &fund-poke [%proj [our %test] %mula %trib `our 50.000.000 s(xact [8 0x0]) '']
:fund &fund-poke [%proj [our %test] %mula %trib ~ 100.000.000 s(xact [9 0x0]) '']
```

Here are some additional tests for `%fund-watcher` behavior:

```
-fund!config & /xtra/fake/hoon
=f -build-file /=fund=/lib/fund/proj/hoon
=x -build-file /=fund=/lib/fund/chain/hoon
=p *proj:f
=m *mile:f
=s *stub:f
=o *oath:f
=ad1 0x1be6.260e.5eb9.50d5.80a7.0019.6a5b.c7f1.2f4c.e3b9
=ad2 0x6e3d.b180.ad7d.ea45.08f7.766a.5c05.c406.cd6c.9dcf
=po-wat1 p(title 'a', summary 'd', assessment [our 0], milestones ~[m(title '1', summary '!', cost 10.000.000) m(title '2', summary '@', cost 20.000.000) m(title '3', summary '#', cost 30.000.000) m(title '4', summary '$', cost 40.000.000)], payment (~(got by smap:x) 11.155.111 'fundUSDC'))
=si-wat1 `sigm:f`[0xd0.e5fc.ba25.4858.873a.4be4.9bbc.95a2.afa4.7037.64ea.3af3.ff74.b4bd.33b4.c225.ca4f.b488.4083.d275.3e00.bd09.78a3.e725.d005.7e02.8d59.bb17.bf0f.7aac.e311.aeae.6e1b ad1 [%& (crip (~(oath pj:f po-wat1) our))]]
:fund &fund-poke [%proj [our %wat1] %init po-wat1]
:fund &fund-poke [%proj [our %wat1] %bump %prop ~]
:fund &fund-poke [%proj [our %wat1] %bump %prop `o(sigm si-wat1)]
:fund &fund-poke [%proj [our %wat1] %bump %lock `o(sigm si-wat1, xact [6.206.639 0x74.867c.d53e.46c3.1f3f.6689.c1a0.fc0b.56f0.1415.945a.aac2.ccb4.17cf.da88.b77a], work ad2, orac ad1, safe 0x980.3f08.51d4.69c1.320d.7ff0.6661.b439.f34f.463a)]
=po-wat2 p(title 't', summary 'd', assessment [our 0], milestones ~[m(title '1', summary '!', cost 1) m(title '2', summary '@', cost 2) m(title '3', summary '#', cost 3) m(title '4', summary '$', cost 4)], payment (~(got by smap:x) 11.155.111 'AZP-TEST'))
=si-wat2 `sigm:f`[0x15.cc02.0821.0c71.a304.456a.390b.a625.74cb.d1a9.9362.dd43.524c.b7f3.62b6.3267.0032.999d.471f.a520.88ed.8fe6.fb25.910f.f1bd.ac74.3b14.1d16.8ad3.097f.b37f.b554.ab1b ad1 [%& (crip (~(oath pj:f po-wat2) our))]]
:fund &fund-poke [%proj [our %wat2] %init po-wat2]
:fund &fund-poke [%proj [our %wat2] %bump %prop ~]
:fund &fund-poke [%proj [our %wat2] %bump %prop `o(sigm si-wat2)]
:fund &fund-poke [%proj [our %wat2] %bump %lock `o(sigm si-wat2, xact [6.718.436 0x574.c9b3.03a7.3b5e.443c.5080.e021.8505.58ee.bc9c.9df9.2301.7007.6552.ac77.6a3d], work ad2, orac ad1, safe 0x35bf.487f.082d.b9ea.1da0.c886.56d9.ae6e.3e82.b68e)]
=po-wat3 p(title 't', summary 'd', assessment [our 0], milestones ~[m(title '1', summary '!', cost 1) m(title '2', summary '@', cost 1)], payment (~(got by smap:x) 1 'AZP'))
=si-wat3 `sigm:f`[0xf3.f90b.c86e.e71e.cd7f.9b6f.b35b.c8b4.070a.184b.d0a5.e3bc.05aa.7a9b.ef00.93dd.8e0c.aea8.a356.a90d.14b9.0dfa.d200.05c5.fbf8.d3d1.7825.45ab.1592.6c73.0144.5b2a.611c ad1 [%& (crip (~(oath pj:f po-wat3) our))]]
:fund &fund-poke [%proj [our %wat3] %init po-wat3]
:fund &fund-poke [%proj [our %wat3] %bump %prop ~]
:fund &fund-poke [%proj [our %wat3] %bump %prop `o(sigm si-wat3)]
:fund &fund-poke [%proj [our %wat3] %bump %lock `o(sigm si-wat3, xact [20.744.577 0xa7f9.94c6.38ec.06ed.b3b6.ef9a.b643.eec3.7e39.e297.b233.134f.d8bf.7d5f.2138.1de1], work ad2, orac ad1, safe 0xb955.eab8.6a84.75b0.de09.6140.4d68.7dcb.828d.42e3)]
=po-wat4 p(title 't', summary 'd', assessment [our 0], milestones ~[m(title '1', summary '!', cost 2) m(title '2', summary '@', cost 3) m(title '3', summary '#', cost 4)], payment (~(got by smap:x) 11.155.111 'AZP-TEST'))
=si-wat4 `sigm:f`[0x7f.5932.20c8.7189.bb94.a0fa.ab37.e04f.c42b.efb5.58d1.7357.b9b9.e6be.357d.c158.532b.d2ba.302c.470b.99eb.094e.bce7.63f9.3ada.5633.91f5.32df.840c.7ab4.661f.ea19.881c ad1 [%& (crip (~(oath pj:f po-wat4) our))]]
:fund &fund-poke [%proj [our %wat4] %init po-wat4]
:fund &fund-poke [%proj [our %wat4] %bump %prop ~]
:fund &fund-poke [%proj [our %wat4] %bump %prop `o(sigm si-wat4)]
:fund &fund-poke [%proj [our %wat4] %bump %lock `o(sigm si-wat4, xact [7.205.437 0x82d7.5375.b57b.54fa.a1ae.2a73.ea11.d0ad.c462.9426.9c95.8f99.aa81.905d.be7b.2ccb], work ad2, orac ad1, safe 0xdf52.b8bb.490b.e630.dcb3.902c.43bf.237a.4b07.58a3)]
```

And run this to test `%redo` and watch path updating behavior:

```
=b p:xact:when:q:(snag 0 ~(tap by proofs:(need .^((unit proj:proj:f) %gx /=fund=/proj/(scot %p our)/wat1/noun))))
:fund &fund-poke [%proj [our %wat3] %redo `(sub b 2.000) `(add b 2.000)]
```

### Deletion Tests

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [%proj [our %test] %drop ~]
```

### Error Tests

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [%proj [our %test] %mula %plej our 30.000.000 *bloq:f (crip "{<our>} bad plej")]
:fund &fund-poke [%proj [our %test] %mula %trib `our 10.000.000 *stub:f (crip "{<our>} bad cont")]
:fund &fund-poke [%proj [our %test] %init ~]
:fund &fund-poke [%proj [our %test] %bump %born ~]
:fund &fund-poke [%proj [our %test] %bump %prop ~]
:fund &fund-poke [%proj [our %test] %bump %lock `*oath:f]
```

### Permissions Tests

Only run these commands after running all of the basic test commands.

```
>> ~zod
TODO
>> ~nec
TODO
```

## Scry Tests

Run these commands after running some number of setup commands (e.g. the basic
test commands).

### Raw Noun Tests

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

### JSON Tests

```
TODO
```

## Mark Tests

### `&fund-poke` Mark

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

# Multiple Ship Testing

Run the basic test commands on a fake `~zod` ship, then run the following on
a fake `~nec` ship:

## Poke Tests

```
:fund &fund-poke [%proj [~zod %test] %join ~]
:fund &fund-poke [%proj [~zod %test] %exit ~]
```

## eAuth Tests

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

# Enable Debug Mode

```
-fund!config & /xtra/fake/hoon
```

# Ethereum Testing

Here are some of the basic queries that can be submitted to `%chain-watcher` (a
gentle fork of `%eth-watcher`):

```
=s -build-file /=fund=/sur/chain-watcher/hoon
.^((set path) %gx /=chain-watcher=/dogs/noun)
.^((map path config:s) %gx /=chain-watcher=/dogs/configs/noun)
.^(@ %gx /=chain-watcher=/block/…/atom)
```

Here are some basic commands to track Ethereum contract interactions:

```
::  track all %fund usdc transactions on Sepolia
:chain-watcher &chain-watcher-poke [%watch path=/fund/usdc config=['https://sepolia.drpc.org' | ~s10 ~m1 5.621.625 ~ [0xb962.e45f.3381.4833.744b.8a10.2c7c.626a.98b3.2e38]~ `6 ~]]
::  track all %fund usdc transactions to a specific safe
:chain-watcher &chain-watcher-poke [%watch path=/fund/safe config=['https://sepolia.drpc.org' | ~s10 ~m1 6.227.269 ~ [0xb962.e45f.3381.4833.744b.8a10.2c7c.626a.98b3.2e38]~ `6 ~[0x0 0x0 0x1117.bfea.1e43.d16b.a9c2.6d06.1a77.a347.3908.330e]]]
::  track all %fund azp transactions to a specific safe
:chain-watcher &chain-watcher-poke [%watch path=/fund/sazp config=['https://sepolia.drpc.org' | ~s10 ~m1 5.823.305 ~ [0xabe2.8c76.e1c9.750e.b78f.32a0.7c29.5afa.99b5.57fd]~ `6 ~[0x0 0x0 0x6e3d.b180.ad7d.ea45.08f7.766a.5c05.c406.cd6c.9dcf 0x0]]]
::  cancel the tracking for a specific path
:chain-watcher &chain-watcher-poke [%clear path=/fund/usdc]
```

# Markdown Testing

Here are a few links to sample markdown that can be used for testing:

- [mxstbr's Markdown Test File](https://raw.githubusercontent.com/mxstbr/markdown-test-file/master/TEST.md)
- [Marked Demo](https://marked.js.org/demo/)
- [`markdown-it` Demo](https://markdown-it.github.io/)
