# 🔧 Fix Xcode Build Error - Step by Step

## Step 1: Clean Build Folder (10 seconds)
In Xcode menu:
- **Product** → **Clean Build Folder** (⇧⌘K)
- Or hold Shift and click Product menu, then "Clean Build Folder"

## Step 2: Add Missing Files to Xcode (30 seconds)

### Look at Xcode's Left Sidebar:
1. Find the **NetworthTracker** folder (blue folder icon)
2. Look for **Services** folder inside it

### If you DON'T see Services folder:
1. Right-click on **NetworthTracker** (the blue folder)
2. Select **"Add Files to NetworthTracker..."**
3. Navigate to: `/Users/satoshi/Documents/networth/NetworthTracker/NetworthTracker/Services`
4. Select the **Services** folder
5. Make sure:
   - ⬜ **UNCHECK** "Copy items if needed" (files already exist!)
   - ✅ **CHECK** "Create groups"
   - ✅ **CHECK** "NetworthTracker" target
6. Click **Add**

### If you see Services folder but it's empty or missing files:
1. Right-click on **Services** folder
2. Select **"Add Files to NetworthTracker..."**
3. Navigate to the Services folder on disk
4. Select both:
   - `PlaidService.swift`
   - `PortfolioManager.swift`
5. Same settings as above - DON'T copy items
6. Click **Add**

## Step 3: Verify Files Are Added
You should now see in Xcode:
```
NetworthTracker
├── NetworthTrackerApp.swift
├── ContentView.swift
├── Models
│   └── Asset.swift
├── Services
│   ├── PlaidService.swift ✅
│   └── PortfolioManager.swift ✅
├── Views
│   └── AddAssetView.swift
└── Extensions
    └── Double+Extensions.swift
```

## Step 4: Build and Run
1. Make sure you have **iPhone 15 Pro** selected (not "Any iOS Device")
2. Press **Cmd+R**
3. App should build and run! 🎉

---

## 🚀 If Still Having Issues - Nuclear Option

### Complete Reset:
```bash
# In Terminal:
cd /Users/satoshi/Documents/networth
rm -rf ~/Library/Developer/Xcode/DerivedData/NetworthTracker-*
```

Then in Xcode:
1. Close project
2. File → Open → Select NetworthTracker.xcodeproj
3. Follow Step 2 above to add files

---

## 💡 Quick Alternative - Comment Out Plaid

If you just want to run the app NOW, in `ContentView.swift`:

**Line 6** - Comment out:
```swift
// @StateObject private var plaid = PlaidService()
```

**Around Line 27** - Comment out the button action:
```swift
Button(action: {
    // plaid.openLink()
    print("Plaid coming soon!")
}) {
```

**In the Menu** - Comment out:
```swift
Button(action: {
    // plaid.openLink()
    print("Plaid coming soon!")
}) {
```

**At the bottom** - Comment out the overlay:
```swift
// .overlay {
//     if plaid.isLinking {
//         ...
//     }
// }
```

Then run - it will work without Plaid! 