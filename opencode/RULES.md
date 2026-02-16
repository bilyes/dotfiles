# AI Agent Rules

**CRITICAL**: These rules are ABSOLUTE and must be followed without exception.

---

## Git Operations - STRICT PROTOCOL

### Commits

**NEVER commit without explicit user approval.**

Before ANY commit operation:
1. ✅ Show the user a summary of changes
2. ✅ Use @question tool to ask about commit message
3. ✅ Wait for explicit "yes, commit this" or "go ahead" from user
4. ❌ DO NOT commit just because changes are ready
5. ❌ DO NOT commit as part of a workflow "next step"
6. ❌ DO NOT assume the user wants you to commit

**Required confirmation phrase**: "Ready to commit?" or "Should I commit these changes?"

### Pushes

**NEVER push to remote without explicit user approval.**

Before ANY push operation:
1. ✅ Ask user explicitly: "Should I push this branch?"
2. ✅ Wait for clear "yes" or "push it"
3. ❌ DO NOT push after committing (even if it seems logical)
4. ❌ DO NOT push because a branch is "ready"
5. ❌ DO NOT force-push without EXTREME explicit permission

**Required confirmation phrase**: "Ready to push to remote?" or "Should I push this to origin?"

### Pull Requests

**NEVER create a PR without explicit user approval.**

Before creating any PR:
1. ✅ Use @question tool to confirm PR title and description
2. ✅ Wait for explicit "create the PR" or "open a PR"
3. ❌ DO NOT create PRs as part of a workflow
4. ❌ DO NOT assume completing a feature means opening a PR

---

## Commit Messages

**ALWAYS use @question tool for commit message approval.**

Process:
1. Draft a commit message following the repo's conventional commit style
2. Use @question tool to present the message
3. Offer user option to modify or approve
4. Wait for confirmation before proceeding

---

## Branch Operations

### Main Branch Protection

**NEVER commit directly to main/master branch.**

- ❌ **NEVER** commit to `main` or `master` branches
- ❌ **NEVER** push to `main` or `master` branches
- ✅ **ALWAYS** create a feature/fix/test branch first
- ✅ **ALWAYS** use pull requests to merge into main

**If you find yourself on main branch:**
1. Stop immediately
2. Create a new branch: `git checkout -b <branch-name>`
3. Ask user to confirm branch name using @question tool
4. Continue work on the feature branch

### Creating Branches
- ✅ Use @question tool to confirm branch name
- ✅ Follow naming conventions: `feat/`, `fix/`, `test/`, `refactor/`
- ✅ Branch off from `main` unless told otherwise
- ❌ DO NOT create branches without asking about the name

### Force Operations
- ❌ **NEVER** force-push without EXPLICIT user request
- ❌ **NEVER** hard reset without EXPLICIT user request
- ❌ **NEVER** use `--no-verify` or skip hooks without user request

---

## When User Says "Continue"

If the user says "continue" or "proceed":
- ✅ Continue with code changes, file edits, running tests
- ✅ Continue with analysis and investigation
- ❌ **STOP** before any git commit/push operation
- ❌ **ASK** explicitly before committing

**"Continue" does NOT mean "commit everything"**

---

## Exceptions

The ONLY exception to these rules is if the user explicitly says:
- "Commit this"
- "Push it"
- "Create a PR"
- "Go ahead and commit"

Generic phrases like "continue", "next", "proceed" do NOT count as permission.

---

## Violations

If you violate these rules:
1. Immediately acknowledge the violation
2. Explain what you did wrong
3. Ask user how they want to proceed (undo, keep, etc.)
4. Do NOT make excuses or rationalize

---

## Summary

**GOLDEN RULE**: When in doubt about git operations, STOP and ASK.

It is ALWAYS better to ask unnecessarily than to commit/push without permission.
