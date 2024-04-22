# `%fund` #

A sovereign platform for peer-to-peer economic activity with on-chain
settlement and trusted identity assessment of work completion.

## Install ##

Within your Urbit ship's command-line interface, enter the following command(s):

```
|install ~firser-dister-sidnym-ladrut %fund
```

If you've installed a beta/unreleased version, expect OTAs to regularly break
backward compatibility. To restore your desk, run the following command(s):

```
|nuke %fund
|install ~firser-dister-sidnym-ladrut %fund
```

## Build/Develop ##

All commands assume that the current working directory is this repository's
base directory and optionally use [durploy] to streamline various Urbit
development workflows.

### First-time Setup ###

Run the following commands to create a new [fake `~zod`][fakezod] with the
`%fund` desk installed:

##### With `durploy` #####

```bash
curl -LO https://raw.githubusercontent.com/sidnym-ladrut/durploy/release/durploy
chmod u+x ./durploy
./durploy ship zod
# in a different terminal
./durploy desk zod fund ./desk/full/
```

##### Without `durploy` #####

```bash
urbit -F zod
|new-desk %fund
|mount %fund
|exit
rm -rI ./zod/fund/*
cp -RL ./desk/full/* ./zod/fund/
urbit ./zod
|commit %fund
|install our %fund
```

### Development Workflows ###

#### Back-end Workflows ####

In order to continuously test back-end code changes as they're made, make sure
you have your [fake `~zod`][fakezod] running in the background and execute the
following commands:

##### With `durploy` #####

```bash
./durploy desk -w zod fund ./desk/full/
```

##### Without `durploy` #####

```bash
cp -fRL ./desk/full/ ./zod/fund/
# in the fakezod terminal
|commit %fund
```

#### Front-end Workflows ####

To view the front-end, simply open your development ship's web interface
at the path `/apps/fund`; for a default [fake `~zod`][fakezod], this
will be:

```
http://127.0.0.1:8080/apps/fund
```

In order to continuously test front-end code changes as they're made, set up
continuous back-end integration (as above) and log into the development ship
from the web interface  using the output of the `dojo` `+code` command as the
password. Then, you should be able to edit the web files in
`./desk/bare/web/fund/page` and see them updated in your browser in real time.

Note that changes to library files (i.e. files outside the
`./desk/bare/web/fund/page` tree) will require prompting your fake ship to
reload the dependent page files separately. The following commands can be run
after library files are changed to achieve this aim, and also to revert the
associated changes prior to commit:

```bash
find ./desk/bare/web/fund/page/ -type f -exec sh -c "echo '::  RELOAD' >> {}" \;
```

```bash
find ./desk/bare/web/fund/page/ -type f -exec sh -c "sed -i '/^::  RELOAD$/d' {}" \;
```

### Deployment Workflow ###

#### Back-end Workflows ####

To generate a new full desk from the existing base desk, run all
of the following commands:

```bash
cd ./desk
rm -rI full/
find bare -type f | while read f; do { d=$(dirname "$f" | sed "s/^bare/full/"); mkdir -p "$d"; ln -sr -t "$d" "$f"; }; done
mkdir -p full/lib/ full/mar full/sur
ln -sr ../LICENSE.txt full/license.txt
# git clone --depth 1 https://github.com/urbit/yard yar
git clone -b 412k-rc2 --depth 1 https://github.com/urbit/urbit.git urb
cp urb/pkg/arvo/lib/{verb*,naive*,tiny*,ethereum*} full/lib/
cp urb/pkg/arvo/sur/verb.hoon full/sur/
git clone -b sl/server-schooner-z412k --depth 1 https://github.com/sidnym-ladrut/yard.git yar
cp yar/desk/lib/{dbug*,default-agent*,skeleton*,rudder*,server*,docket*,mip*} full/lib/
cp yar/desk/mar/{bill*,docket*,hoon*,json*,kelvin*,mime*,noun*,ship*,txt*,css*,png*,svg*,js*} full/mar/
cp yar/desk/sur/docket* full/sur/
git clone -b sl/tonic-simplification --depth 1 https://github.com/sidnym-ladrut/gin-tonic.git gat
cp gat/tonic/lib/tonic.hoon full/lib/
cp gat/tonic/mar/cass.hoon full/mar/
git clone -b sl/fix-scry-request-agent-wire --depth 1 https://github.com/sidnym-ladrut/sss.git sss
cp sss/urbit/lib/sss.hoon full/lib/
cp sss/urbit/sur/sss.hoon full/sur/
```

To toggle debug mode (between release mode and local debug mode):

```bash
find ./desk/bare/ -type f -exec sed -i -r "s/(^\s*)::  (.*::\s*debug-only$)/\1\2/" {} \;
```

```bash
find ./desk/bare/ -type f -exec sed -i -r "s/(^\s*)(.*::\s*debug-only$)/\1::  \2/" {} \;
```

To perform a versioned release:

```bash
./meta/exec/release X.Y.Z
```


[urbit]: https://urbit.org
[durploy]: https://github.com/sidnym-ladrut/durploy

[fakezod]: https://developers.urbit.org/guides/core/environment#development-ships
[react]: https://reactjs.org/
[tailwind css]: https://tailwindcss.com/
[vite]: https://vitejs.dev/
