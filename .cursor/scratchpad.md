# Net Worth Tracker - Development Scratchpad

## 🎯 Project Mission
**One number that's always right.** Give users their exact net worth in 5 seconds, updated automatically.

## ⚡ CRITICAL INSIGHT (Updated)
**Current State**: Beautiful manual net worth tracker
**Core Problem**: Fragmented assets that are painful to aggregate  
**Gap**: Users still have to manually enter and update everything

**We haven't actually solved the problem yet!**

## 🔥 TODAY'S MISSION: Get Plaid Link Opening

### Current Status
- [x] Added Plaid URL scheme to Info.plist
- [x] Created minimal PlaidService.swift
- [x] Added Connect Bank Account button
- [ ] Add Plaid SDK to project
- [ ] Get link token from dashboard
- [ ] See Plaid Link open in app

### Success = When you see:
```
✅ Plaid Link opened!
🎉 SUCCESS! Public token: pk_test_...
```

**Nothing else matters today!** Just get Link opening.

---

## 📋 NEW FEATURE ANALYSIS: Solana Wallet Integration

### Feature: Solana Wallet Balance Tracking
**User Story**: As a crypto investor, I want to paste my Solana wallet address so that I can see my SOL and token balances automatically

**Analysis**:
- Current pain point: Manually tracking SOL + SPL tokens across wallets
- Proposed solution: Paste address → fetch all balances from blockchain
- Complexity: Medium (need RPC endpoint + token parsing)
- Time estimate: 4-6 hours for MVP

**Success Criteria**:
- [x] User can paste Solana wallet address
- [x] App fetches SOL balance
- [x] App fetches top SPL tokens
- [x] Values update on refresh
- [x] Shows USD values

**Implementation Tasks**:
1. Create SolanaService.swift (1 hour)
   - Setup Helius/QuickNode RPC endpoint
   - Implement getBalance for SOL
   - Implement getTokenAccounts for SPL tokens

2. Create AddSolanaWalletView.swift (1 hour)
   - Text field for wallet address
   - Validation (58 character base58)
   - Loading state while fetching

3. Integrate token price data (2 hours)
   - Use CoinGecko for SOL price
   - Get token prices for major SPL tokens
   - Calculate USD values

4. Update Asset model (0.5 hours)
   - Add wallet address field
   - Add token metadata support
   - Support for multiple tokens per wallet

5. Testing with real wallets (0.5 hours)
   - Test with known wallets
   - Handle edge cases (empty wallets, invalid addresses)

**Risks/Concerns**:
- RPC rate limits (use free tier carefully)
- Token price data availability
- Need to handle thousands of possible SPL tokens

**Decision**: PROCEED - High value feature that demonstrates automatic aggregation

**MVP Approach**:
- Start with just SOL balance
- Add top 10 SPL tokens (USDC, USDT, etc.)
- Use free Helius RPC endpoint
- Expand token support later

---

## 📊 Current State (v1.0)

### ✅ Completed Features
- [x] Core iOS app structure (SwiftUI, iOS 17+)
- [x] Net worth display with prominent number
- [x] Daily change tracking with color coding
- [x] Asset categorization by type
- [x] Manual asset entry form
- [x] Local persistence (UserDefaults)
- [x] Sample data for demo
- [x] Clean, modern UI
- [x] Basic Plaid integration structure
- [x] App runs without PlaidService (commented out)

### 🏗️ Architecture Decisions
- **UI Framework**: SwiftUI (modern, declarative)
- **State Management**: ObservableObject + @Published
- **Data Storage**: UserDefaults (simple for v1)
- **Minimum iOS**: 17.0 (latest features)
- **External SDKs**: Plaid Link iOS (v4.1.0+)

## 🚨 REVISED PRIORITIES - What Actually Solves The Problem

### Priority 1: Plaid Integration (Solves 60% of problem)
**This is THE killer feature** - Without this, users still manually enter bank balances

