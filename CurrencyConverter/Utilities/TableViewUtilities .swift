//
//  TableViewUtilities .swift
//  CurrencyConverter
//
//  Created by Anthony Jerez on 11/19/23.
//

import Foundation
import UIKit

class TableViewUtilities {
    
    static func organizeCurrenciesIntoSections(_ currencies: [Currency], _ searchText: String? = nil) -> ([String: [Currency]], [String]) {
        var currenciesDictionary: [String: [Currency]] = [:]
        var sectionTitles: [String] = []
        let filteredCurrencies: [Currency]
        if let searchText = searchText, !searchText.isEmpty {
            filteredCurrencies = currencies.filter { currency in
                return isValidTextContainedInSearch(searchText, in: currency.code) ||
                isValidTextContainedInSearch(searchText, in: currency.country)
            }
        } else {
            filteredCurrencies = currencies
        }
        for currency in filteredCurrencies {
            let firstLetter = String(currency.code.prefix(1)).uppercased()
            if var sectionCurrencies = currenciesDictionary[firstLetter] {
                sectionCurrencies.append(currency)
                currenciesDictionary[firstLetter] = sectionCurrencies
            } else {
                currenciesDictionary[firstLetter] = [currency]
            }
        }
        sectionTitles = currenciesDictionary.keys.sorted()
        return (currenciesDictionary, sectionTitles)
    }
    
    private static func isValidTextContainedInSearch(_ searchText: String, in text: String) -> Bool {
        var searchTextIndex = searchText.startIndex
        var textIndex = text.startIndex
        while searchTextIndex < searchText.endIndex, textIndex < text.endIndex {
            if searchText[searchTextIndex].lowercased() == text[textIndex].lowercased() {
                searchTextIndex = searchText.index(after: searchTextIndex)
                textIndex = text.index(after: textIndex)
            } else {
                return false
            }
        }
        return searchTextIndex == searchText.endIndex
    }
    
    static func viewForHeader(_ sections: [String], _ section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black
        let label = UILabel()
        label.text = sections[section]
        label.textColor = UIColor.gray
        label.frame = CGRect(x: 16, y: 8, width: 200, height: 20)
        headerView.addSubview(label)
        return headerView
    }
    
    static func numOfSections(_ sections: [String]) -> Int {
        return sections.count
    }
    
    static func numOfRowsInSection(_ currenciesDictionary: [String: [Currency]], _ sections: [String], _ section: Int) -> Int {
        let sectionTitle = sections[section]
        return currenciesDictionary[sectionTitle]?.count ?? 0
    }
    
    static func titleForHeaderInSection(_ sections: [String], _ section: Int) -> String? {
        return sections[section]
    }
    
    static func heightForHeaderInSection() -> CGFloat {
        return 40
    }
    
    static func customizeSearchTextField(_ searchBar: UISearchBar) {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.lightGray
        }
    }
    
}
