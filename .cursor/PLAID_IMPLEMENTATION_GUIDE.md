# Plaid Integration Implementation Guide

## 🎯 Why This is Priority #1
Without Plaid, users are just using a fancy calculator. With Plaid, they get automatic aggregation - the core value prop.

## 📋 Pre-Implementation Checklist

### 1. Plaid Account Setup
- [ ] Create account at https://dashboard.plaid.com/signup
- [ ] Get Sandbox credentials:
  - Client ID: `_________________`
  - Secret: `_________________`
  - Environment: `sandbox`
- [ ] Review documentation: https://plaid.com/docs/

### 2. Backend Decision
You MUST have a backend for security. Options ranked by speed:

1. **Firebase Functions** (Recommended - 2 hours setup)
   - Already has auth
   - Easy deployment
   - Free tier sufficient

2. **Vercel Edge Functions** (Alternative - 1 hour setup)
   - Super fast deployment
   - Good for simple endpoints

3. **AWS Lambda** (If you know AWS - 3 hours)
   - More complex but scalable

## 🚀 Implementation Steps

### Step 1: Add Plaid SDK to iOS Project

```bash
# In Xcode:
1. File → Add Package Dependencies
2. Enter: https://github.com/plaid/plaid-link-ios
3. Version: Up to Next Major (4.0.0)
4. Add to NetworthTracker target
```

### Step 2: Update Info.plist

```xml
<!-- Add to NetworthTracker/Info.plist -->
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>plaidlink</string>
</array>
```

### Step 3: Create PlaidModels.swift

```swift
import Foundation

struct PlaidAccount: Codable, Identifiable {
    let id: String
    let name: String
    let officialName: String?
    let mask: String?
    let type: PlaidAccountType
    let subtype: String?
    let balances: PlaidBalances
    
    var displayName: String {
        officialName ?? name
    }
}

struct PlaidBalances: Codable {
    let available: Double?
    let current: Double
    let limit: Double?
    let isoCurrencyCode: String?
    let unofficialCurrencyCode: String?
}

enum PlaidAccountType: String, Codable {
    case investment
    case credit
    case depository
    case loan
    case other
    
    var assetType: AssetType {
        switch self {
        case .investment: return .stock
        case .credit: return .cash
        case .depository: return .cash
        case .loan: return .cash
        case .other: return .other
        }
    }
}

struct PlaidLinkToken: Codable {
    let linkToken: String
    let expiration: String
}
```

### Step 4: Create PlaidService.swift

```swift
import Foundation
import LinkKit
import SwiftUI

@MainActor
class PlaidService: ObservableObject {
    static let shared = PlaidService()
    
    @Published var isLinkPresented = false
    @Published var isLoading = false
    @Published var linkedInstitutions: [String] = []
    
    private var linkHandler: Handler?
    private let baseURL = "YOUR_BACKEND_URL" // Update this!
    
    // MARK: - Link Token Creation
    func createLinkToken() async throws -> String {
        let url = URL(string: "\(baseURL)/api/plaid/create-link-token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add user ID if you have auth
        let body = ["userId": "demo_user"]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(PlaidLinkToken.self, from: data)
        return response.linkToken
    }
    
    // MARK: - Open Plaid Link
    func openLink() {
        Task {
            do {
                isLoading = true
                let linkToken = try await createLinkToken()
                
                var configuration = LinkTokenConfiguration(
                    token: linkToken,
                    onSuccess: { [weak self] success in
                        self?.handleSuccess(success.publicToken)
                    }
                )
                
                configuration.onExit = { exit in
                    if let error = exit.error {
                        print("Plaid Link error: \(error)")
                    }
                }
                
                let result = Plaid.create(configuration)
                switch result {
                case .success(let handler):
                    self.linkHandler = handler
                    handler.open(presentUsing: .viewController(
                        getRootViewController()
                    ))
                case .failure(let error):
                    print("Failed to create handler: \(error)")
                }
                
                isLoading = false
            } catch {
                print("Failed to create link token: \(error)")
                isLoading = false
            }
        }
    }
    
    // MARK: - Handle Success
    private func handleSuccess(_ publicToken: String) {
        Task {
            do {
                let accounts = try await exchangeToken(publicToken)
                await MainActor.run {
                    // Add accounts to portfolio
                    for account in accounts {
                        PortfolioManager.shared.addPlaidAccount(account)
                    }
                }
            } catch {
                print("Failed to exchange token: \(error)")
            }
        }
    }
    
    // MARK: - Exchange Token
    private func exchangeToken(_ publicToken: String) async throws -> [PlaidAccount] {
        let url = URL(string: "\(baseURL)/api/plaid/exchange-token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["publicToken": publicToken]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let accounts = try JSONDecoder().decode([PlaidAccount].self, from: data)
        return accounts
    }
    
    // MARK: - Refresh Balances
    func refreshBalances(for accessToken: String) async throws -> [PlaidAccount] {
        let url = URL(string: "\(baseURL)/api/plaid/get-balances")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["accessToken": accessToken]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let accounts = try JSONDecoder().decode([PlaidAccount].self, from: data)
        return accounts
    }
    
    // Helper to get root view controller
    private func getRootViewController() -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window.rootViewController!
    }
}
```

### Step 5: Update Asset Model

