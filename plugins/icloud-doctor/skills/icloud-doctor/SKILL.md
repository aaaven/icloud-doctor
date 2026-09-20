---
name: icloud-doctor
description: Diagnose macOS iCloud Drive status, multi-Mac sync failures, Desktop and Documents problems, stalled uploads or downloads, version conflicts, storage limits, accidental deletion, and competing cloud-provider interference; apply only evidence-matched safe repairs. Do not use for Apple Account recovery or iCloud plan purchases.
---

# iCloud Doctor

Explain iCloud state and restore reliable multi-Mac file synchronization with the least disruptive action supported by the evidence.

## Safety boundaries

- Diagnose before changing state. A status icon alone is not proof of failure.
- Do not sign out of the Apple Account, disable/re-enable iCloud Drive, toggle Desktop & Documents Folders, move folders, merge directories, delete FileProvider data, or restart the Mac.
- Do not treat OneDrive as the confirmed cause merely because the problem followed its installation. Report it only as a possible trigger unless current evidence establishes a conflict.
- Before any repair, state its effect and obtain authorization immediately before changing state.
- If local and cloud content may have diverged, preserve both. Do not attempt reconciliation automatically.
- Never delete, rename, move, merge, download large trees, or resolve a document conflict automatically.
- Treat iCloud as file synchronization, not version control or backup. For active source repositories edited on two Macs, recommend Git for source history and coordination.

## Workflow

1. Run `scripts/icloud_doctor.sh --check` for a read-only baseline.
2. Identify the exact symptom, affected scope, and direction:
   - one file, one folder, Desktop/Documents, or all iCloud Drive;
   - upload from this Mac, download to this Mac, or both;
   - one Mac or every signed-in device;
   - temporary progress or a stable failure.
3. Read [references/problem-catalog.md](references/problem-catalog.md) and choose the matching branch. Do not load unrelated remedies into the response.
4. Combine the branch with the user's observable symptoms. For the known stalled-pipeline case:
   - Finder showed `Syncing has been disabled due to an error`;
   - Desktop or Documents is titled `— Local`;
   - changes made on another Mac do not arrive;
   - iCloud Drive and Desktop & Documents settings remain enabled;
   - iCloud storage is not full.
5. If the failure matches a stalled local sync pipeline, explain the finding and request authorization for the lightweight repair.
6. After authorization, run `scripts/icloud_doctor.sh --repair`.
7. Verify with a harmless cross-Mac canary file or rename. Do not claim end-to-end synchronization is restored until the user confirms both upload and download behavior needed for the workflow.

## Project readiness preflight

Before editing, building, indexing, or batch-processing a project stored in iCloud Drive, verify that the working tree is materially present on the current Mac.

- Do not treat a parent folder's Keep Downloaded icon as proof that every descendant has finished downloading. It expresses a retention policy; descendants may still be queued, cloud-only, or not yet enumerated locally.
- Identify one or more expected files that are known to exist from the other Mac, a repository manifest, or the user's description. A locally missing expected file may indicate incomplete synchronization rather than deletion.
- Inspect the affected descendants' iCloud status. If any required item is In iCloud, transferring, waiting, or absent while known to exist remotely, stop before making project changes.
- Ask the user to use Download Now on the highest safe project folder, keep the Mac online and powered, and wait for transfer progress to finish. Do not force-download a large tree without authorization.
- Recheck the expected files and required upload/download direction before declaring the project ready. Only then proceed with edits, builds, or automation that assumes a complete local tree.

## Decision rules

- If Desktop & Documents or iCloud Drive is actually disabled, report a configuration problem; do not toggle it automatically because local and cloud folders may diverge.
- If iCloud storage or local disk space is exhausted, address capacity without deleting user data automatically.
- If the Apple Account needs authentication or Apple reports an outage, stop local repair and report it.
- If a conflict dialog appears, preserve every potentially useful version first; never choose a winner for the user.
- If deletion propagated across devices, stop writes and route to Recently Deleted or iCloud Data Recovery. Do not run the service restart as a recovery method.
- If the lightweight repair succeeds at process level but the cross-Mac test still fails, collect fresh diagnostics and propose the next non-destructive step. Do not repeat the repair indefinitely.
- If an operation depends on files created on another Mac, treat local materialization as a prerequisite. Do not let a build or file operation convert an incomplete local view into misleading "missing file" errors or replacement output.
- Do not run database repair, delete FileProvider metadata, or sign out as an automatic escalation.
- If the symptom differs materially from the known pattern, diagnose it as a new case rather than forcing this repair.

## Known successful case

On macOS Sequoia, the settings remained enabled and capacity was available, but Finder showed Desktop and Documents as Local and remote changes did not arrive. Restarting `bird` and `fileproviderd`, then reopening Finder, removed the Local label and restored synchronization. OneDrive had recently been configured, but causation was not proven.
