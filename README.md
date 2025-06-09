# Net Worth Tracker

**One number that's always right.**

A modern iOS app that **automatically** aggregates your net worth across all asset types - no more manual updates, no more spreadsheets, just one accurate number that updates itself.

## 🎯 The Real Problem We're Solving

❌ **Current Reality**: You have assets in 10+ places, checking them takes an hour, and by the time you update your spreadsheet, it's already wrong.

✅ **Our Solution**: Connect your accounts once. See your exact net worth in 5 seconds. Always current, always accurate.

## 🚀 Core Features (v1.0)

### What Makes This Different
1. **Automatic Bank Aggregation** (via Plaid)
   - Connect checking, savings, investment accounts
   - Balances update automatically
   - No manual entry required

2. **Crypto Wallet Tracking** 
   - Add wallet address → see live balance
   - Supports ETH and major tokens
   - DeFi positions included

3. **Real-Time Updates**
   - Stock prices update throughout the day
   - Crypto prices refresh every minute
   - Never stale, always accurate

4. **Manual Fallback**
   - Private investments
   - Real estate
   - Any asset Plaid can't reach

## 📱 The Experience

```
Before: "I think I have around $1.2M" (but you're not sure)
After: "I have exactly $1,247,832.45" (updated 2 minutes ago)
```

## 🛠 Technical Architecture

### iOS App (SwiftUI)
- **Minimum iOS**: 17.0
- **UI Framework**: SwiftUI
- **State Management**: ObservableObject pattern
- **Local Storage**: UserDefaults → Core Data (planned)

### Backend (Required for Security)
- **Plaid Integration**: Secure token exchange
- **Price APIs**: Stock and crypto prices
- **Options**: Firebase Functions (recommended) or AWS Lambda

### Key Integrations
- **Plaid**: Bank account aggregation
- **Etherscan**: Ethereum wallet balances
- **CoinGecko**: Crypto prices
- **Alpha Vantage**: Stock prices

## 🔧 Setup Instructions

### 1. Prerequisites
- Xcode 15+
- iOS 17+ device/simulator
- Plaid developer account
- Firebase project (for backend)

### 2. Clone and Configure
```bash
git clone [your-repo-url]
cd networth-tracker/NetworthTracker
open NetworthTracker.xcodeproj
```

### 3. Backend Setup (Required)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Initialize functions
firebase init functions

# Deploy backend
firebase deploy --only functions
```

### 4. Add Your API Keys
Create `Config.xcconfig`:
```
PLAID_CLIENT_ID = your_client_id
PLAID_ENV = sandbox
BACKEND_URL = https://your-project.cloudfunctions.net
```

### 5. Run the App
- Select your device/simulator
- Press Cmd+R to build and run

## 🧪 Testing with Plaid Sandbox

Use these credentials in the app:
- Username: `user_good`
- Password: `pass_good`

This will add fake accounts with realistic data for testing.

## 📈 Roadmap

### ✅ v1.0 - Automatic Aggregation (Current Focus)
- [x] Manual asset entry
- [ ] Plaid bank integration
- [ ] Crypto wallet tracking
- [ ] Real-time price updates

### 📊 v2.0 - Intelligence Layer
- [ ] Net worth charts over time
- [ ] Spending insights
- [ ] Asset allocation analysis
- [ ] Rebalancing suggestions

### 🚀 v3.0 - Automation
- [ ] Bill pay reminders
- [ ] Investment automation
- [ ] Tax optimization alerts
- [ ] Family sharing

## 🔒 Security & Privacy

- **Bank credentials**: Never touch our servers (Plaid handles auth)
- **Access tokens**: Encrypted and stored securely
- **Local data**: Can be Face ID protected
- **No tracking**: Your financial data is yours alone

## 🤝 Contributing

This is currently a personal project, but contributions are welcome:

1. Fork the repo
2. Create a feature branch
3. Follow the existing code style
4. Submit a PR with clear description

## 📋 Development Guidelines

- **Focus**: Every feature must help users see their net worth faster
- **Simplicity**: Choose the simplest solution that works
- **Security**: Never compromise on financial data security
- **Performance**: The number should load in < 5 seconds

## 📞 Support

- **Issues**: Use GitHub issues for bugs
- **Features**: Open a discussion first
- **Security**: Email security@ for vulnerabilities

## 📄 License

[Your License Choice]

---

**Remember the mission**: Transform "I think I have..." into "I have exactly..." 

No more manual updates. No more uncertainty. Just one number that's always right.