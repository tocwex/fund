import { mkdir, rename, rm } from 'node:fs/promises';
import { build } from 'esbuild';

const outDir = 'src/web/fund/script';
const tmpDir = 'src/web/fund/.script-build';

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

await rm(tmpDir, {recursive: true, force: true});
await mkdir(tmpDir, {recursive: true});

try {
  await build({
    ...shared,
    entryPoints: ['ui/fund/chain.js'],
    outfile: `${tmpDir}/chain.js`,
  });

  await build({
    ...shared,
    entryPoints: ['ui/fund/markdown.js'],
    outfile: `${tmpDir}/markdown.js`,
  });

  await build({
    ...shared,
    entryPoints: ['ui/fund/widgets.js'],
    outfile: `${tmpDir}/widgets.js`,
  });

  await build({
    ...shared,
    entryPoints: ['ui/fund/boot.js'],
    outfile: `${tmpDir}/boot.js`,
    external: [...shared.external, './chain.js', './markdown.js', './widgets.js'],
  });

  await rm(outDir, {recursive: true, force: true});
  await rename(tmpDir, outDir);
} catch (error) {
  await rm(tmpDir, {recursive: true, force: true});
  throw error;
}
