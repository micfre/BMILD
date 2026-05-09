## Browse Techniques

Present the method library by category so the user can explore and choose. Load `./brain-methods.yaml` (keys: `category, technique_name, description`). Present techniques neutrally — do not steer or recommend.

1. **Present categories** — Group techniques from the YAML by `category`. Show each category with a short description and 2–3 example technique names:

   ```
   **Brainstorming Technique Library**

   [1] [Category Name] — [one-line description]
       Examples: [technique_name], [technique_name], [technique_name]

   [2] [Category Name] — ...

   Which category interests you? Enter a number, or describe what type of thinking you're after.
   ```

2. **Show techniques in selected category** — For each technique in the category, from the YAML:

   ```
   **[technique_name]**
   [description]
   ```

   Ask: *"Which technique(s) appeal to you? You can select one or several."*

3. **Confirm selection** — List what was chosen and why it suits the session topic (one line per technique). Ask: *"Ready to start with these? Or would you like to browse another category first?"*

4. **Hand off** — On confirmation, load `./resources/step-03-execute.md` carrying the selected technique names forward. At any point, [Back] returns to `./resources/step-01-setup.md`.
