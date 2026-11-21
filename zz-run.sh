git checkout -q --detach HEAD~1 && pnpm check:changed --base=254f40df844 2>&1 | tail -15; echo CHECK-CHANGED-DONE; git checkout -q -
T1=src/renderer/src/components/bots/bot-smart-sort-sources.test.ts
T2=src/renderer/src/components/bots/use-bot-workspace-order.performance.test.tsx
H=src/renderer/src/components/bots/use-bot-workspace-order.ts
S=src/renderer/src/components/bots/bot-smart-sort-sources.ts
run() { pnpm exec vitest run --config config/vitest.config.ts "$@" 2>&1 | grep -E 'Tests |FAIL|AssertionError|Error:|expected' | head -8; }
run $T1 $T2 src/renderer/src/components/bots/BotSidebarEntry.test.tsx
echo ---REVERTED-HOOK---
git checkout 254f40df844 -- $H && run $T2; git checkout HEAD -- .
for key in agentStatusByPaneKey tabsByWorktree migrationUnsupportedByPtyId; do
  echo ---MUTANT-IGNORES-$key---
  perl -0pi -e "s/\.get\(state\.$key\)/.get(FIXED)/; s/\.set\(state\.$key,/.set(FIXED,/; s/^(type Statuses)/const FIXED = {}\n\$1/m" $S && grep -c FIXED $S && run $T1; git checkout HEAD -- .
done
git status --short
