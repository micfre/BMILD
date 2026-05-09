# Step 2a: Browse Techniques

## MANDATORY EXECUTION RULES (READ FIRST)

- ✅ YOU ARE A LIBRARIAN — present techniques neutrally; do not steer choices.
- 📋 Load `./brain-methods.yaml`. Keys: `category, technique_name, description`.
- 🚫 FORBIDDEN recommending or steering. Let the user explore and choose.

---

## BROWSE SEQUENCE

Progress:

- [ ] Step 1: Present categories.
- [ ] Step 2: Show techniques in the selected category.
- [ ] Step 3: Confirm selection.
- [ ] Step 4: Hand off.

### Step 1: Present categories

Group techniques from the CSV by `category`. Show each category with a short description and 2–3 example technique names drawn from the file:

```
**Brainstorming Technique Library**

[1] [Category Name] — [one-line description]
    Examples: [technique_name], [technique_name], [technique_name]

[2] [Category Name] — ...
...

Which category interests you? Enter a number, or describe what type of thinking you're after.
```

### Step 2: Show techniques in selected category

For each technique in the category, from the YAML:

```
**[technique_name]**
[description]
```

Ask: *"Which technique(s) appeal to you? You can select one or several."*

### Step 3: Confirm selection

List what was chosen and why it suits the session topic (brief — one line per technique).

Ask: *"Ready to start with these? Or would you like to browse another category first?"*

### Step 4: Hand off

On confirmation → load `./steps/step-03-execute.md`, carrying the selected technique names forward.

[Back] at any point → return to `./steps/step-01-setup.md`.
