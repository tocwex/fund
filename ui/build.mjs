import { rm } from 'node:fs/promises';
import { build } from 'esbuild';

await rm('src/web/fund/script', {recursive: true, force: true});

const shared = {
  bundle: true,
  format: 'esm',
  platform: 'browser',
  target: ['es2022'],
  minify: true,
  sourcemap: false,
  legalComments: 'none',
  external: ['./config.js'],
  define: {
    'process.env.NODE_ENV': '"production"',
  },
};

await build({
  ...shared,
  entryPoints: ['ui/fund/chain.js'],
  outfile: 'src/web/fund/script/chain.js',
});

await build({
  ...shared,
  entryPoints: ['ui/fund/markdown.js'],
  outfile: 'src/web/fund/script/markdown.js',
});

await build({
  ...shared,
  entryPoints: ['ui/fund/widgets.js'],
  outfile: 'src/web/fund/script/widgets.js',
});

await build({
  ...shared,
  entryPoints: ['ui/fund/boot.js'],
  outfile: 'src/web/fund/script/boot.js',
  external: [...shared.external, './chain.js', './markdown.js', './widgets.js'],
});
