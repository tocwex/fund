# `%fund`

A sovereign platform for peer-to-peer economic activity with on-chain
settlement and trusted identity assessment of work completion.

## Demos

### Project Setup

![%fund setup demo](https://github.com/tocwex/fund/raw/release/dat/demo/fund-demo-setup.gif)

### Contribute Funds

![%fund contribute demo](https://github.com/tocwex/fund/raw/release/dat/demo/fund-demo-donate.gif)

### Get Paid

![%fund cash out demo](https://github.com/tocwex/fund/raw/release/dat/demo/fund-demo-cashout.gif)

## Install

Within your Urbit ship's command-line interface, enter the following command(s):

```
|install ~tocwex %fund
```

## Build/Develop

Make sure the following dependencies are installed on your development machine:

- [`GNU Make`](https://www.gnu.org/software/make/)
- [`durploy`](https://github.com/sidnym-ladrut/durploy)
- [`peru`](https://github.com/buildinspace/peru?tab=readme-ov-file#installation)

All of the following commands assume that the current working directory is this
repository's base directory. Also, before running any development commands, you
first need a running Urbit ship. Deploy one on your local machine with:

```bash
durploy ship zod
```

### Development Workflows

In order to continuously test back-end code changes as they're made, run:

```bash
durploy desk -w zod fund ./out/desk/
```

In order to continuously test front-end code changes as they're made, set up
continuous back-end integration (as above) and log into the development ship
from the web interface  using the output of the `dojo` `+code` command as the
password. Then, you should be able to edit the web files in
`./desk/bare/web/fund/page` and see them updated in your browser in real time.

Note that changes to library files (i.e. files outside the
`./desk/bare/web/fund/page` tree) will require prompting your fake ship to
reload the dependent page files separately. The following commands can be run
after library files are changed for this purpose, and also to revert these
temporary edits prior to commit:

```bash
find ./src/web/fund/page/ -type f -exec sh -c "echo '::  RELOAD' >> {}" \;
```

```bash
find ./src/web/fund/page/ -type f -exec sh -c "sed -i '/^::  RELOAD$/d' {}" \;
```

### Deployment Workflows

The frontend boot script is bundled locally. After changing files under `ui/`,
run:

```bash
npm install
npm run build:web
```

To generate a new full desk from the existing base desk, run the following
command:

```bash
make desk
```

To deploy a new desk onto your development ship, run:

```bash
make ship-desk IN_SHIP=zod
```

To perform a versioned release:

```bash
make release IN_SHIP=zod IN_RVER=X.Y.Z
```


[urbit]: https://urbit.org
[durploy]: https://github.com/sidnym-ladrut/durploy

[fakezod]: https://developers.urbit.org/guides/core/environment#development-ships
[react]: https://reactjs.org/
[tailwind css]: https://tailwindcss.com/
[vite]: https://vitejs.dev/
