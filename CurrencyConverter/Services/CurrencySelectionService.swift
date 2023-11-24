//
//  CurrencySelectionService.swift
//  CurrencyConverter
//
//  Created by Anthony Jerez on 11/17/23.
//

import Foundation
import UIKit

class CurrencySelectionService {
    
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    private static func fetchData(from url: URL, on viewController: UIViewController, completion: @escaping (Data?) -> Void) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                showAlert(on: viewController, title: "Error", message:                          "\(error.localizedDescription)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                showAlert(on: viewController, title: "Response Error", message: "\(String(describing: response))")
                return
            }
            guard let data = data else {
                showAlert(on: viewController, title: "Error", message: "Data is NIL.")
                return
            }
            completion(data)
        }
        session.resume()
    }
    
    static func fetchConversion(on viewController: UIViewController, _ baseCode: String, _ targetCode: String, _ baseAmount: Double, completion: @escaping (ConversionPair?) -> Void) {
        let url = URL(string: "https://v6.exchangerate-api.com/v6/23488995c327d2f5b1c75e7b/pair/\(baseCode)/\(targetCode)/\(baseAmount)")!
        fetchData(from: url, on: viewController) { data in
            guard let data = data else { return }
            do {
                let conversionPair = try JSONDecoder().decode(ConversionPair.self, from: data)
                DispatchQueue.main.async {
                    completion(conversionPair)
                }
            } catch {
                showAlert(on: viewController, title: "Error Decoding JSON", message: "\(error.localizedDescription)")
            }
        }
    }
    
    static func fetchExchangeRates(on viewController: UIViewController, _ baseCode: String, completion: @escaping (ExchangeRates?) -> Void) {
        let url = URL(string: "https://v6.exchangerate-api.com/v6/23488995c327d2f5b1c75e7b/latest/\(baseCode)")!
        fetchData(from: url, on: viewController) { data in
            guard let data = data else { return }
            do {
                let exchangeRates = try JSONDecoder().decode(ExchangeRates.self, from: data)
                DispatchQueue.main.async {
                    completion(exchangeRates)
                }
            } catch {
                showAlert(on: viewController, title: "Error Decoding JSON", message: "\(error.localizedDescription)")
            }
        }
    }
}
