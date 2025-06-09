import SwiftUI

struct ContentView: View {
    @EnvironmentObject var portfolioManager: PortfolioManager
    @State private var showingAddAsset = false
    @StateObject private var plaid = PlaidService()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Net Worth Header
                NetWorthHeaderView(totalValue: portfolioManager.totalNetWorth)
                    .padding(.top, 20)
                
                // Daily Change
                DailyChangeView(
                    change: portfolioManager.dailyChange,
                    percentageChange: portfolioManager.dailyChangePercentage
                )
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // Connect Bank Account Button (prominent for testing)
                Button(action: {
                    plaid.openLink()
                }) {
                    Label("Connect Bank Account", systemImage: "building.columns.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                // Asset Breakdown
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(portfolioManager.assetCategories) { category in
                            AssetCategoryCard(category: category)
                        }
                    }
                    .padding()
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            plaid.openLink()
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { portfolioManager.refreshAllAssets() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .sheet(isPresented: $showingAddAsset) {
                AddAssetView()
            }
        }
        .task {
            await portfolioManager.loadInitialData()
        }
        .overlay {
            if plaid.isLinking {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView("Connecting...")
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                    }
            }
        }
    }
}

struct NetWorthHeaderView: View {
    let totalValue: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Net Worth")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(totalValue.asCurrency())
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

struct DailyChangeView: View {
    let change: Double
    let percentageChange: Double
    
    var changeColor: Color {
        change >= 0 ? .green : .red
    }
    
    var body: some View {
        HStack {
            Image(systemName: change >= 0 ? "arrow.up.right" : "arrow.down.right")
                .font(.caption)
                .foregroundColor(changeColor)
            
            Text(change.asCurrency())
                .font(.headline)
                .foregroundColor(changeColor)
            
            Text("(\(percentageChange.asPercentage()))")
                .font(.subheadline)
                .foregroundColor(changeColor.opacity(0.8))
            
            Spacer()
            
            Text("Today")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(changeColor.opacity(0.1))
        .cornerRadius(12)
    }
}

struct AssetCategoryCard: View {
    let category: AssetCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(category.name, systemImage: category.icon)
                    .font(.headline)
                
                Spacer()
                
                Text(category.totalValue.asCurrency())
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            if !category.assets.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(category.assets) { asset in
                        AssetRowView(asset: asset)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

struct AssetRowView: View {
    let asset: Asset
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(asset.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                if let subtitle = asset.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(asset.value.asCurrency())
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                if let quantity = asset.quantity {
                    Text("\(quantity.formatted()) units")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PortfolioManager())
    }
} 