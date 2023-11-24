//
//  ConvertViewController.swift
//  CurrencyConverter
//  Created by Anthony Jerez on 11/10/23.
//

import UIKit

class ConvertViewController: UIViewController, CodeSelectionDelegate {
    
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var baseCodeButton: UIButton!
    @IBOutlet weak var targetCodeButton: UIButton!
    @IBOutlet var calcButtons: [UIButton]!
    var currentConversionPair: ConversionPair?
    var isTargetButtonSelected: Bool?
    let codeButtonTextLen = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCalcButtons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let codeSelectionViewController = segue.destination as? CodeSelectionViewController else { return }
        if let buttonSelected = sender as? UIButton {
            isTargetButtonSelected = isTargetButtonTapped(buttonSelected)
        }
        codeSelectionViewController.delegate = self
    }
    
    private func configCalcButtons() {
        for button in calcButtons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.systemGray2
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        // retrieve currently saved favorite conversion pairs
        let favorites = ConversionPair.getFavorites(forKey: ConversionPair.favoritesKey)
        guard let currentConversionPair = currentConversionPair else { return }
        // add to favorites if same currency text is displayed on screen and favorites doesn't already contain it
        if isSameConversion() && !favorites.contains(currentConversionPair) {
            currentConversionPair.addToFavorites()
        }
    }
    
    private func isTargetButtonTapped(_ button: UIButton) -> Bool?{
        switch button.tag {
        case 0:
            return false // base code button was tapped
        case 1:
            return true // target code button was tapped
        default:
            return nil
        }
    }
    
    @IBAction func digitButtonTapped(_ sender: UIButton) {
        if let digit = sender.titleLabel?.text { 
            appendTextToBaseCurrLabel(digit)
        }
    }

    @IBAction func decimalButtonTapped(_ sender: UIButton) {
        guard let currentText = baseCurrencyLabel.text else { return }
        if !currentText.contains(".") {
            appendTextToBaseCurrLabel(".")
            guard let updatedText = baseCurrencyLabel.text else { return }
            if updatedText.hasPrefix(".") {
                baseCurrencyLabel.text = "0" + updatedText
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        baseCurrencyLabel.text = "0"
        targetCurrencyLabel.text = "0"
    }
    
    private func appendTextToBaseCurrLabel(_ text: String) {
        guard let currentText = baseCurrencyLabel.text else { return }
        if currentText == "0" {
            baseCurrencyLabel.text = text
        } else {
            baseCurrencyLabel.text = currentText + text
        }
    }
    
    @IBAction func convertButton(_ sender: UIButton) {
        guard !isSameConversion(), let baseText = baseCurrencyLabel.text,
              let decimalBaseValue = Double(baseText), !isZeroCurrency(decimalBaseValue),
              let baseCode = getCurrencyCode(from: baseCodeButton),
              let targetCode = getCurrencyCode(from: targetCodeButton) else {
            return
        }
        let roundedBaseValue = decimalBaseValue.rounded(toPlaces: 4)
        CurrencySelectionService.fetchConversion(on: self, baseCode, targetCode, roundedBaseValue) { [weak self] conversionPair in
            self?.currentConversionPair = conversionPair
            self?.updateLabels(with: baseText, targetValue: conversionPair?.conversionResult)
        }
    }
    
    private func isZeroCurrency(_ value: Double) -> Bool {
        return value == 0.0
    }
    
    private func getCurrencyCode(from button: UIButton) -> String? {
        guard let buttonText = button.titleLabel?.text, buttonText.count == codeButtonTextLen else {
            return nil
        }
        return String(buttonText.suffix(3))
    }

    private func updateLabels(with baseText: String, targetValue: Double?) {
        let roundedTargetValue = targetValue?.rounded(toPlaces: 4)
        let targetAmount = String(format: "%.4f", roundedTargetValue ?? "0")
        targetCurrencyLabel.text = ConversionPair.removeTrailingZeros(for: targetAmount)
        baseCurrencyLabel.text = ConversionPair.removeTrailingZeros(for: baseText)
    }
    
    private func isSameConversion() -> Bool {
        guard let currentConversionPair = currentConversionPair else { return false }
        // retrieve currency information provided
        guard let baseCode = getCurrencyCode(from: baseCodeButton),
              let targetCode = getCurrencyCode(from: targetCodeButton),
              let baseText = baseCurrencyLabel.text,
              let targetText = targetCurrencyLabel.text,
              let baseValue = Double(baseText)?.rounded(toPlaces: 4),
              let targetValue = Double(targetText)?.rounded(toPlaces: 4)
        else {
            return false
        }
        // get current conversion pair's target value
        let currConversionPairBaseValue = (currentConversionPair.conversionResult / currentConversionPair.conversionRate).rounded(toPlaces: 4)
        // return true if same conversion is being performed
        return baseCode == currentConversionPair.baseCode &&
               targetCode == currentConversionPair.targetCode &&
               baseValue == currConversionPairBaseValue &&
               targetValue == currentConversionPair.conversionResult.rounded(toPlaces: 4)
    }
    
    func didSelectCurrency(_ code: String, _ flag: String) {
        let text = flag + " " + code
        if isTargetButtonSelected == true {
            targetCodeButton.setTitle(text, for: .normal)
        } else {
            baseCodeButton.setTitle(text, for: .normal)
        }
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
