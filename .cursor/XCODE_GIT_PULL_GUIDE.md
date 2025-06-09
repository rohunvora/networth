# 📥 Pull GitHub Changes into Xcode

## Method 1: Using Xcode's Built-in Git (Easiest)

### 1. Open Source Control Navigator
- In Xcode, click the **Source Control navigator** icon (looks like a Git branch)
- Or use menu: **View → Navigators → Source Control** (⌘2)

### 2. Pull Changes
- Menu: **Source Control → Pull...**
- Or right-click on your repo in Source Control navigator → **Pull...**
- Click **Pull** in the dialog

### 3. Handle Any Conflicts
If you see conflicts:
- Xcode will show conflicted files in red
- Click each file
- Choose "Current" (your version) or "Incoming" (GitHub version)
- Or manually edit to combine changes

---

## Method 2: Using Terminal (More Control)

### 1. Open Terminal in Project
```bash
cd /Users/satoshi/Documents/networth/NetworthTracker
```

### 2. Check Status
```bash
git status
```

### 3. Pull Changes
```bash
git pull origin main
```
Or if your branch is called master:
```bash
git pull origin master
```

### 4. If You Have Local Changes
If Git complains about local changes:
```bash
# Option A: Stash your changes temporarily
git stash
git pull origin main
git stash pop

# Option B: Commit your changes first
git add .
git commit -m "Local changes"
git pull origin main
```

---

## Method 3: Xcode Quick Sync

### If Xcode Shows "Push/Pull" Buttons
1. Look at Xcode's toolbar (top)
2. You might see cloud icons or arrows
3. Click the down arrow (↓) to pull

### Using Source Control Menu
1. **Source Control → Fetch and Refresh Status**
2. Then **Source Control → Pull...**

---

## 🚨 Common Issues

### "Cannot pull with rebase: You have unstaged changes"
```bash
# Save your work first
git add .
git commit -m "WIP: Save current work"
git pull
```

### "Divergent branches"
```bash
# If your local and remote have different commits
git pull --rebase origin main
```

### Missing Files After Pull
1. In Xcode, look for files in RED
2. Right-click → Add Files to "NetworthTracker"
3. Navigate to the actual file location
4. Add with "Copy items if needed" UNCHECKED

---

## ✅ After Pulling Successfully

1. **Clean Build Folder**: Product → Clean Build Folder (⇧⌘K)
2. **Build**: Product → Build (⌘B)
3. **Run**: Product → Run (⌘R)

---

## 💡 Pro Tips

- **Before pulling**: Commit or stash your local changes
- **After pulling**: Always do a clean build
- **If confused**: Check `git status` to see what's happening
- **Nuclear option**: Re-clone fresh if too messy

---

## Quick Commands Cheat Sheet
```bash
# Where am I?
pwd

# What's my status?
git status

# Get latest changes
git pull

# I messed up, start over
git reset --hard origin/main  # ⚠️ Loses local changes!
``` 