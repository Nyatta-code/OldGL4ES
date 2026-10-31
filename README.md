# OldGL4ES

Renderer plugin for Fold Craft Launcher (also ZalithLauncher 2) built around
[GL4ES](https://github.com/ptitSeb/gl4es), tuned for old Minecraft versions
(starting with 1.12.2) on a weak phone (Redmi 9T, Adreno 610).

The plugin is an APK with no code: a manifest that announces the renderer plus
`libgl4es.so`, compiled from source by GitHub Actions.

## Layout

```
.github/workflows/build.yml   CI: fetch GL4ES, patch, build, make the APK
scripts/build-gl4es.sh        builds GL4ES for each ABI with the NDK
patches/                      your own *.patch files for GL4ES (applied in CI)
app/src/main/AndroidManifest.xml   renderer name + environment (tuning lives here)
app/build.gradle.kts          Android app module
```

## Use

1. Run the Termux script `oldgl4es.sh` (creates the project, pushes it, waits for the build, downloads the APK).
2. Install the APK.
3. In Fold Craft Launcher: **Settings -> Renderer -> OldGL4ES (1.12.2)**.

## Customize

- **Tuning**: edit the `pojavEnv` value in `app/src/main/AndroidManifest.xml` (KEY=VALUE pairs separated by `:`).
- **Change GL4ES itself**: put `.patch` files in `patches/`; the workflow applies them before building.
- **Other GL4ES fork or commit**: run the workflow manually (Actions -> Run workflow) and fill `gl4es_repo` / `gl4es_ref`.
- **ABIs**: edit `ABIS` at the top of the workflow.

## Known unknowns

Not tested on a device yet. Most likely places to need a fix:

- the `pojavEnv` separator / `renderer` format (taken from another FCL plugin's documentation);
- GL4ES symbols the launcher expects (upstream GL4ES may lack functions the launcher's own fork has). If the launcher log says `undefined symbol: ...`, point `gl4es_repo` at the fork the launcher uses.

GL4ES is MIT licensed. The launcher plugin interface is from Fold Craft Launcher (GPL-3.0).
