//
//  TargetCodesSelectionViewController.swift
//  CurrencyConverter
//
//  Created by Anthony Jerez on 11/18/23.
//

import UIKit

class TargetCodesSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    let currencies: [Currency] = getCurrencies()
    var selectedCurrencies: [Currency] = []
    var currenciesDictionary: [String: [Currency]] = [:]
    var sectionTitles: [String] = []
    let maxNumSelections = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = UIColor.black
        tableView.backgroundColor = UIColor.black
        tableView.separatorColor = UIColor.white
        TableViewUtilities.customizeSearchTextField(searchBar)
        organizeCurrenciesIntoSections()
    }

    private func organizeCurrenciesIntoSections() {
        (currenciesDictionary, sectionTitles) = TableViewUtilities.organizeCurrenciesIntoSections(currencies)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewUtilities.numOfSections(sectionTitles)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewUtilities.numOfRowsInSection(currenciesDictionary, sectionTitles, section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableViewUtilities.titleForHeaderInSection(sectionTitles, section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableViewUtilities.viewForHeader(sectionTitles, section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableViewUtilities.heightForHeaderInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TargetCodeCell", for: indexPath) as! TargetCodeCell
        let sectionTitle = sectionTitles[indexPath.section]
        if let currenciesInSection = currenciesDictionary[sectionTitle] {
            let currency = currenciesInSection[indexPath.row]
            cell.backgroundColor = UIColor.black
            cell.targetCodeLabel.textColor = UIColor.white
            cell.targetCodeLabel.text = "\(currency.flag) \(currency.code) - \(currency.country)"
            cell.accessoryType = selectedCurrencies.contains { $0 == currency } ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitle = sectionTitles[indexPath.section]
        if let currenciesInSection = currenciesDictionary[sectionTitle] {
            let selectedCurrency = currenciesInSection[indexPath.row]
            if selectedCurrencies.count < maxNumSelections || selectedCurrencies.contains(selectedCurrency) {
                if let index = selectedCurrencies.firstIndex(of: selectedCurrency) {
                    selectedCurrencies.remove(at: index)
                } else {
                    selectedCurrencies.append(selectedCurrency)
                }
                tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                CurrencySelectionService.showAlert(on: self, title: "Limit Exceeded", message: "You can only select at most \(maxNumSelections) target currencies.")
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "UnwindToExchangeRatesController", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        (currenciesDictionary, sectionTitles) = TableViewUtilities.organizeCurrenciesIntoSections(currencies, searchText)
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        (currenciesDictionary, sectionTitles) = TableViewUtilities.organizeCurrenciesIntoSections(currencies)
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }

}
