# iCloud Doctor problem catalog

Use the smallest matching branch. Official Apple behavior is separated from operational guidance inferred for high-churn development work.

## Status icons, not necessarily failures

- Cloud with down arrow: the item is only in iCloud. Use Download Now when a local copy is needed.
- Solid-outline cloud: downloaded and current; usable offline.
- Gray circle with down arrow: Keep Downloaded; macOS should retain the local copy even when storage is needed.
- Dotted cloud: waiting to upload; the item is not yet stored in iCloud.
- Slashed cloud: ineligible for iCloud.
- Pie chart: transfer progress.
- No icon: may simply mean downloaded when the iCloud Status column is hidden.

Source: https://support.apple.com/guide/mac-help/mchlc994344b/mac

## Whole sync pipeline stalled on one Mac

Evidence: settings remain enabled, storage is available, Desktop/Documents becomes Local or Finder reports syncing disabled, and a cross-Mac canary fails in one or both directions.

Action: run the read-only check, obtain authorization, then use the lightweight repair. Reopen Finder and retest in both required directions. If it remains broken, stop repeating the restart and escalate diagnostics.

## Waiting to upload or progress never advances

Check, in order:

1. Apple System Status and any Apple Account authentication badge.
2. Stable network and power, plus sufficient iCloud and local disk space.
3. Whether the scope is one item, one high-churn project, or all iCloud Drive.
4. Whether a small canary file transfers while the large tree does not.

If only a project tree stalls, inspect it for unsupported or very large items and excessive generated content before restarting the entire pipeline.

Sources:
- https://support.apple.com/118446
- https://support.apple.com/guide/mac-help/mchlc994344b/mac

## Parent is Keep Downloaded but descendants are not locally ready

Evidence: the top-level project folder has the Keep Downloaded icon, but a required child folder appears empty, required files are cloud-only, or opening a child folder is what starts its download.

Interpretation: do not use the parent icon as a recursive completion certificate. Keep Downloaded is the retention intent for the selected item, while enumeration and first download of a large descendant tree can still be asynchronous. Accessing a child may cause File Provider to prioritize it.

Action:

1. Establish at least one expected file or small canary known to exist on the other Mac.
2. Inspect required descendants rather than relying on the parent icon.
3. If required content is cloud-only, transferring, or missing locally while known to exist remotely, pause builds, edits, indexing, and batch jobs.
4. With user authorization, use Download Now on the highest safe project folder and wait for transfer progress to finish.
5. Recheck the expected files before declaring the local project ready.

Do not interpret an incomplete local view as proof that remote files were deleted, and do not generate replacement files over the expected paths.

Sources:
- https://support.apple.com/guide/mac-help/mchl1a02d711/mac
- https://support.apple.com/guide/mac-help/mchlc994344b/mac

## Ineligible item

Apple says this commonly occurs when an individual file or folder exceeds the 50 GB iCloud Drive limit. Desktop/Documents also does not upload iMovie, Photos, or Aperture library files.

Action: identify the exact item. Split or store oversized content elsewhere; keep unsupported media libraries outside Desktop/Documents. Do not rename, split, or move user data automatically.

Sources:
- https://support.apple.com/guide/mac-help/mchlc994344b/mac
- https://support.apple.com/109344

## iCloud or local disk space exhausted

If iCloud is full, new changes cannot upload. If local disk is tight and Optimize Mac Storage is enabled, older items may become cloud-only.

Action: report which capacity is constrained. Use Remove Download only to free local space without deleting the cloud copy. Use Keep Downloaded for active offline-critical folders. Never delete files as an automatic cleanup because iCloud deletion propagates to every device.

Sources:
- https://support.apple.com/guide/mac-help/mchlc994344b/mac
- https://support.apple.com/guide/mac-help/mchl1a02d711/mac

## Desktop and Documents changes after adding another Mac

Apple documents that a second Mac may place its Desktop/Documents content in a folder named after that Mac rather than automatically merging it into the first Mac's files.

Action: identify the machine-named folder before concluding data is missing. Compare both sets without merging automatically.

Sources:
- https://support.apple.com/118443
- https://support.apple.com/109344

## Competing cloud provider

Apple requires another provider's Desktop/Documents management to be turned off before using iCloud Desktop & Documents. Separate copies can coexist only in separate locations.

Action: identify which provider owns Desktop/Documents. Pause and ask the user to choose the primary provider. Do not disable either provider or move files automatically.

Sources:
- https://support.apple.com/118443
- https://support.apple.com/109344

## Conflicting document versions

Apple says conflicts can occur when the same document is edited on multiple offline devices and both later reconnect.

Action: in Apple's conflict dialog, keep every potentially useful version first. Preview and merge manually afterward. Versions not selected are deleted across iCloud-enabled devices.

Source: https://support.apple.com/guide/mac-help/mh40780/mac

## Deletion propagated to every device

iCloud Drive is synchronization: deleting on one device deletes on the others. Deleted files are normally recoverable for 30 days unless permanently removed.

Action: stop edits and deletions, check Trash and iCloud Drive Recently Deleted or Data Recovery, then restore. Do not change iCloud Drive data while recovery is running.

Sources:
- https://support.apple.com/guide/icloud/mmae56ea1ca5/icloud
- https://support.apple.com/guide/icloud/mm19ef899373/icloud

## High-churn development trees on two Macs

Operational guidance inferred from Apple's conflict and queue behavior:

- Do not use iCloud as the concurrency or history mechanism for source code. Use Git with a remote and commit/push/pull coordination.
- Avoid editing the same working tree simultaneously on two Macs, especially while one is offline.
- Prefer local project roots such as `~/Developer` for active repositories. Use iCloud for documents, assets, handoff archives, or exported snapshots when appropriate.
- Keep reproducible generated trees and caches out of iCloud when practical: dependency folders, build outputs, simulator data, package caches, and DerivedData can create large numbers of rapid changes.
- Do not automatically move a repository or delete generated content. Explain the tradeoff and let the user choose.

Apple's Developer Forums contain field reports linking Git and large generated trees with long-running Waiting to Upload states, but these reports are not an official guarantee of cause or remedy:
https://developer.apple.com/forums/thread/651829

## Authentication or service outage

Action: check Apple System Status, confirm every Mac uses the intended Apple Account, and resolve any System Settings badge. Do not restart local services when Apple reports an outage or the account requires authentication.

Sources:
- https://support.apple.com/118446
- https://support.apple.com/126961
