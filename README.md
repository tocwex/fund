# `%fund` #

A sovereign platform for peer-to-peer economic activity with on-chain
settlement and trusted identity assessment of work completion.

## Build/Develop ##

All commands assume that the current working directory is this repository's
base directory and use [durploy] to streamline various Urbit development
workflows.

### Generate Full Desk ###

```bash
cd ./desk
rm -rI full/
find bare -type f | while read f; do { d=$(dirname "$f" | sed "s/^bare/full/"); mkdir -p "$d"; ln -sr -t "$d" "$f"; }; done
mkdir -p full/lib/ full/mar full/sur
ln -sr ../LICENSE.txt full/license.txt
# git clone --depth 1 https://github.com/urbit/yard yar
git clone -b sl/server-schooner-z412k --depth 1 https://github.com/sidnym-ladrut/yard.git yar
cp yar/desk/lib/{dbug*,default-agent*,skeleton*,rudder*,server*,docket*,mip*} full/lib/
cp yar/desk/mar/{bill*,docket*,hoon*,json*,kelvin*,mime*,noun*,ship*,txt*} full/mar/
cp yar/desk/sur/docket* full/sur/
git clone -b sl/tonic-simplification --depth 1 https://github.com/sidnym-ladrut/gin-tonic.git gat
cp gat/tonic/lib/tonic.hoon full/lib/
cp gat/tonic/mar/cass.hoon full/mar/
git clone -b sl/fix-scry-request-agent-wire --depth 1 https://github.com/sidnym-ladrut/sss.git sss
cp sss/urbit/lib/sss.hoon full/lib/
cp sss/urbit/sur/sss.hoon full/sur/
```

### Deploy Full Desk ###

```bash
./durploy desk -w zod fund ./desk/full/
```

### Toggle Desk Debug Mode ###

To turn *on* debug mode (for local debugging):

```bash
find ./desk/bare/ -type f -exec sed -i -r "s/(^\s*)::  (.*::\s*debug-only$)/\1\2/" {} \;
```

To turn *off* debug mode (for releases):

```bash
find ./desk/bare/ -type f -exec sed -i -r "s/(^\s*)(.*::\s*debug-only$)/\1::  \2/" {} \;
```


[urbit]: https://urbit.org
[durploy]: https://github.com/sidnym-ladrut/durploy

[fakezod]: https://developers.urbit.org/guides/core/environment#development-ships
[react]: https://reactjs.org/
[tailwind css]: https://tailwindcss.com/
[vite]: https://vitejs.dev/
