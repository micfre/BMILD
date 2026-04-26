Write `[plan_folder]/<initiative-name>/security-review-<slug>.md` only when vulnerabilities are found. No artifact is written for a clean review.

```markdown
---
scope: <initiative-name> | _system
slug: <slug>
slice: <N>
status: open | resolved
---

## Findings Summary
Found [N] High severity and [M] Medium severity issues.

## Vulnerabilities

### Vuln 1: [Category (e.g., XSS)]: `<file>:<line>`
* **Severity:** [High/Medium]
* **Description:** [Clear description of the vulnerability]
* **Exploit Scenario:** [Concrete example of how this is exploited]
* **Recommendation:** [Authoritative fix recommendation]

### Vuln 2: ...
```
