import Foundation

// MARK: - Asset Types
enum AssetType: String, CaseIterable, Codable {
    case stock = "Stock"
    case crypto = "Crypto"
    case realEstate = "Real Estate"
    case cash = "Cash"
    case bond = "Bond"
    case privateEquity = "Private Equity"
    case commodity = "Commodity"
    case nft = "NFT"
    case defi = "DeFi"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .stock: return "chart.line.uptrend.xyaxis"
        case .crypto: return "bitcoinsign.circle"
        case .realEstate: return "house.fill"
        case .cash: return "dollarsign.circle"
        case .bond: return "doc.text"
        case .privateEquity: return "briefcase.fill"
        case .commodity: return "cube.fill"
        case .nft: return "photo.artframe"
        case .defi: return "link.circle"
        case .other: return "questionmark.circle"
        }
    }
}

// MARK: - Asset Model
struct Asset: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: AssetType
    var value: Double
    var quantity: Double?
    var purchasePrice: Double?
    var lastUpdated: Date
    var source: AssetSource
    var ticker: String?
    var customNote: String?
    
    // Computed properties
    var subtitle: String? {
        switch source {
        case .manual:
            return "Manual entry"
        case .plaid:
            return "Connected account"
        case .crypto(let wallet):
            return wallet
        case .api(let provider):
            return provider
        }
    }
    
    var gainLoss: Double? {
        guard let purchasePrice = purchasePrice, let quantity = quantity else { return nil }
        return value - (purchasePrice * quantity)
    }
    
    var gainLossPercentage: Double? {
        guard let purchasePrice = purchasePrice, let quantity = quantity else { return nil }
        let totalPurchasePrice = purchasePrice * quantity
        return ((value - totalPurchasePrice) / totalPurchasePrice) * 100
    }
    
    init(id: UUID = UUID(),
         name: String,
         type: AssetType,
         value: Double,
         quantity: Double? = nil,
         purchasePrice: Double? = nil,
         lastUpdated: Date = Date(),
         source: AssetSource = .manual,
         ticker: String? = nil,
         customNote: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.value = value
        self.quantity = quantity
        self.purchasePrice = purchasePrice
        self.lastUpdated = lastUpdated
        self.source = source
        self.ticker = ticker
        self.customNote = customNote
    }
}

// MARK: - Asset Source
enum AssetSource: Codable {
    case manual
    case plaid
    case crypto(wallet: String)
    case api(provider: String)
}

// MARK: - Asset Category
struct AssetCategory: Identifiable {
    let id: UUID
    let name: String
    let icon: String
    let assets: [Asset]
    
    var totalValue: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    init(id: UUID = UUID(), name: String, icon: String, assets: [Asset]) {
        self.id = id
        self.name = name
        self.icon = icon
        self.assets = assets
    }
} 