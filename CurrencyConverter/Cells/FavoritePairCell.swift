//
//  FavoritePairCell.swift
//  CurrencyConverter
//
//  Created by Anthony Jerez on 11/16/23.
//

import UIKit

class FavoritePairCell: UITableViewCell {
    
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var erateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
