# 🚀 Running the App & TestFlight Deployment Guide

## Part 1: Get It Running Locally (15 minutes)

### 1. Open the Project
```bash
cd NetworthTracker
open NetworthTracker.xcodeproj
```

### 2. Add Plaid SDK (Required!)
In Xcode:
1. **File** → **Add Package Dependencies**
2. Enter: `https://github.com/plaid/plaid-link-ios`
3. Version: **Up to Next Major** from `4.1.0`
4. Click **Add Package**
5. Select **LinkKit** → Add to **NetworthTracker** target

### 3. Select Your Target Device
- For testing: Choose **iPhone 15 Pro** simulator (or any iOS 17+ device)
- For real device: Connect your iPhone and select it

### 4. Build and Run
- Press **Cmd+R** or click the ▶️ Play button
- Wait for build to complete
- App should launch!

### 5. Test Basic Features
- ✅ See sample net worth data
- ✅ Add manual assets (+ button → Add Manual Asset)
- ✅ See daily change indicator
- ✅ Refresh button works

### 6. Test Plaid (Optional for Now)
If you want to test Plaid:
1. Get a link token from Plaid dashboard
2. Update `PlaidService.swift` with the token
3. Tap "Connect Bank Account"

---

## Part 2: TestFlight Deployment (1-2 hours)

### Prerequisites
- [ ] Apple Developer Account ($99/year)
- [ ] Xcode with your Apple ID signed in
- [ ] App icons (or use a placeholder)

### Step 1: Configure App for Release

#### A. Update Bundle Identifier
1. Click on **NetworthTracker** project in navigator
2. Select **NetworthTracker** target
3. Change Bundle Identifier to something unique:
   ```
   com.yourname.networthtracker
   ```

#### B. Set Version Numbers
- **Version**: 1.0.0
- **Build**: 1

#### C. Configure Signing
1. In **Signing & Capabilities** tab
2. Check **Automatically manage signing**
3. Select your **Team** (your Apple Developer account)
4. Xcode will create provisioning profiles

### Step 2: Add App Icon (Required)

1. Create a 1024x1024 PNG icon (or use a placeholder)
2. Go to `Assets.xcassets` → `AppIcon`
3. Drag your icon to the 1024x1024 slot

**Quick Placeholder Icon:**
- Go to https://www.iconarchive.com/
- Search "money" or "finance"
- Download any 1024x1024 icon
- Or create simple one with "NW" text

### Step 3: Archive the App

1. Select **Any iOS Device (arm64)** as destination (not simulator!)
2. Menu: **Product** → **Archive**
3. Wait for build (2-5 minutes)
4. Xcode will open the Organizer with your archive

### Step 4: Upload to App Store Connect

In the Organizer window:
1. Select your archive
2. Click **Distribute App**
3. Choose **App Store Connect**
4. Choose **Upload**
5. Keep all default options
6. Click **Upload**

### Step 5: Configure in App Store Connect

1. Go to https://appstoreconnect.apple.com
2. Click **My Apps** → **+** → **New App**
3. Fill in:
   - **Platform**: iOS
   - **Name**: Net Worth Tracker
   - **Primary Language**: English
   - **Bundle ID**: Select yours
   - **SKU**: networthtracker (or anything unique)

### Step 6: Set Up TestFlight

1. In App Store Connect → Your App → **TestFlight** tab
2. Complete required information:
   - **Beta App Description**: "Track your net worth across all accounts"
   - **Email**: Your email
   - **Beta App Review Information**: Fill basic info

3. Under **Test Information**:
   - Add screenshots (can be simulator screenshots)
   - Add beta test description

### Step 7: Add Testers

1. **Internal Testing** (up to 100 testers):
   - Click **+** next to Internal Testing
   - Add email addresses
   - They'll get TestFlight invites immediately

2. **External Testing** (up to 10,000 testers):
   - Create a group
   - Add emails
   - Requires Beta App Review (1-2 days)

---

## 🚨 Before Shipping Checklist

### Critical for v1.0:
- [ ] Remove hardcoded Plaid token
- [ ] Add proper error handling
- [ ] Test on real device
- [ ] Add privacy policy URL (required)
- [ ] Test all manual asset types

### Nice to Have:
- [ ] App icon that looks professional
- [ ] Launch screen
- [ ] Onboarding flow
- [ ] Face ID protection option

---

## 🏃‍♂️ Quick Start (Minimal TestFlight)

If you just want to get SOMETHING on TestFlight today:

1. **Remove Plaid for now** - Comment out Plaid code
2. **Use manual assets only** - This still provides value
3. **Create simple icon** - Even text "NW" works
4. **Write minimal description** - "Track net worth"
5. **Upload to TestFlight** - Internal testing only

You can always update the app later with Plaid integration!

---

## 📱 TestFlight Testing Flow

Once deployed:
1. Testers get email invite
2. They install TestFlight app
3. They tap link in email
4. Install your app from TestFlight
5. They can send feedback through TestFlight

---

## 🐛 Common Issues

### "No account for team"
- You need to join Apple Developer Program ($99/year)

### "Missing compliance"
- In App Store Connect, go to your app
- Answer export compliance questions (usually "No" for financial apps)

### "Invalid binary"
- Check all required fields are filled
- Ensure app icon is provided
- Version number must be higher than previous

### Build takes forever
- Normal for first archive (downloads symbols)
- Subsequent builds are faster

---

## 🎯 Today's Goal

**Minimum**: Get app running in simulator
**Stretch**: Upload to TestFlight for internal testing
**Tomorrow**: Add Plaid backend and ship update

Remember: TestFlight allows rapid iterations. Ship early, update often! 