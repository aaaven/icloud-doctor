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

The plugin first performs a read-only check. If the evidence matches the known stalled local pipeline, it explains the proposed lightweight repair and asks before applying it.

## Platform

- macOS only for local diagnostics and repair.
- Designed for ChatGPT desktop and Codex environments that can run local tools.
- A web-only chat cannot restart synchronization services on a Mac.

## Status

Current public release: `0.1.1`.

## Documentation

The repository packaging follows the [official OpenAI plugin marketplace format](https://developers.openai.com/plugins/build/plugins).
