//
//  RetailItemTableViewCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 07/01/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class RetailItemTableViewCell: UITableViewCell {

    @IBOutlet weak var advertisingImage: UIImageView!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        self.backgroundColor = UIColor.white
        self.backgroundView = blurView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
