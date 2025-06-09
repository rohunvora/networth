import Foundation

extension Double {
    func asCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        // For large numbers, use abbreviated format
        if self >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            let millions = self / 1_000_000
            return formatter.string(from: NSNumber(value: millions))! + "M"
        } else if self >= 10_000 {
            return formatter.string(from: NSNumber(value: self)) ?? "$0"
        } else {
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            return formatter.string(from: NSNumber(value: self)) ?? "$0"
        }
    }
    
    func asPercentage() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 1
        formatter.positivePrefix = "+"
        return formatter.string(from: NSNumber(value: self / 100)) ?? "0%"
    }
    
    func formatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
} 