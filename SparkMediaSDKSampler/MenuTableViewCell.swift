//
//  MenuTableViewCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 11/01/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var scenarioImageView: UIImageView!
    @IBOutlet weak var scenarioLabel: UILabel!
    var segueIdentifier: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scenarioLabel.layer.masksToBounds = true
        self.scenarioLabel.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
