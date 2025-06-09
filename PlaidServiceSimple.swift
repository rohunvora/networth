import SwiftUI

// Minimal PlaidService to get the app running
class PlaidService: ObservableObject {
    @Published var isLinking = false
    
    func openLink() {
        print("📱 Plaid integration coming soon!")
        print("For now, use 'Add Manual Asset' to track your accounts")
        
        // Show a simple alert for now
        isLinking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLinking = false
        }
    }
} 