```swift
// Add to Asset.swift
extension Asset {
    var plaidAccountId: String?
    var plaidAccessToken: String?
    var institutionName: String?
    
    static func fromPlaidAccount(_ account: PlaidAccount, accessToken: String, institutionName: String) -> Asset {
        Asset(
            name: account.displayName,
            type: account.type.assetType,
            value: account.balances.current,
            source: .api(provider: "Plaid - \(institutionName)"),
            customNote: account.mask != nil ? "****\(account.mask!)" : nil
        )
    }
}
```

### Step 6: Update PortfolioManager

```swift
// Add to PortfolioManager.swift
extension PortfolioManager {
    func addPlaidAccount(_ account: PlaidAccount) {
        let asset = Asset.fromPlaidAccount(
            account,
            accessToken: "stored_securely",
            institutionName: "Bank Name"
        )
        addAsset(asset)
    }
    
    func refreshPlaidAccounts() async {
        let plaidAssets = assets.filter { asset in
            if case .api(let provider) = asset.source,
               provider.starts(with: "Plaid") {
                return true
            }
            return false
        }
        
        // TODO: Implement refresh using stored tokens
        for asset in plaidAssets {
            // Refresh each account
        }
    }
}
```

### Step 7: Update UI

```swift
// Update ContentView.swift
struct ContentView: View {
    @EnvironmentObject var portfolioManager: PortfolioManager
    @StateObject private var plaidService = PlaidService.shared
    
    var body: some View {
        NavigationStack {
            // ... existing code ...
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            plaidService.openLink()
                        }) {
                            Label("Connect Bank Account", systemImage: "building.columns")
                        }
                        
                        Button(action: { showingAddAsset = true }) {
                            Label("Add Manual Asset", systemImage: "plus")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .overlay {
                if plaidService.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                }
            }
        }
    }
}
```

## 🔥 Firebase Backend Setup (Recommended)

### 1. Initialize Firebase Project

```bash
npm install -g firebase-tools
firebase init functions
# Select: JavaScript, ESLint: No, Install dependencies: Yes
```

### 2. Install Dependencies

```bash
cd functions
npm install plaid axios
```

### 3. Create Backend Functions

```javascript
// functions/index.js
const functions = require('firebase-functions');
const { Configuration, PlaidApi, PlaidEnvironments } = require('plaid');

const configuration = new Configuration({
  basePath: PlaidEnvironments.sandbox,
  baseOptions: {
    headers: {
      'PLAID-CLIENT-ID': 'YOUR_CLIENT_ID',
      'PLAID-SECRET': 'YOUR_SANDBOX_SECRET',
    },
  },
});

const plaidClient = new PlaidApi(configuration);

// Create Link Token
exports.createLinkToken = functions.https.onRequest(async (req, res) => {
  try {
    const response = await plaidClient.linkTokenCreate({
      client_name: 'Net Worth Tracker',
      country_codes: ['US'],
      language: 'en',
      products: ['accounts', 'balances', 'investments'],
      user: {
        client_user_id: req.body.userId || 'anonymous',
      },
    });
    
    res.json({ linkToken: response.data.link_token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
});

// Exchange Public Token
exports.exchangeToken = functions.https.onRequest(async (req, res) => {
  try {
    const { publicToken } = req.body;
    
    // Exchange for access token
    const tokenResponse = await plaidClient.itemPublicTokenExchange({
      public_token: publicToken,
    });
    
    const accessToken = tokenResponse.data.access_token;
    
    // Get accounts
    const accountsResponse = await plaidClient.accountsBalanceGet({
      access_token: accessToken,
    });
    
    // Store access token securely (Firestore recommended)
    // TODO: Save to database
    
    res.json(accountsResponse.data.accounts);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
});

// Get Balances
exports.getBalances = functions.https.onRequest(async (req, res) => {
  try {
    const { accessToken } = req.body;
    
    const response = await plaidClient.accountsBalanceGet({
      access_token: accessToken,
    });
    
    res.json(response.data.accounts);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
});
```

### 4. Deploy Backend

```bash
firebase deploy --only functions
# Note your function URLs
```

### 5. Update PlaidService.swift

Replace `YOUR_BACKEND_URL` with your Firebase Functions URL:
```swift
private let baseURL = "https://us-central1-YOUR-PROJECT.cloudfunctions.net"
```

## 🧪 Testing

### Sandbox Credentials
- Username: `user_good`
- Password: `pass_good`
- MFA (if needed): `1234`

### Test Flow
1. Tap "Connect Bank Account"
2. Search for "Chase" in Plaid Link
3. Enter sandbox credentials
4. Select accounts to link
5. Verify accounts appear in app
6. Check balances are correct

## ⚠️ Security Checklist

- [ ] NEVER store Plaid secrets in iOS app
- [ ] Access tokens only stored on backend
- [ ] Use HTTPS for all API calls
- [ ] Implement token encryption at rest
- [ ] Add request authentication
- [ ] Rate limit API endpoints
- [ ] Log all token exchanges

## 🚀 Go Live Checklist

1. **Upgrade Plaid Account**
   - Apply for Production access
   - Get Production credentials
   - Update backend configuration

2. **Security Audit**
   - Pen test token storage
   - Review encryption methods
   - Validate auth flow

3. **Error Handling**
   - Test all failure scenarios
   - Add user-friendly error messages
   - Implement retry logic

4. **Performance**
   - Cache account data locally
   - Implement background refresh
   - Optimize API calls

## 📊 Success Metrics

After implementation, you should see:
- [ ] 80%+ users connect at least one account
- [ ] < 30 second connection flow
- [ ] < 2 second balance refresh
- [ ] 0 security incidents

---

Remember: This single feature transforms your app from a manual tracker to an automatic aggregator. It's worth getting right. 