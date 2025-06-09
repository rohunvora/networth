import SwiftUI

struct AddAssetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var portfolioManager: PortfolioManager
    
    @State private var assetName = ""
    @State private var assetType: AssetType = .stock
    @State private var value: String = ""
    @State private var quantity: String = ""
    @State private var purchasePrice: String = ""
    @State private var ticker: String = ""
    @State private var customNote: String = ""
    @State private var sourceType: SourceType = .manual
    
    enum SourceType {
        case manual
        case connected
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Asset Information") {
                    TextField("Asset Name", text: $assetName)
                    
                    Picker("Asset Type", selection: $assetType) {
                        ForEach(AssetType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    
                    if assetType == .stock || assetType == .crypto {
                        TextField("Ticker Symbol", text: $ticker)
                            .textInputAutocapitalization(.characters)
                    }
                }
                
                Section("Value") {
                    HStack {
                        Text("$")
                        TextField("Current Value", text: $value)
                            .keyboardType(.decimalPad)
                    }
                    
                    if assetType != .cash && assetType != .realEstate {
                        TextField("Quantity", text: $quantity)
                            .keyboardType(.decimalPad)
                        
                        HStack {
                            Text("$")
                            TextField("Purchase Price (per unit)", text: $purchasePrice)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
                
                Section("Source") {
                    Picker("Source Type", selection: $sourceType) {
                        Text("Manual Entry").tag(SourceType.manual)
                        Text("Connected Account").tag(SourceType.connected)
                    }
                    .pickerStyle(.segmented)
                    
                    if sourceType == .connected {
                        Text("Account connection coming soon!")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                
                if assetType == .privateEquity || assetType == .other || assetType == .realEstate {
                    Section("Notes") {
                        TextEditor(text: $customNote)
                            .frame(minHeight: 80)
                    }
                }
            }
            .navigationTitle("Add Asset")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addAsset()
                    }
                    .disabled(assetName.isEmpty || value.isEmpty)
                }
            }
        }
    }
    
    private func addAsset() {
        guard let valueDouble = Double(value) else { return }
        
        let asset = Asset(
            name: assetName,
            type: assetType,
            value: valueDouble,
            quantity: Double(quantity),
            purchasePrice: Double(purchasePrice),
            source: sourceType == .manual ? .manual : .api(provider: "Coming Soon"),
            ticker: ticker.isEmpty ? nil : ticker,
            customNote: customNote.isEmpty ? nil : customNote
        )
        
        portfolioManager.addAsset(asset)
        dismiss()
    }
}

struct AddAssetView_Previews: PreviewProvider {
    static var previews: some View {
        AddAssetView()
            .environmentObject(PortfolioManager())
    }
} 