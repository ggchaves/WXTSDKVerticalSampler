//
//  InsuranceIncidentLocationAnnotation.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 04/07/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import MapKit

class InsuranceIncidentLocationAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var colour: UIColor?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.colour = UIColor.white
    }
    
}
