//
//  FinancialAccountActivityTableViewCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 28/02/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class FinancialAccountActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var colourTag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFromConfiguration(configuration: Dictionary <String, String>) {
        self.merchantName.text = "Hello"
    }

}
