# Single Ship Testing #

## Poke Tests ##

### Basic Tests ###

```
:fund &fund-poke [[our %test] %init-proj ~]
:fund &fund-poke [[our %test] %edit-proj `'test' `'desc' `'https://picsum.photos/200' `[our .0.01]]
:fund &fund-poke [[our %test] %edit-mile 0 `'m2' `'d2' `'https://picsum.photos/200' `.200]
:fund &fund-poke [[our %test] %init-mile 0]
:fund &fund-poke [[our %test] %edit-mile 0 `'m1' `'d1' `'https://picsum.photos/200' `.100]
:fund &fund-poke [[our %test] %init-mile 2]
:fund &fund-poke [[our %test] %drop-mile 2]
:fund &fund-poke [[our %test] %bump-proj %prop ~]
:fund &fund-poke [[our %test] %bump-proj %born ~]
:fund &fund-poke [[our %test] %bump-proj %prop ~]
:fund &fund-poke [[our %test] %bump-proj %lock `[1 0x0 0x0 0x0]]
:fund &fund-poke [[our %test] %bump-proj %work ~]
:fund &fund-poke [[our %test] %bump-proj %sess ~]
:fund &fund-poke [[our %test] %bump-proj %done ~]
:fund &fund-poke [[our %test] %bump-proj %work ~]
:fund &fund-poke [[our %test] %mula-proj %plej our .10 0 (crip "{<our>} plej")]
:fund &fund-poke [[our %test] %mula-proj %trib `our .10 [1 0x0 0x0] (crip "{<our>} cont")]
:fund &fund-poke [[our %test] %mula-proj %plej our .20 0 (crip "{<our>} plej")]
:fund &fund-poke [[our %tes2] %init-proj ~]
:fund &fund-poke [[our %tes2] %edit-proj `'test-2' `'desc-2' `'https://picsum.photos/200' `[our .0]]
:fund &fund-poke [[our %tes2] %edit-mile 0 `'m1-2' `'d1-2' `'https://picsum.photos/200' `.1e6]
:fund &fund-poke [[our %tes2] %bump-proj %prop ~]
```

### Deletion Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [[our %test] %drop-proj ~]
```

### Error Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [[our %test] %mula-proj %plej our .30 0 (crip "{<our>} bad plej")]
:fund &fund-poke [[our %test] %mula-proj %cont `our .10 [1 0x0 0x0] (crip "{<our>} bad cont")]
:fund &fund-poke [[our %test] %init-proj ~]
:fund &fund-poke [[our %test] %edit-proj ~ `'desc-2' ~ ~]
:fund &fund-poke [[our %test] %init-mile 0]
:fund &fund-poke [[our %test] %edit-mile 0 ~ `'d1-2' ~ ~]
:fund &fund-poke [[our %test] %drop-mile 0]
:fund &fund-poke [[our %test] %bump-proj %born ~]
:fund &fund-poke [[our %test] %bump-proj %prop ~]
:fund &fund-poke [[our %test] %bump-proj %lock `[0 0x0 0x0 0x0]]
:fund &fund-poke [[our %test] %join-proj ~]
:fund &fund-poke [[our %test] %exit-proj ~]
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
a different ship:

## Poke Tests ##

```
:fund &fund-poke [[~zod %test] %join-proj ~]
:fund &fund-poke [[~zod %test] %exit-proj ~]
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
