//
//  ISOCodeSelectionViewController.swift
//  CurrencyConverter
//
//  Created by Anthony Jerez on 11/12/23.
//

import UIKit

class CodeSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let currencies: [Currency] = getCurrencies()
    var currenciesDictionary: [String: [Currency]] = [:]
    var sectionTitles: [String] = []
    weak var delegate: CodeSelectionDelegate?
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ISOCodeCell", for: indexPath) as! ISOCodeCell
        let sectionTitle = sectionTitles[indexPath.section]
        if let currenciesInSection = currenciesDictionary[sectionTitle] {
            let currency = currenciesInSection[indexPath.row]
            cell.backgroundColor = UIColor.black
            cell.isoCodeLabel.textColor = UIColor.white
            cell.isoCodeLabel.text = "\(currency.flag) \(currency.code) - \(currency.country)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitle = sectionTitles[indexPath.section]
        if let currenciesInSection = currenciesDictionary[sectionTitle] {
            let selectedCurrency = currenciesInSection[indexPath.row]
            delegate?.didSelectCurrency(selectedCurrency.code, selectedCurrency.flag)
            navigationController?.popViewController(animated: true)
        }
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

protocol CodeSelectionDelegate: AnyObject {
    func didSelectCurrency(_ code: String, _ flag: String)
}
