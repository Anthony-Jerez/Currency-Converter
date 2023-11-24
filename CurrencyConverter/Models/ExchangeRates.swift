//
//  ExchangeRates.swift
//  CurrencyConverter
//
//  Created by Anthony Jerez on 11/18/23.
//

import Foundation

struct ExchangeRates: Decodable {
    let baseCode: String
    let conversionRates: [String: Double]
    
    private enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}
