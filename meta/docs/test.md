# Single Ship Testing #

## Poke Tests ##

### Basic Tests ###

```
=f -build-file /=fund=/sur/fund/hoon
=p *proj:f
=m *mile:f
=s *stub:f
:fund &fund-poke [[our %test] %init ~]
=miz ~[m(title 'm1', summary 'd1', cost .100) m(title 'm2', summary 'd2', cost .200) m(title 'm3', summary 'd3', cost .300) m(title 'm4', summary 'd4', cost .400)]
:fund &fund-poke [[our %test] %init `p(title 'test', summary 'desc', assessment [our .0], milestones miz)]
:fund &fund-poke [[our %test] %bump %prop ~]
:fund &fund-poke [[our %test] %bump %born ~]
:fund &fund-poke [[our %test] %bump %prop ~]
:fund &fund-poke [[our %test] %bump %lock `*oath:f]
:fund &fund-poke [[our %test] %mula %plej our .90 0 (crip "{<our>} plej")]
:fund &fund-poke [[our %test] %mula %trib `our .90 s(xact [1 0x0]) (crip "{<our>} fill")]
:fund &fund-poke [[our %test] %bump %work ~]
:fund &fund-poke [[our %test] %bump %sess ~]
:fund &fund-poke [[our %test] %bump %done `*oath:f]
:fund &fund-poke [[our %test] %bump %work ~]
:fund &fund-poke [[our %test] %mula %trib `our .20 s(xact [2 0x0]) (crip "{<our>} trib")]
:fund &fund-poke [[our %test] %mula %trib ~ .200 s(xact [3 0x0]) (crip "anon trib")]
:fund &fund-poke [[our %test] %mula %plej our .500 4 (crip "{<our>} plej")]
:fund &fund-poke [[our %tes2] %init ~]
:fund &fund-poke [[our %tes2] %init `p(title 'test-2', summary 'desc-2', image `'https://picsum.photos/200', assessment [~nec .1], milestones ~[m(title 'm1-2', summary 'd1-2', cost .1e6)])]
:fund &fund-poke [[our %tes2] %bump %prop ~]
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
