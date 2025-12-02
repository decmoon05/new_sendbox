# English Commit Messages Guide

> How to change existing commit messages to English

## 📝 Current Status

Your commits:
1. ✅ "Add: Flutter selection rationale, Git setup, and FVM guide documentation" (Already English)
2. ❌ "Initial commit: SendBox 프로젝트 재구축 계획 및 아키텍처 설계 완료" (Korean)

## 🔧 Change First Commit Message

### Method 1: Interactive Rebase (Recommended)

```bash
# Start interactive rebase for last 2 commits
git rebase -i --root

# In the editor that opens:
# - Change "pick" to "reword" for the first commit
# - Save and close
# - In the next editor, change the commit message to English
```

### Method 2: Reset and Re-commit (Simpler)

Since you haven't pushed yet, you can reset and re-commit:

```bash
# Reset to before first commit (keeps files)
git reset --soft HEAD~2

# Now commit with English message
git commit -m "Initial commit: SendBox project redesign planning and architecture documentation"
git commit -m "Add: Flutter selection rationale, Git setup, and FVM guide documentation"
```

### Method 3: Use git commit --amend for Root Commit

For the root commit specifically:
```bash
# This is more complex, so use Method 2 instead
```

## ✅ Recommended: Use Method 2

Since you haven't pushed yet, Method 2 is simplest:

```bash
# Check current commits
git log --oneline

# Reset (keeps all files staged)
git reset --soft HEAD~2

# Re-commit with English messages
git commit -m "Initial commit: SendBox project redesign planning and architecture documentation"

# Add and commit second set of files
git add WHY_FLUTTER.md GIT_SETUP.md FVM_GUIDE.md QUICK_START.md COMMIT_MESSAGES.md CURRENT_STATUS.md
git commit -m "Add: Flutter selection rationale, Git setup, and FVM guide documentation"
```

## 📋 Future Commit Messages (English Format)

### Format
```
<type>: <subject>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Tests
- `chore`: Maintenance

### Examples for SendBox Project

```bash
# Planning/Design
docs: Add project planning and architecture documentation
docs: Add database schema design
docs: Add AI system design documentation

# Development
feat: Add project structure with Clean Architecture
feat: Add Riverpod state management setup
feat: Add SMS integration service
fix: Resolve message parsing issue
refactor: Extract message parsing logic

# Dependencies
chore: Update Flutter dependencies
chore: Add required packages to pubspec.yaml

# CI/CD
ci: Add GitHub Actions workflow
build: Configure Flutter build settings
```

## 🎯 Quick Reference

### Common Commands
```bash
# Check commits
git log --oneline

# Add files
git add .

# Commit with English message
git commit -m "feat: Add new feature"

# Push to GitHub
git push -u origin main
```

## ✅ Checklist

- [ ] Change first commit message to English
- [ ] Use English for all future commits
- [ ] Follow commit message format (type: subject)
- [ ] Keep messages concise (50 chars or less)
- [ ] Use imperative mood (Add, Fix, Update)

---

**Now you can commit in English!** 🚀

