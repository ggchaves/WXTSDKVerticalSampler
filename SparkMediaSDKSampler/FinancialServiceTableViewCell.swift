//
//  FinancialServiceTableViewCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 15/03/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class FinancialServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
