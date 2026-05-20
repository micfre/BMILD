# Step 02a — Browse Techniques

## Purpose

Present the method library by category so the user can explore and choose. Present techniques neutrally — do not steer or recommend.

## Inputs

- `resources/brain-methods.yaml` (keys: `category`, `technique_name`, `description`). Load the file; do not use technique names from memory.

## Procedure

Progress:

- [ ] Step 1: **Present categories** — Group techniques from the YAML by `category`. Show each category with a short description and 2–3 example technique names:

   ```
   **Brainstorming Technique Library**

   [1] [Category Name] — [one-line description]
       Examples: [technique_name], [technique_name], [technique_name]

   [2] [Category Name] — ...

   Which category interests you? Enter a number, or describe what type of thinking you're after.
   ```

- [ ] Step 2: **Show techniques in selected category** — For each technique in the category, from the YAML:

   ```
   **[technique_name]**
   [description]
   ```

   Ask: *"Which technique(s) appeal to you? You can select one or several."*

- [ ] Step 3: **Confirm selection** — List what was chosen and why it suits the session topic (one line per technique). Ask: *"Ready to start with these? Or would you like to browse another category first?"*

## Next Step

- On confirmation → load `resources/step-03-execute.md` carrying the selected technique names forward.
- [Back] at any point → return to `resources/step-01-setup.md`.
