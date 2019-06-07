//
//  FinancialServicesMortgageSliderTableViewCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 09/04/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit

class FinancialServicesMortgageSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var sliderDescription: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let step: Float = 1000
        let roundedValue = round(sender.value / step) * step
        self.sliderValue.text = "$\(Int(roundedValue))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
