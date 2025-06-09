import SwiftUI

@main
struct NetworthTrackerApp: App {
    @StateObject private var portfolioManager = PortfolioManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(portfolioManager)
        }
    }
} 