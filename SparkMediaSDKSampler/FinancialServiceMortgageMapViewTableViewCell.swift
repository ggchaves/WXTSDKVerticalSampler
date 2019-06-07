//
//  FinancialServiceMortgageMapViewTableViewCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 09/04/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FinancialServiceMortgageMapViewTableViewCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.delegate = self
        self.mapView.setCenter(CLLocationCoordinate2DMake(37.3382082, -121.8863286), animated: true)
        
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.3382082, -121.8863286)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
        let houseOne = MKPointAnnotation()
        houseOne.coordinate = CLLocationCoordinate2DMake(37.33239218, -121.88610077)
        let houseTwo = MKPointAnnotation()
        houseTwo.coordinate = CLLocationCoordinate2DMake(37.3368622, -121.8948555)
        let houseThree = MKPointAnnotation()
        houseThree.coordinate = CLLocationCoordinate2DMake(37.33733989, -121.88996315)
        self.mapView.addAnnotations([houseOne, houseTwo, houseThree])
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
//        self.mapView.showsBuildings = true
//        self.mapView.showsScale = true
//        self.mapView.showsPointsOfInterest = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
