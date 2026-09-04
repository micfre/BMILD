---
type: Security Review
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name> | _system"
slug: <slug>
slice: <N | none>
status: open | resolved
owner: Rahat
next_owner: Alex | Lance | Katrina | Rahat | none
---

## Findings Summary

Found [N] High severity and [M] Medium severity issues within [review scope].

## Vulnerabilities

### Vuln 1: [Category]: `<file>:<line>`

- **Severity:** High | Medium
- **Confidence:** 0.8–1.0
- **Description:** [Clear description of the vulnerability]
- **Exploit path:** [Untrusted entry → boundary/sink → impact]
- **Recommendation:** [Authoritative remediation direction]
- **Owner:** Alex | Lance | Katrina
- **Status:** open | fixed_pending_review | resolved

### Vuln 2: ...

## Closure Evidence

- Remediation reference: [file refs / Slice notes / design update]
- Verification performed by Rahat: ...
- Result: pass | fail | blocked
- Source promotion status: pending | complete
