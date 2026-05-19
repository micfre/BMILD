# BMILD Core Skill Sections

## Frontmatter
- contains: name, description, metadata
- template note: version must be compatible with VERSION file in project root and with scripts/version-sync.sh script

## Role

- purpose: sets role and voice for the persona, establishes names and functions of the other personas more richly than the skill frontmatter alone
- template note: this H2 section becomes home to former floating Role section and the former BMILD Working Team H2 section

Subscections:

**Your Role:**
- contains: persona name, icon, role, perspective, voice

**Your working team:**
- contains: place in value chain, stakes, names and descriptions of other personas and advanced elicitation tools

- template note: by end of this section, the LLM should know who they are emulating and their role within the BMILD suite

## Entry and Activation

- purpose: instructions to follow upon skill entry, enumerates all context reads, determines working Mode
- forbidden: there should be no steps that require the LLM to return at a later point to revisit an instruction or condition, once the LLM has progressed beyond Activation block, there shall be no reason to return to it
- template note: this section is renamed as 'Entry and Activation' to have symmetry with the closing section 'Exit and Handoff'

Subsections:

**Context reads:**
- purpose: provides required context, repo preferences, sufficient to allow persona to work effectively in a fresh context window, and provides semantic cues for Mode selection
- contains: retrieve and parse repo preferences (.bmild.toml), context memory reads
- forbidden: Mode-specific reads do not appear in this section, rather they are specified in the Mode-specific resources/ instruction file

**Queue resolution:**
- purpose: check for required pre-requisite work, conditions that prevent proper completion of the workflow or work that must be resolved elsewhere before proceeding
- contains: early branching instructions, escapes if required, handoff/handback instructions if required

**Mode lookup:**
- purpose: provide all semantic or explicit interpretation required to choose a single Mode in which to operate for the session
- contains: Mode determination conditions, workflow selection (this where the exact mapping of Mode to Mode-specific instruction file in resources/ folder is specified)

- template note: this section no longer includes the instruction for the persona to emit the first line ('one compact opening stance'), that is moved to Workflow section
- template note: Mode Lookup is structured such that conditions are read row-wise top to bottom, and the Mode is chosen at first match of all conditions for that row, with the last Mode being a catch all

- template note: by the end of this section, the LLM should have required initiative and global context loaded, and know which Mode it is to operate in

## Workflow

- purpose: all the work that must be carried out in the session, end-to-end
- contains: skill-scoped work is outlined here (as contrasted to Mode-scoped work which is contained in the Mode-specific instruction file)
- out of scope: this section should not include any general behaviours or mode-specific instructions



- template note: this section now conatins the instruction for the persona to emit the first line ('one compact opening stance')
- template note: Mode-specific instructions in resouces/ folder accomplishes two things: 1) forces progressive disclosure so only reads and tasks aligned with the Mode are loaded into context, which saves token consumption, 2) prevents bleed from tasks that belong in other Modes, mitigating distraction, for better LLM instruction following

- template note: by end of this section, the LLM should know the end-to-end instruction flow, including the Mode-specific workflow to follow

## Global Norms

- purpose: contains behavioural norms for the persona and skill overall, which goven principles, rules and behaviour

- contains: 
- forbidden: Global section does **not** contain any Mode-specific tasks or Mode-specific rules, Global does not include nested or branching logic dependant on current Mode, <if Mode then> inclusion is a sign that these instructions must be moved into Tasks of the Mode-specific resources/ markdown files
- authoring rule: Global biases level of emphasis to broad denomination across Mode-specific instructions, this means that if the average Mode-specific instruction set requires a low baseline attention to a certain rule that gets written here while the Mode that requires a high level of attention to the rule receives added emphasis in their respective resources/ instruction file


Subsections:



- template note: this H2 section becomes home to former Capabilities and Craft Standards section content
- template note: H2 heading should be named as Global to reinforce heiracrhical rule structure of the skill and respective Tasks in the resources/ folders




## Scope Boundary

- purpose: 




6. Exit and Handoff


## Gotchas

- purpose: narrow guidance for ambiguous or apparently-conflicting rules elsewhere, not to be used to restate existing rules
- contains: conditions and reactions for uncommon or not obviously-resolvable rules
- usage note: do not feel compelled to add content to this section by default, it usually just results in noise, rather add here as user encounters edge cases that deerve steering but do not warrant a new passage elsewhere

## Removed Sections

- template note: this is not a template section, it is instruction for the content refactor
- Definition of Done is no longer present in the core SKILL.md template, all DoD reside in Mode-specific resources/ markdown files. Re-distribute existing DoD content residing in a core SKILL.md into appropriate documents/sections
- Capabilities and Craft Standards have been subsumed by Global Norms
