# fractal_tree: interactive installation

Processing 4 sketch (Java mode) that will run as an interactive installation: unattended, full screen, for hours or days at a time.

## Sketch layout

- The main file `fractal_tree.pde` must keep the same name as the folder. Processing will not open the sketch otherwise.
- Each extra `.pde` file in this folder is an editor tab. All tabs compile into one class, so top-level variables and functions are shared across them. Give each subsystem its own tab, for example `Input.pde` or `Scene.pde`.
- Local assets (images, fonts, sounds, config) go in `data/`. `loadImage("x.png")` and similar calls resolve against it.
- Libraries are installed globally in `~/Documents/Processing/libraries/`, not in this folder. Name every library a change needs, so it can be installed on the installation machine too.

## Build and run

Compile check. Run it after every change, before calling the work done:

```sh
processing-java --sketch="$PWD" --output=/tmp/sketch_build --force --build
```

- `--run` opens a window. `--present` opens it full screen, the way the installation runs.
- The output folder must be outside the sketch folder.
- The `WARNING: package sun.awt.X11` line is harmless. Success ends with `Finished.`
- A successful compile does not show interaction or visuals. When a change affects what people see or do, tell the user what to look for when they run it.

## Installation rules

Code must survive running unattended for days, with nobody there to restart it:

- **`draw()` stays fast.** Load files and network resources in `setup()`, or in the background with `requestImage()` or `thread()`. Never block in `draw()`.
- **Memory stays flat.** Create images, fonts and buffers once and reuse them. Never call `loadImage()`, `createGraphics()` or `new PImage` every frame.
- **Recover from failure.** A network, sensor or file problem shows a fallback and retries. It never crashes or freezes the sketch.
- **Size from the screen.** Work out layout from `width` and `height`, never from fixed pixel values, so the sketch adapts to whatever display is installed. Development runs at `size(1920, 1080)`. Deployment uses `fullScreen()` and `noCursor()`.
- **Tunable values live in one place.** Thresholds, timings, URLs and colors go in constants at the top of the main tab, so they can be adjusted on site without searching the code.
- **Idle state.** With nobody interacting, the piece returns to an attract or idle mode after a timeout.

## Installation details

<!-- Fill in as decisions are made. These are the facts an agent cannot find in the code. -->

- Input / sensors: TBD (for example mouse, webcam, Kinect, Arduino over serial, OSC)
- Output: TBD (display or projector resolution, sound)
- Venue constraints: TBD (lighting, internet access, how the machine starts and restarts)
