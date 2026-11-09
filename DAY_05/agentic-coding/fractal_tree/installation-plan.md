# Installation plan: fractal tree

A fractal tree grows on the screen and leans toward the person in front of it.
v1 uses the mouse as the person. v2 replaces the mouse with a person tracked by a camera.

## Decisions

| #   | Topic                       | Decision |
|-----|-----------------------------|----------|
| 1   | Starting point              | Old image-loading code removed. The sketch started from a clean, empty state. |
| 2   | What the person does        | The tree grows on its own. It leans toward the person and relaxes back when they leave. The person shapes the tree, but does not drive its growth. |
| 3   | Change over time            | Life cycle: grow → stand full → branches fall off → a new tree with a different shape grows. |
| 4   | How branches fall           | Random larger limbs snap off with everything attached and fall as one piece. |
| 5   | Where fallen limbs go       | They fall off the bottom of the screen or fade out. Nothing piles up, so memory stays flat. |
| 6   | Look                        | Light lines that get thinner toward the tips, on a black background. No leaves. |
| 7   | Idle state                  | After a timeout with no input, the lean goes back to upright with a slight sway. The life cycle keeps running. |
| 8   | Number of people            | Strictly one. Input provides one position plus "present yes/no". If v2 sees several people, choosing one is a v2 decision. |
| 9   | Lean                        | The whole tree tilts as one stiff piece at its base, toward the person. The angle is capped and changes smoothly. |
| 10  | Position and size           | One tree, centered, with its base at the bottom edge. About 65–75% of the screen height. |
| 11  | Branching                   | Organic and random: 2 or 3 children per branch, random angle, length and thickness, an occasional missing branch. Grows depth by depth. A new shape every cycle. |
| 12  | Falling phase (default, not confirmed) | Limbs from depths 1–3 break off one after another, every 1–3 s. When none are left, or the falling time runs out, the rest of the tree fades and a new tree starts. |

## Life cycle

| Phase | Default length | What happens |
|-------|----------------|--------------|
| Grow  | 90 s | Trunk first, then each level of branches, tips last. Each branch extends smoothly. |
| Hold  | 60 s | The full tree stands, leaning or swaying. |
| Fall  | up to 40 s | Random limbs (depth 1–3) break off every 1–3 s. Each falls with gravity, spins outward and fades over about 3.5 s. |
| Fade  | 6 s | What is left (the trunk and stubs) fades out. Then a new tree starts. |

All lengths are constants at the top of `sketch_261109a.pde`.

## Sketch structure

| Tab | Contents |
|-----|----------|
| `sketch_261109a.pde` | All tunable constants, `settings()`/`setup()`/`draw()`, the life-cycle state machine, tilt and idle sway. |
| `Input.pde` | The only place that reads input. Provides `personX`, `personY`, `personPresent`. In v1, "present" means the mouse moved within the last `IDLE_TIMEOUT` seconds. |
| `Tree.pde` | `Branch` and `Tree`: random generation (breadth first, capped at `MAX_BRANCHES`), growth timing, drawing, choosing the next limb to break. |
| `Limbs.pde` | `FallingLimb`: breaking a limb off at its current on-screen position, falling, spinning, fading, removal. |
| `Sound.pde` | Sound with the wellen library: drone, growth notes, limb-break sounds. |

Libraries: **wellen** (https://github.com/dennisppaul/wellen, version 0.15). Install it on the installation machine.

## Sound

All notes are in A minor pentatonic. `ROOT_NOTE` sets the key. All levels are constants in the "Sound" block of the main tab.

| Layer | Behavior |
|-------|----------|
| Drone | A low sine with a sub-octave. It swells while the tree grows, gets quieter as limbs fall, and fades out with the tree. Its stereo position follows the tilt toward the person. |
| Growth notes | One soft note each time a new level of branches starts to sprout, rising from the trunk to the tips. About 11 notes per growth phase, with reverb. |
| Limb breaks | A short noise crack plus a low note, panned to where the limb breaks. Larger limbs sound lower. |

If audio fails, the sound switches off and the visuals keep running. `SOUND_ENABLED = false` turns sound off completely.

## Installation rules (from AGENTS.md)

- `draw()` does no loading. A tree is generated once per cycle (every few minutes), not per frame.
- Memory stays flat. The branch count is capped, fallen limbs are removed once invisible, and each old tree is released when the next one starts.
- Timing uses real elapsed time. A frame step is capped at 0.1 s, so a stall never causes a jump.
- All sizes are fractions of `width` and `height`.
- `FULLSCREEN = true` switches to `fullScreen(P2D)` and hides the cursor.

## v2: camera tracking

- Replace the body of `updateInput()` in `Input.pde` with camera tracking. It must still set `personX`, `personY` (screen pixels) and `personPresent`.
- To decide:
  - Which camera and library to use. Name the library so it can be installed on the installation machine.
  - Which point of the person is used (head, center of the body, hand).
  - Which person is chosen when several are visible.
- If the camera fails, `personPresent` becomes false, so the tree falls back to idle sway. Tracking retries in the background and never blocks `draw()`.
- Tilt smoothing (`TILT_SMOOTHING`) already hides tracking jitter. Increase it if the tree shakes.

## Open items

- Confirm decision 12 (the falling phase).
- Output: projector or screen, and its resolution. Light lines on black suit both.
- Venue: lighting (this matters for the camera in v2), how the machine starts and restarts.
- Tune the timings and the shape on site.
