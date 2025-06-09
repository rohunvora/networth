# 📋 Xcode: Add Solana Files Checklist

## 🚨 Current Status
✅ Files exist on disk
❌ Files not in Xcode project
❌ App won't build without adding them

## 🎯 2-Minute Fix

### Step 1: Add SolanaService.swift
- [ ] In Xcode's left panel, find **Services** folder
- [ ] Right-click **Services** folder
- [ ] Click **"Add Files to NetworthTracker..."**
- [ ] Navigate to: `NetworthTracker/NetworthTracker/Services/`
- [ ] Click on **SolanaService.swift**
- [ ] Settings at bottom:
  - [ ] ⬜ **UNCHECK** "Copy items if needed"
  - [ ] ✅ **CHECK** "NetworthTracker" target
  - [ ] ✅ **CHECK** "Create groups"
- [ ] Click **Add**

### Step 2: Add AddSolanaWalletView.swift
- [ ] Right-click **Views** folder
- [ ] Click **"Add Files to NetworthTracker..."**
- [ ] Navigate to: `NetworthTracker/NetworthTracker/Views/`
- [ ] Click on **AddSolanaWalletView.swift**
- [ ] Same settings:
  - [ ] ⬜ **UNCHECK** "Copy items if needed"
  - [ ] ✅ **CHECK** "NetworthTracker" target
- [ ] Click **Add**

### Step 3: Verify
You should now see in Xcode:
```
NetworthTracker
├── Services
│   ├── PlaidService.swift
│   ├── PortfolioManager.swift
│   └── SolanaService.swift ✅ NEW!
├── Views
│   ├── AddAssetView.swift
│   └── AddSolanaWalletView.swift ✅ NEW!
```

### Step 4: Build & Run
- [ ] Press **Cmd+B** to build
- [ ] Press **Cmd+R** to run
- [ ] Test: Tap + → Solana Wallet → Add Solana Wallet

## 🔥 Quick Alternative

If the above doesn't work, try dragging files:

1. Open Finder to: `/Users/satoshi/Documents/networth/NetworthTracker/NetworthTracker/`
2. In Xcode, make sure Services and Views folders are visible
3. Drag `SolanaService.swift` from Finder onto Services folder in Xcode
4. Drag `AddSolanaWalletView.swift` from Finder onto Views folder in Xcode
5. When dialog appears, UNCHECK "Copy items"

## ✅ Success Indicators
- No red files in Xcode
- Build succeeds (Cmd+B)
- You see "Solana Wallet" option when tapping +

## ❌ If You See Errors
- "Cannot find 'SolanaService' in scope" → File not added to target
- Red filename in navigator → File missing, remove and re-add
- "No such module" → Clean build folder (Shift+Cmd+K)

---

**Need help?** The files definitely exist, they just need to be added to Xcode's build system! 