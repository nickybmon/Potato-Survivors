# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Type Twin Sticks** — a twin-stick survivor-style typing game built in Godot 4 (GDScript). Enemies spawn at arena edges, walk toward the center, and display words. The player types words to destroy enemies.

## Running the Game

Open the project in Godot 4 and press **F5** (or Play). Set `arena.tscn` as the main scene if not already set (Project → Project Settings → Application → Run → Main Scene).

There is no CLI build step. All iteration happens inside the Godot editor.

## Architecture

### Build Order (follow this sequence)
1. **Player** — static, center position, no movement
2. **Enemy** — spawns at edge, walks to center, displays a word
3. **Typing engine** — keystroke listener, auto-targets by first letter, destroys on completion, resets on mistype
4. **Wave manager** — spawning cadence, escalating difficulty
5. **Word bank** — curated lists by difficulty/key focus, stored in `.json` or `.gd` resource
6. **UI** — score, lives, typed-input display, wave counter

### Scene Conventions
- One script per scene
- Signals for cross-system communication (enemy destroyed, wave complete, etc.)
- `$Enemies` node in `arena.tscn` is the container all spawned enemies are added to — iterate it when the typing engine needs to query active targets

### Key Constants (defined per-file, easy to tune)
- `ARENA_SIZE = Vector2(1280, 720)` — used in both arena and enemy
- `CENTER = Vector2(640, 360)` — enemy movement target; will become the player's position reference
- `SPEED = 80.0` — enemy walk speed in px/s

### Typing Engine Design (not yet built)
- Auto-targeting: first keystroke matches enemies whose word starts with that letter
- Mismatch resets current progress (no partial credit)
- Word sets are configurable per run (home row, punctuation, numbers, long words)

## Conventions
- GDScript with static typing (`var x: float`, `func f() -> void`)
- Constants use `:=` inference or explicit types at the top of each script
- Commit after each working system is complete
