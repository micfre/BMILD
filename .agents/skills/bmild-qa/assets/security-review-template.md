---
type: Security Review
title: "<short display name>"
description: "<one-line summary>"
timestamp: YYYY-MM-DD
scope: "<initiative-name> | _system"
slug: <slug>
outcome: "<O-### or direct change>"
# Optional legacy reference: slice: <N>
status: open | resolved
owner: Rahat
next_owner: Alex | Lance | Katrina | Rahat | none
---

## Findings Summary

Found [N] critical, [M] high, [K] medium, and [L] low severity issues within [review scope].

## Vulnerabilities

### Vuln 1: [Category]: `<file>:<line>`

- **Severity:** low | medium | high | critical
- **Confidence:** 0.8–1.0
- **Description:** [Clear description of the vulnerability]
- **Exploit path:** [Untrusted entry → boundary/sink → impact]
- **Recommendation:** [Authoritative remediation direction]
- **Owner:** Alex | Lance | Katrina
- **Status:** open | fixed_pending_review | resolved

### Vuln 2: ...

## Closure Evidence

- Remediation reference: [file refs / outcome evidence / design update]
- Verification performed by Rahat: ...
- Result: pass | fail | blocked
- Source promotion status: pending | complete

When every required finding for the outcome is `resolved` and current independent evidence supports the result, set the matrix `security_status: cleared`. `cleared` is the matrix summary of resolved applicable findings; it never deletes finding history.
