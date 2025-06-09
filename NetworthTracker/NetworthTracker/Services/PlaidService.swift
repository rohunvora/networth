import SwiftUI
import LinkKit

class PlaidService: ObservableObject {
    @Published var isLinking = false
    
    func openLink() {
        // For now, just test that Link opens
        // We'll use a pre-made link token from Plaid's dashboard
        
        // TODO: Replace with your link token from Plaid Dashboard
        let linkToken = "link-sandbox-YOUR-TOKEN-HERE" // Temporary!
        
        var configuration = LinkTokenConfiguration(
            token: linkToken,
            onSuccess: { success in
                print("🎉 SUCCESS! Public token: \(success.publicToken)")
                print("🏦 Institution: \(success.metadata.institution.name)")
                print("📊 Accounts: \(success.metadata.accounts.count)")
                // This proves Plaid is working!
            }
        )
        
        configuration.onExit = { exit in
            if let error = exit.error {
                print("❌ Error: \(error.localizedDescription)")
            } else {
                print("👋 User exited Link")
            }
        }
        
        let result = Plaid.create(configuration)
        switch result {
        case .success(let handler):
            // Get the root view controller
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                print("❌ Could not find root view controller")
                return
            }
            
            handler.open(presentUsing: .viewController(rootViewController))
            isLinking = true
            print("✅ Plaid Link opened!")
            
        case .failure(let error):
            print("❌ Failed to create Plaid handler: \(error)")
        }
    }
} 