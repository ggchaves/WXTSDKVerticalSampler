//
//  RetailCartItemTableViewCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 13/04/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class RetailCartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
