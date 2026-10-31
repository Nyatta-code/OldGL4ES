# OldGL4ES

Renderer plugin for Fold Craft Launcher (also ZalithLauncher 2) built around
[GL4ES](https://github.com/ptitSeb/gl4es), tuned for old Minecraft versions
(starting with 1.12.2) on a weak phone (Redmi 9T, Adreno 610).

The plugin is an APK with no code: a manifest that announces the renderer plus
`libgl4es.so`, compiled from source by GitHub Actions.

## Build (from the phone)

1. Create an empty GitHub repo and push this folder to it (Termux: `git init`, `git add .`, `git commit`, `git remote add origin ...`, `git push`).
2. Open the repo, tab **Actions**, wait for **Build OldGL4ES plugin** to finish.
3. Download the `OldGL4ES-plugin` artifact, unzip it, install the APK.
4. In Fold Craft Launcher: **Settings -> Renderer** and pick **OldGL4ES (1.12.2)**.

## Customize

- **Tuning**: edit the `pojavEnv` value in `app/src/main/AndroidManifest.xml` (KEY=VALUE pairs separated by `:`).
- **Change GL4ES itself**: put `.patch` files in `patches/`; the workflow applies them before building.
- **Other GL4ES fork/commit**: run the workflow manually and fill `gl4es_repo` / `gl4es_ref`.

## Known unknowns

This is a first scaffold and has not been run on a device yet. The two places most
likely to need a fix after the first test:

- the `pojavEnv` separator / `renderer` format (copied from another FCL plugin's documentation);
- GL4ES symbols the launcher expects (upstream GL4ES may lack functions that the launcher's own fork has). If the launcher log says `undefined symbol: ...`, point `gl4es_repo` at the fork the launcher uses.

GL4ES is MIT licensed. The launcher plugin interface is from Fold Craft Launcher (GPL-3.0).
