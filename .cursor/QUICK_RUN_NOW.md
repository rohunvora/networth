# 🏃 Run the App RIGHT NOW (5 minutes)

## Step 1: Open in Xcode
```bash
cd /Users/satoshi/networth-tracker/networth/NetworthTracker
open NetworthTracker.xcodeproj
```

## Step 2: Select Target
In Xcode top bar, select:
- **iPhone 15 Pro** (or any simulator)

## Step 3: Run!
Press **Cmd+R** or click ▶️ Play button

## That's it! 🎉

The app will:
- Show $655,000 sample net worth
- Display asset categories
- Allow adding manual assets
- Show daily change indicator

## What Works Right Now
✅ View net worth total  
✅ Add manual assets (tap + → Add Manual Asset)  
✅ See asset breakdown by category  
✅ Sample data to play with  

## What Doesn't Work Yet
❌ Plaid connection (needs SDK + token)  
❌ Real bank connections  
❌ Automatic updates  

## To Test "Connect Bank Account"
The button will work but just print a message. To actually connect:
1. Add Plaid SDK (see other guides)
2. Get Plaid account
3. Add link token

---

## 🚀 Want TestFlight? (30 min)

### Fastest Path:
1. **Archive**: Product → Archive (select "Any iOS Device" first)
2. **Upload**: In Organizer → Distribute App → App Store Connect
3. **Configure**: Go to App Store Connect → Create app
4. **TestFlight**: Add your email as internal tester
5. **Done**: You'll get invite in ~10 minutes

### Required:
- Apple Developer account ($99/year)
- App icon (1024x1024 PNG)
- Unique bundle ID (com.yourname.networthtracker)

---

**Pro tip**: Ship manual-only version to TestFlight today, add Plaid tomorrow! 