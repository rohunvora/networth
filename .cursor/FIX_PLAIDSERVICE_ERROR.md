# 🔧 Fix: PlaidService Not Found

## The Problem
Xcode can't find `PlaidService.swift` even though the file exists. This happens when files aren't added to the build target.

## Quick Fix (30 seconds)

### Option 1: Add File to Target
1. In Xcode's file navigator (left sidebar)
2. Look for **Services** folder
3. If you see `PlaidService.swift` in RED:
   - It's missing from disk
   - Right-click → Delete → Remove Reference
   - Continue to Option 2
4. If you DON'T see `PlaidService.swift`:
   - Right-click on **Services** folder
   - Select **Add Files to "NetworthTracker"**
   - Navigate to `NetworthTracker/Services/PlaidService.swift`
   - ✅ Check "Copy items if needed"
   - ✅ Check "NetworthTracker" target
   - Click Add

### Option 2: Quick Re-create
If the file is missing, here's a minimal version:

1. Right-click **Services** folder in Xcode
2. New File → Swift File → Name it `PlaidService.swift`
3. Replace contents with:

```swift
import SwiftUI

class PlaidService: ObservableObject {
    @Published var isLinking = false
    
    func openLink() {
        print("📱 Plaid integration coming soon!")
        print("For now, use Add Manual Asset to track your accounts")
    }
}
```

### Option 3: Remove Plaid (Temporarily)
In `ContentView.swift`, comment out line 6:
```swift
// @StateObject private var plaid = PlaidService()
```

And comment out any plaid.openLink() calls.

## Then Run Again
Press **Cmd+R** and the app should build!

---

## 💡 Why This Happens
- Files can exist on disk but not be added to Xcode project
- Moving projects can break file references
- Xcode shows missing files in RED in the navigator

## ✅ Success Check
After fixing, you should see:
- Build succeeds
- App launches in simulator
- No red files in Xcode navigator 