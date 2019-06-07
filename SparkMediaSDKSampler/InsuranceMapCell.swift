//
//  InsuranceMapCell.swift
//  SparkMediaSDKSampler
//
//  Created by Jonathan Field on 25/06/2017.
//  Copyright © 2017 JonathanField. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InsuranceMapCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.delegate = self
        self.mapView.setCenter(CLLocationCoordinate2DMake(30.243358, -97.735369), animated: true)
        
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(30.243358, -97.735369)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
        let incident = InsuranceIncidentLocationAnnotation()
        incident.coordinate = CLLocationCoordinate2DMake(30.243358, -97.735369)
        incident.image = UIImage(named: "insuranceIncidentAnnotationImage")
        incident.title = "Incident Location"
        self.mapView.addAnnotations([incident])
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {  //Handle user location annotation..
            return nil  //Default is to let the system handle it.
        }
        
        if !annotation.isKind(of: InsuranceIncidentLocationAnnotation.self) {  //Handle non-ImageAnnotations..
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
            }
            return pinAnnotationView
        }
        
        //Handle ImageAnnotations..
        var view: InsuranceIncidentLocationAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "incidentAnnotation") as? InsuranceIncidentLocationAnnotationView
        if view == nil {
            view = InsuranceIncidentLocationAnnotationView(annotation: annotation, reuseIdentifier: "incidentAnnotation")
        }
        
        let annotation = annotation as! InsuranceIncidentLocationAnnotation
        view?.image = annotation.image
        view?.annotation = annotation
        
        return view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
