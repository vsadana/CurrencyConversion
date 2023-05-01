//
//  CurrencyCollectionViewCell.swift
//  CurrencyConversion
//
//  Created by Vaibhav Sadana on 29/04/23.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        layer.borderColor = UIColor(red: 154/255, green: 251/255, blue: 37/255, alpha: 1.0).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 18.0


    }
    func configure(amount:Any?, lblCurrencyName:String?){
        lblCurrency.text = lblCurrencyName
        lblAmount.text = "\(amount ?? "")"
    }
}