**Success Criteria**:
- [x] Basic UI for connecting accounts
- [ ] User can tap "Connect Account" ← TODAY'S GOAL
- [ ] Plaid Link opens with bank list ← TODAY'S GOAL
- [ ] User authenticates with their bank
- [ ] Accounts appear automatically
- [ ] Balances update on app launch
- [ ] Access tokens stored securely

**Implementation Plan**: See detailed Plaid section below

### Priority 2: Crypto Wallet Integration (Solves 30% of problem)
**Goal**: Wallet address → automatic balance

#### 2a: Solana Wallet Support (NEW - In Progress)
- [ ] Paste Solana address
- [ ] Fetch SOL balance
- [ ] Fetch major SPL tokens
- [ ] Show USD values
- [ ] Auto-refresh on app launch

#### 2b: Ethereum Wallet Support (Next)
- [ ] Add wallet by address
- [ ] Auto-fetch ETH balance
- [ ] Support top 5 tokens (USDT, USDC, etc)
- [ ] Update on app launch

### Priority 3: Real-Time Price Updates
**Goal**: Make it "always right"

**Success Criteria**:
- [ ] Auto-update stock prices
- [ ] Auto-update crypto prices
- [ ] Show last update time
- [ ] Handle errors gracefully

### ❌ DEPRIORITIZED (Move to v2)
- Asset Detail View (nice to have)
- Data Export (nice to have)  
- Charts (nice to have)
- Search (premature optimization)

## 📋 Plaid Integration - Detailed Implementation

### Pre-Setup
1. **Create Plaid Account**
   - Sign up at plaid.com
   - Get Development credentials
   - Note: client_id, secret, public_key

2. **Choose Products**
   - ✅ Accounts - See all user accounts
   - ✅ Balances - Get current balances
   - ✅ Investments - Brokerage holdings
   - ❌ Transactions (not needed for v1)

### Implementation Tasks

#### Task 1: Install Plaid SDK (0.5 hours)
- [x] Add SPM dependency: `https://github.com/plaid/plaid-link-ios`
- [ ] Import LinkKit in project
- [ ] Verify build succeeds

#### Task 2: Create PlaidService.swift (2 hours)
- [x] Link token creation method
- [x] Link handler setup
- [x] Success callback handling
- [x] Error handling

```swift
// Core structure
class PlaidService: ObservableObject {
    @Published var isLinkActive = false
    @Published var linkedAccounts: [PlaidAccount] = []
    
    func openLink() { }
    func exchangePublicToken(_ publicToken: String) { }
    func fetchAccounts(accessToken: String) { }
}
```

#### Task 3: Setup Backend for Token Exchange (3 hours)
**Critical**: Cannot call Plaid APIs directly from app

Options:
1. **Firebase Functions** (Recommended for speed)
2. **AWS Lambda**
3. **Simple Node.js server**

Required endpoints:
- `/exchange_token` - Public → Access token
- `/get_balances` - Fetch account balances

#### Task 4: Integrate with PortfolioManager (1 hour)
- [ ] Add `isPlaidLinked` flag to Asset model
- [ ] Create `addPlaidAccount()` method
- [ ] Implement `refreshPlaidAccounts()`
- [ ] Update persistence to handle tokens

#### Task 5: UI Integration (1 hour)
- [x] Add "Connect Account" button
- [x] Handle Plaid Link flow
- [x] Show loading states
- [ ] Display connected accounts

#### Task 6: Testing with Sandbox (1 hour)
- [ ] Use sandbox credentials
- [ ] Test with username: `user_good`, password: `pass_good`
- [ ] Verify balances appear
- [ ] Test refresh functionality

### Security Considerations
- **NEVER** store access tokens in UserDefaults
- Use Keychain or backend storage only
- Encrypt tokens at rest
- Implement token refresh logic

### Error Handling
- [ ] Bank connection failures
- [ ] Token expiration
- [ ] Rate limiting
- [ ] Network errors

## 🎯 Success Metrics for Real v1

**Ship when a user can:**
1. Connect 1 bank account (Plaid) ✅
2. Add 1 crypto wallet (address → balance) ✅ ← Working on this!
3. Add 1 manual investment ✅
4. See accurate, auto-updating total ✅

