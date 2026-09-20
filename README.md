# iCloud Doctor

iCloud Doctor is a macOS diagnostic and repair plugin for ChatGPT and Codex. It helps identify iCloud Drive synchronization failures, interpret Finder status icons, diagnose multi-Mac conflicts, and apply only evidence-matched, low-risk repairs.

## What it can help with

- Finder reports that syncing has been disabled due to an error.
- Desktop or Documents unexpectedly appears as `Local`.
- Changes made on one Mac do not arrive on another Mac.
- Uploads or downloads remain stalled.
- iCloud storage, local disk space, or another cloud provider may be interfering.
- Files were deleted, conflicted, or became cloud-only.
- Large development folders create excessive synchronization churn.

## Safety approach

iCloud Doctor diagnoses before changing anything. It does not automatically sign out of the Apple Account, toggle iCloud Drive, move or merge folders, delete files, or reset File Provider databases. Repairs that change local process state require confirmation first.

## Install

Add the GitHub repository as a plugin marketplace:

```bash
codex plugin marketplace add aaaven/icloud-doctor
```

Then open the Plugins Directory in the ChatGPT desktop app, choose **iCloud Doctor**, and install it. Restart the app if the new marketplace does not appear immediately.

To install from a full URL instead:

```bash
codex plugin marketplace add https://github.com/aaaven/icloud-doctor.git
```

## Use

After installation, start a new ChatGPT or Codex task and say:

> Run iCloud Doctor and diagnose why iCloud Drive is not syncing.

Before editing or building an iCloud-backed project, use this readiness request:

> Use iCloud Doctor to run a project-readiness preflight on this folder. Confirm that files created on my other Mac have arrived and that all required files are downloaded locally. If synchronization or materialization is incomplete, stop and tell me what is missing; do not edit, build, or generate replacement files yet.

For a reusable request that does not name a specific project:

> Before doing any work, use iCloud Doctor to run a readiness preflight on the workspace or project root currently associated with this task and already accessible to you. If it is iCloud-backed, verify that remote changes have arrived and that every file required for the requested work is downloaded locally. If anything is incomplete or uncertain, stop and report it; do not edit, build, delete, or create replacement files. Do not scan outside the authorized workspace.

The plugin first performs a read-only check. If the evidence matches the known stalled local pipeline, it explains the proposed lightweight repair and asks before applying it.

### Named modes

| Mode | Use it for |
| --- | --- |
| `$icloud-doctor workspace-check` | Verify that the current authorized workspace is synchronized and locally ready before work begins. |
| `$icloud-doctor sync-check` | Diagnose stalled upload/download, disabled syncing, or broad sync symptoms without changing state. |
| `$icloud-doctor sync-repair` | Recheck the known stalled local pipeline and request confirmation before restarting only the matching sync services. |
| `$icloud-doctor storage-check` | Check local disk space, iCloud capacity, and storage-related transfer blocks. |
| `$icloud-doctor folders-check` | Check Desktop & Documents settings, `— Local` symptoms, links, and competing cloud-provider ownership. |
| `$icloud-doctor multi-mac-check` | Verify the required upload/download directions between Macs with a harmless canary. |
| `$icloud-doctor status-check` | Explain Finder icons and check whether selected required items are actually local. |
| `$icloud-doctor recovery-check` | Triage missing, deleted, or conflicted files while preserving recoverable versions. |

Natural-language phrases such as “workspace check,” “storage check,” or “folders check” select the corresponding mode.

The shortest reusable project check is:

> `$icloud-doctor workspace-check`

It returns `READY` or `NOT READY` with the blocking evidence. A named mode narrows the workflow; it does not grant access outside the workspace or authorize changes.

Equivalent natural-language requests are:

> Use iCloud Doctor to run workspace check.

> 先用 iCloud Doctor 做 workspace check。

To use the check as a gate before another task:

> `$icloud-doctor workspace-check`; only if `READY`, continue with the following task: …

Without an explicitly chained task, `workspace-check` stops after reporting the result.

## Platform

- macOS only for local diagnostics and repair.
- Designed for ChatGPT desktop and Codex environments that can run local tools.
- A web-only chat cannot restart synchronization services on a Mac.

## Status

Current public release: `0.1.3`.

## Documentation

The repository packaging follows the [official OpenAI plugin marketplace format](https://developers.openai.com/plugins/build/plugins).
