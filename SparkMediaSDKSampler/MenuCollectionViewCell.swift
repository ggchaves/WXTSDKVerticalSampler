//
//  MenuCollectionViewCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 14/04/2018.
//  Copyright © 2018 JonathanField. All rights reserved.
//

import UIKit
import CollectionViewSlantedLayout

let yOffsetSpeed: CGFloat = 150.0
let xOffsetSpeed: CGFloat = 100.0

class MenuCollectionViewCell: CollectionViewSlantedCell {
    
    @IBOutlet weak var imageView: UIImageView!
    private var gradient = CAGradientLayer()
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let backgroundView = backgroundView {
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradient.locations = [0.0, 1.0]
            gradient.frame = backgroundView.bounds
            backgroundView.layer.addSublayer(gradient)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let backgroundView = backgroundView {
            gradient.frame = backgroundView.bounds
        }
//        self.textLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    var imageHeight: CGFloat {
        return (imageView?.image?.size.height) ?? 0.0
    }
    
    var imageWidth: CGFloat {
        return (imageView?.image?.size.width) ?? 0.0
    }
    
    
    func offset(_ offset: CGPoint) {
        imageView.frame = self.imageView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
    
}
