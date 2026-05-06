#!/usr/bin/env zsh
# =============================================================================
# workstart.sh — Dev environment launcher for Hyprland
# Spawns every window directly into its target workspace, no switching needed.
# =============================================================================
# PATHS — edit these before running
PATH_DOCKER_1="$HOME/DEV/familliadelivery/back/Famillia"      # workspace 1, top pane  (docker-compose --env-file)
PATH_DOCKER_2="$HOME/DEV/valhalla-app"                        # workspace 1, bottom pane (docker-compose up)
PATH_WORKSPACE2="$HOME/DEV/familliadelivery/back/Famillia"    # workspace 2, plain terminal
PATH_HOT_RELOAD="$HOME/DEV/familliadelivery/back/Famillia"    # special:run, tab 1  (make hot_reload)
PATH_NVIM="$HOME/DEV/familliadelivery/back/Famillia"          # special:run, tab 2  (nvim .)
# =============================================================================

sleep_short=0.8   # tweak if windows need more time to spawn

# ─────────────────────────────────────────────────────────────────────────────
# WORKSPACE 1 — two Konsole windows tiled top/bottom
# ─────────────────────────────────────────────────────────────────────────────
hyprctl dispatch exec "[workspace 1 silent] konsole -e zsh -c \"cd '$PATH_DOCKER_1' && docker-compose --env-file ./app.env up --build; exec zsh\""
sleep $sleep_short

hyprctl dispatch exec "[workspace 1 silent] konsole -e zsh -c \"cd '$PATH_DOCKER_2' && docker-compose up --build; exec zsh\""
sleep $sleep_short

# ─────────────────────────────────────────────────────────────────────────────
# WORKSPACE 2 — plain terminal, just cd
# ─────────────────────────────────────────────────────────────────────────────
hyprctl dispatch exec "[workspace 2 silent] konsole -e zsh -c \"cd '$PATH_WORKSPACE2'; exec zsh\""
sleep $sleep_short

# ─────────────────────────────────────────────────────────────────────────────
# SPECIAL WORKSPACE: run (Super+N) — zen-browser + hot_reload + nvim
# ─────────────────────────────────────────────────────────────────────────────
hyprctl dispatch exec "[workspace special:run silent] zen-browser"
sleep $sleep_short

hyprctl dispatch exec "[workspace special:run silent] konsole -e zsh -c \"cd '$PATH_HOT_RELOAD' && make hot_reload; exec zsh\""
sleep $sleep_short

hyprctl dispatch exec "[workspace special:run silent] konsole -e zsh -c \"cd '$PATH_NVIM' && nvim .; exec zsh\""
sleep $sleep_short

# ─────────────────────────────────────────────────────────────────────────────
# SPECIAL WORKSPACE: magic (Super+S) — btop
# ─────────────────────────────────────────────────────────────────────────────
hyprctl dispatch exec "[workspace special silent] konsole -e btop"

echo "All done! Everything spawned in the background."
