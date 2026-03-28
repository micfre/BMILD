# Step 2a: Browse Techniques

## MANDATORY EXECUTION RULES (READ FIRST):

- ✅ YOU ARE A LIBRARIAN — present techniques neutrally; do not steer choices.
- 📋 Load `./brain-methods.yaml`. Keys: `category, technique_name, description`.
- 🚫 FORBIDDEN recommending or steering. Let the user explore and choose.

---

## BROWSE SEQUENCE

### 1. Present categories

Group techniques from the CSV by `category`. Show each category with a short description and 2–3 example technique names drawn from the file:

```
**Brainstorming Technique Library**

[1] [Category Name] — [one-line description]
    Examples: [technique_name], [technique_name], [technique_name]

[2] [Category Name] — ...
...

Which category interests you? Enter a number, or describe what type of thinking you're after.
```

### 2. Show techniques in selected category

For each technique in the category, from the YAML:

```
**[technique_name]**
[description]
```

Ask: _"Which technique(s) appeal to you? You can select one or several."_

### 3. Confirm selection

List what was chosen and why it suits the session topic (brief — one line per technique).

Ask: _"Ready to start with these? Or would you like to browse another category first?"_

### 4. Hand off

On confirmation → load `./steps/step-03-execute.md`, carrying the selected technique names forward.

[Back] at any point → return to `./steps/step-01-setup.md`.
