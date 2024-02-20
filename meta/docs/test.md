# Single Ship Testing #

## Poke Tests ##

### Basic Tests ###

```
:fund &fund-poke [[our %test] %init-proj ~]
:fund &fund-poke [[our %test] %edit-proj `'test' `'desc' `'https://picsum.photos/200' ~ `[~nec .0.01]]
:fund &fund-poke [[our %test] %edit-mile 0 `'m2' `'d2' `'https://picsum.photos/200' `.200 `0]
:fund &fund-poke [[our %test] %init-mile 0]
:fund &fund-poke [[our %test] %edit-mile 0 `'m1' `'d1' `'https://picsum.photos/200' `.100 `0]
:fund &fund-poke [[our %test] %init-mile 2]
:fund &fund-poke [[our %test] %drop-mile 2]
:fund &fund-poke [[our %test] %bump-proj %lock `[0 0x0 0x0 0x0]]
:fund &fund-poke [[our %test] %bump-proj %work ~]
:fund &fund-poke [[our %test] %bump-proj %sess ~]
:fund &fund-poke [[our %test] %bump-proj %done ~]
:fund &fund-poke [[our %test] %bump-proj %work ~]
```

### Deletion Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [[our %test] %drop-proj ~]
```

### Error Tests ###

Only run these commands after running all of the basic test commands.

```
:fund &fund-poke [[our %test] %init-proj ~]
:fund &fund-poke [[our %test] %edit-proj ~ `'desc-2' ~ ~ ~]
:fund &fund-poke [[our %test] %init-mile 0]
:fund &fund-poke [[our %test] %edit-mile 0 ~ `'d1-2' ~ ~ ~]
:fund &fund-poke [[our %test] %drop-mile 0]
:fund &fund-poke [[our %test] %bump-proj %born ~]
:fund &fund-poke [[our %test] %bump-proj %lock `[0 0x0 0x0 0x0]]
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
```
