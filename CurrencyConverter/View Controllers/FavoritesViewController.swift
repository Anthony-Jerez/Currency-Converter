//
//  FavoritesViewController.swift
//  CurrencyConverter
//
//  Created by Anthony Jerez on 11/16/23.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyFavoritesLabel: UILabel!
    var favoritePairs: [ConversionPair] = []
    var sections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = UIColor.black
        tableView.backgroundColor = UIColor.black
        tableView.separatorColor = UIColor.white
        updateFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defer {
            // show label if favorites is empty
            emptyFavoritesLabel.isHidden = !favoritePairs.isEmpty
        }
        favoritePairs = ConversionPair.getFavorites(forKey: ConversionPair.favoritesKey)
        organizeFavoritePairs()
        tableView.reloadData()
    }

    private func updateFavorites() {
        let favorites = ConversionPair.getFavorites(forKey: ConversionPair.favoritesKey)
        var updatedFavorites: [ConversionPair] = []
        let dispatchGroup = DispatchGroup()
        for favorite in favorites {
            let baseValue = favorite.conversionResult / favorite.conversionRate
            dispatchGroup.enter()
            CurrencySelectionService.fetchConversion(on: self, favorite.baseCode, favorite.targetCode, baseValue) { conversionPair in
                defer {
                    dispatchGroup.leave()
                }
                if let conversionPair = conversionPair {
                    updatedFavorites.append(conversionPair)
                } else {
                    print("Error fetching conversion for \(favorite.baseCode) to \(favorite.targetCode)")
                }
            }
        }
        // Update the array with the latest information
        dispatchGroup.notify(queue: .main) {
            self.favoritePairs = updatedFavorites
            ConversionPair.save(updatedFavorites, forKey: ConversionPair.favoritesKey)
            self.organizeFavoritePairs()
            self.tableView.reloadData()
        }
    }

    private func organizeFavoritePairs() {
        // Retrieve unique base codes from favorite pairs
        let uniqueBaseCodes = Set(favoritePairs.map { $0.baseCode })
        // Sort base codes alphabetically
        sections = uniqueBaseCodes.sorted()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewUtilities.numOfSections(sections)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableViewUtilities.titleForHeaderInSection(sections, section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableViewUtilities.viewForHeader(sections, section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableViewUtilities.heightForHeaderInSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let baseCode = sections[section]
        return favoritePairs.filter { $0.baseCode == baseCode }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritePairCell", for: indexPath) as! FavoritePairCell
        let baseCode = sections[indexPath.section]
        let pairsInSection = favoritePairs.filter { $0.baseCode == baseCode }
        let currencyPair = pairsInSection[indexPath.row]
        let baseAmount = (currencyPair.conversionResult / currencyPair.conversionRate).rounded(toPlaces: 4)
        let targetAmount = currencyPair.conversionResult.rounded(toPlaces: 4)
        let roundedBaseAmount = String(format: "%.4f", baseAmount)
        let roundedTargetAmount = String(format: "%.4f", targetAmount)
        let formattedBaseAmount = ConversionPair.removeTrailingZeros(for: roundedBaseAmount)
        let formattedTargetAmount = ConversionPair.removeTrailingZeros(for: roundedTargetAmount)
        cell.favoriteLabel.text = "\(currencyPair.baseCode): \(formattedBaseAmount)  ->  \(currencyPair.targetCode): \(formattedTargetAmount) "
        cell.erateLabel.text = "FX Rate: \(currencyPair.conversionRate)"
        cell.backgroundColor = UIColor.black
        cell.favoriteLabel.textColor = UIColor.white
        cell.erateLabel.textColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let baseCode = sections[indexPath.section]
            let pairsInSection = favoritePairs.filter { $0.baseCode == baseCode }
            let targetCode = pairsInSection[indexPath.row].targetCode
            let targetAmount = pairsInSection[indexPath.row].conversionResult
            favoritePairs = favoritePairs.filter { !($0.baseCode == baseCode && $0.targetCode == targetCode && $0.conversionResult == targetAmount) }
            ConversionPair.save(favoritePairs, forKey: ConversionPair.favoritesKey)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            organizeFavoritePairs()
        }
    }
}
    

