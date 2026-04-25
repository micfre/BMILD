import os
import glob

skills_dir = '/home/mf/src/projects/bmild/.agents/skills/'

for file_path in glob.glob(os.path.join(skills_dir, '**/*.md'), recursive=True):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    changed = False

    # Replace the plans/ references explicitly where it specifies plans/
    if 'plans/' in content:
        content = content.replace('plans/platform', '[plan_folder]/platform')
        content = content.replace('plans/features', '[plan_folder]/features')
        content = content.replace('plans/', '[plan_folder]/')
        changed = True

    if '**Persona:**' in content and '.bmild.toml' not in content:
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if line.startswith('**Persona:**'):
                addition = " Read `.bmild.toml` to get the `plan_folder` (default `plans/`) and `user_name`. Address the user by their `user_name` if specified. All paths below use `[plan_folder]` to represent this directory."
                lines[i] = line + addition
                changed = True
                break
        content = '\n'.join(lines)
        
    if changed:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {file_path}")

