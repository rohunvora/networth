import Foundation
import SwiftUI

@MainActor
class PortfolioManager: ObservableObject {
    @Published var assets: [Asset] = []
    @Published var isLoading = false
    @Published var lastRefresh: Date?
    
    // Historical data for tracking changes
    @Published var yesterdayNetWorth: Double = 0
    @Published var lastWeekNetWorth: Double = 0
    @Published var lastMonthNetWorth: Double = 0
    
    // Computed properties
    var totalNetWorth: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    var dailyChange: Double {
        totalNetWorth - yesterdayNetWorth
    }
    
    var dailyChangePercentage: Double {
        guard yesterdayNetWorth > 0 else { return 0 }
        return (dailyChange / yesterdayNetWorth) * 100
    }
    
    var assetCategories: [AssetCategory] {
        let groupedAssets = Dictionary(grouping: assets) { $0.type }
        
        return groupedAssets.map { type, assets in
            AssetCategory(
                name: type.rawValue,
                icon: type.icon,
                assets: assets.sorted { $0.value > $1.value }
            )
        }.sorted { $0.totalValue > $1.totalValue }
    }
    
    init() {
        loadSavedAssets()
    }
    
    // MARK: - Data Loading
    func loadInitialData() async {
        isLoading = true
        
        // Load saved assets
        loadSavedAssets()
        
        // Refresh all connected accounts
        await refreshAllAssets()
        
        isLoading = false
    }
    
    func refreshAllAssets() {
        Task {
            isLoading = true
            
            // Update manual assets (no refresh needed)
            let manualAssets = assets.filter { 
                if case .manual = $0.source { return true }
                return false
            }
            
            // Update connected assets
            let connectedAssets = assets.filter {
                if case .manual = $0.source { return false }
                return true
            }
            
            // TODO: Implement API calls for each connected source
            // For now, we'll simulate with random changes
            let updatedConnectedAssets = connectedAssets.map { asset in
                var updated = asset
                // Simulate price changes (-5% to +5%)
                let change = Double.random(in: 0.95...1.05)
                updated.value = asset.value * change
                updated.lastUpdated = Date()
                return updated
            }
            
            // Combine all assets
            assets = manualAssets + updatedConnectedAssets
            
            // Save to persistence
            saveAssets()
            
            // Update last refresh time
            lastRefresh = Date()
            
            isLoading = false
        }
    }
    
    // MARK: - Asset Management
    func addAsset(_ asset: Asset) {
        assets.append(asset)
        saveAssets()
    }
    
    func updateAsset(_ asset: Asset) {
        if let index = assets.firstIndex(where: { $0.id == asset.id }) {
            assets[index] = asset
            saveAssets()
        }
    }
    
    func deleteAsset(_ asset: Asset) {
        assets.removeAll { $0.id == asset.id }
        saveAssets()
    }
    
    // MARK: - Persistence
    private func saveAssets() {
        if let encoded = try? JSONEncoder().encode(assets) {
            UserDefaults.standard.set(encoded, forKey: "savedAssets")
        }
        
        // Save historical data
        UserDefaults.standard.set(totalNetWorth, forKey: "todayNetWorth")
        UserDefaults.standard.set(Date(), forKey: "lastSaveDate")
    }
    
    private func loadSavedAssets() {
        if let data = UserDefaults.standard.data(forKey: "savedAssets"),
           let decoded = try? JSONDecoder().decode([Asset].self, from: data) {
            assets = decoded
        } else {
            // Load sample data for demo
            loadSampleData()
        }
        
        // Load historical data
        yesterdayNetWorth = UserDefaults.standard.double(forKey: "yesterdayNetWorth")
        lastWeekNetWorth = UserDefaults.standard.double(forKey: "lastWeekNetWorth")
        lastMonthNetWorth = UserDefaults.standard.double(forKey: "lastMonthNetWorth")
    }
    
    private func loadSampleData() {
        assets = [
            Asset(
                name: "Checking Account",
                type: .cash,
                value: 15_000,
                source: .plaid
            ),
            Asset(
                name: "Apple Inc.",
                type: .stock,
                value: 25_000,
                quantity: 150,
                purchasePrice: 145,
                source: .api(provider: "Alpaca"),
                ticker: "AAPL"
            ),
            Asset(
                name: "Bitcoin",
                type: .crypto,
                value: 45_000,
                quantity: 1.5,
                purchasePrice: 25_000,
                source: .crypto(wallet: "Coinbase"),
                ticker: "BTC"
            ),
            Asset(
                name: "Ethereum",
                type: .crypto,
                value: 20_000,
                quantity: 10,
                purchasePrice: 1_500,
                source: .crypto(wallet: "MetaMask"),
                ticker: "ETH"
            ),
            Asset(
                name: "Investment Property",
                type: .realEstate,
                value: 450_000,
                purchasePrice: 380_000,
                source: .manual,
                customNote: "Rental property in Austin"
            ),
            Asset(
                name: "Startup Equity",
                type: .privateEquity,
                value: 100_000,
                source: .manual,
                customNote: "Series A investment in TechCo"
            )
        ]
        
        // Set historical data for demo
        yesterdayNetWorth = totalNetWorth * 0.98
        lastWeekNetWorth = totalNetWorth * 0.95
        lastMonthNetWorth = totalNetWorth * 0.92
    }
} 