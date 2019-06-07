//
//  FinancialCustomerTableViewCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 08/04/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class FinancialCustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerCardNumber: UILabel!
    @IBOutlet weak var creditCardProvider: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