**That's it. Everything else is v2.**

## 📝 The "Magic Moment" Test

❌ **Current app**: User manually enters Schwab balance of $374,350
✅ **Real v1**: User connects Schwab → sees $374,982.47 (exact, real-time)

This difference - manual vs automatic - is EVERYTHING.

## 🚀 Revised Timeline

### Today: Get Plaid Link Opening
- [x] Add Plaid to project structure
- [ ] See Link interface open
- [ ] Get success callback with public token

### This Week: Solana Integration
- [ ] Day 1: Create SolanaService
- [ ] Day 2: Add wallet UI
- [ ] Day 3: Integrate price data
- [ ] Day 4: Testing & polish

### Week 1: Plaid Integration
- Day 1-2: Basic Link flow ← WE ARE HERE
- Day 3-4: Token exchange & backend
- Day 5: Integration & testing

### Week 2: Crypto Integration  
- Day 1-2: Etherscan integration
- Day 3: Multi-token support
- Day 4-5: Testing & polish

### Week 3: Price Updates & Ship
- Day 1-2: Stock price API
- Day 3: Crypto price API
- Day 4-5: Final testing & ship

## 🐛 Known Issues

### Bug Tracker
1. **Decimal Input** - Currency fields don't handle decimals well on some locales
2. **Refresh Animation** - Loading state doesn't show during refresh
3. **Large Numbers** - Formatting breaks above $100M
4. **PlaidService** - Need to add actual link token (temporary hardcoded)

### Technical Debt
1. **UserDefaults Limits** - Need Core Data for larger portfolios
2. **No Error Handling** - API calls need proper error states
3. **No Tests** - Add unit tests for PortfolioManager
4. **Hardcoded Token** - Need proper token generation flow

## 💡 Design Principles

1. **Speed First** - Every interaction should be instant
2. **One Tap Away** - Key info accessible in one tap
3. **No Cognitive Load** - Interface should be self-explanatory
4. **Trust Through Accuracy** - Always show data freshness
5. **Progressive Disclosure** - Simple by default, powerful when needed

## 📈 Progress Tracking

### Week 1 (Current)
- [x] Initial app creation
- [x] Core data model
- [x] Basic UI implementation
- [ ] ~~Asset detail view~~ (Deprioritized)
- [x] Plaid integration structure
- [ ] See Plaid Link open (TODAY'S GOAL)
- [ ] Solana wallet integration (NEW)

### Week 2 (Planned)
- [ ] Firebase backend setup
- [ ] Token exchange implementation
- [ ] Complete crypto wallet integration
- [ ] Real-time price updates

### Week 3 (Planned)
- [ ] Final testing
- [ ] Performance optimization
- [ ] App Store preparation
- [ ] Ship v1! 🚀

## 🔧 Development Notes

### API Keys Needed
- [ ] Plaid (banking) - Need to create account
- [ ] Helius/QuickNode (Solana RPC) - Free tier available
- [ ] CoinGecko (crypto prices) - Free tier available
- [ ] Etherscan (wallet balances)
- [ ] Alpha Vantage (stock prices)

### Backend Requirements
- [ ] Token exchange endpoint
- [ ] Secure token storage
- [ ] Balance refresh endpoint
- [ ] Error logging

### Testing Checklist
- [ ] Plaid sandbox testing
- [ ] Multiple account types
- [ ] Token expiration handling
- [ ] Network failure scenarios
- [ ] Security audit
- [ ] Solana wallet validation
- [ ] Empty wallet handling

## 📝 Quick Decision Framework

For any feature request, ask:
1. **Does it automate data collection?** If no, it's v2.
2. **Does it help users trust the number?** If no, defer.
3. **Can it work without manual updates?** If no, rethink.
4. **Is it simpler than the alternative?** Always choose simple.

---

**Last Updated**: [Current Date]
**Next Review**: After Solana integration complete

Remember: We're not building a portfolio tracker. We're building an automatic net worth aggregator. Manual entry is a fallback, not the feature. 