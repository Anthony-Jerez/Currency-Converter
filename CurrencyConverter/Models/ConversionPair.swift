//
//  ConversionPairModel.swift
//  CurrencyConverter
//
//  Created by Anthony Jerez on 11/11/23.
//

import Foundation

struct ConversionPair: Codable, Equatable {
    let baseCode: String
    let targetCode: String
    let conversionRate: Double
    let conversionResult: Double
    
    private enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case targetCode = "target_code"
        case conversionRate = "conversion_rate"
        case conversionResult = "conversion_result"
    }
}

extension ConversionPair {
    
    static var favoritesKey: String {
        return "Favorites"
    }
    
    static func save(_ favoritePairs: [ConversionPair], forKey key: String) {
        let defaults = UserDefaults.standard
        let encodedData = try! JSONEncoder().encode(favoritePairs)
        defaults.set(encodedData, forKey: key)
    }

    static func getFavorites(forKey key: String) -> [ConversionPair] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key) {
            let decodedFavPairs = try! JSONDecoder().decode([ConversionPair].self, from: data)
            return decodedFavPairs
        } else {
            return []
        }
    }
    
    func addToFavorites() {
        var favoritePairs = ConversionPair.getFavorites(forKey: ConversionPair.favoritesKey)
        favoritePairs.append(self)
        ConversionPair.save(favoritePairs, forKey: ConversionPair.favoritesKey)
    }

    func removeFromFavorites() {
        var favoritePairs = ConversionPair.getFavorites(forKey: ConversionPair.favoritesKey)
        favoritePairs.removeAll { favoritePair in
            return self == favoritePair
        }
        ConversionPair.save(favoritePairs, forKey: ConversionPair.favoritesKey)
    }
    
    static func removeTrailingZeros(for text: String) -> String {
        var formattedText = text
        while formattedText.contains(".") && formattedText.hasSuffix("0") {
            formattedText.removeLast()
        }
        if formattedText.hasSuffix(".") {
            formattedText.removeLast()
        }
        return formattedText
    }

}


