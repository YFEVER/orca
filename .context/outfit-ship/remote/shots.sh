#!/usr/bin/env bash
# Runs on Omarchy from the repo root: the app's outfit sheets at 1x and 2x, and the picker with an outfit on.
set -u
O=/tmp/avatar-outfits-shots
rm -rf "$O"; mkdir -p "$O/shots1" "$O/shots2"
pnpm fixtures:shot --stop >/dev/null 2>&1
pnpm run build:packages 2>&1 | tail -2
pnpm fixtures:shot "bots/BotAvatarOutfits" --scale 1 --out "$O/shots1" 2>&1 | tail -3
pnpm fixtures:shot "bots/BotAvatarOutfits" --scale 2 --out "$O/shots2" 2>&1 | tail -3
pnpm fixtures:shot "bots/BotPicturePicker:newIdle" --scale 2 --out "$O/shots2" 2>&1 | tail -2
pnpm fixtures:shot "bots/BotPicturePicker:newOutfit" --scale 2 --out "$O/shots2" 2>&1 | tail -2
pnpm fixtures:shot "bots/BotPicturePicker:newReviewer" --scale 2 --out "$O/shots2" 2>&1 | tail -2
pnpm fixtures:shot --stop >/dev/null 2>&1
tar -C "$O" -czf /tmp/avatar-outfits-shots.tgz . && sha256sum /tmp/avatar-outfits-shots.tgz
