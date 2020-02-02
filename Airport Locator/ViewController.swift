//
//  ViewController.swift
//  Airport Locator
//
//  Created by Mohit Deval on 29/01/20.
//  Copyright © 2020 Mohit Deval. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapViewObject: MKMapView!
    var arrAirportData = [AirportData]()
    var strLatitude : Double?
    var strLongitude : Double?
    
    //MARK: - View lifeCycle  -
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewObject.delegate =  self
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapViewObject.showsUserLocation = true
        }
    }
    
    
    
    //MARK: - Location manager delegates -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapViewObject.setRegion(region, animated: true)
        }
        strLatitude = locations[0].coordinate.latitude
        strLongitude = locations[0].coordinate.longitude
        ServiceCallGetLocation(withcurrentLocation: strLatitude ?? 0.0, longitude: strLongitude ?? 0.0)
        manager.stopUpdatingLocation()
    }
    
    
    
    //MARK: - Service call methods
    private func ServiceCallGetLocation(withcurrentLocation latitude : Double , longitude : Double){
        let strUrl = String(format: "%@location=%f,%f%@", APIURL.BASEURL,latitude,longitude,APIURL.Params)
        APIManager.sharedInstance.getRequestAPI(url: strUrl) { (airports, error) in
            if let error = error {
                print("Get data error: \(error.localizedDescription)")
                return
            }
            guard let airport = airports  else { return }
            if airport.status == "OK"{
                self.arrAirportData = airport.results
                DispatchQueue.main.async {
                    for i in 0..<self.arrAirportData.count{
                        self.displayMarkerInMap(withLocation: self.arrAirportData[i].geometry?.location.lat ?? 0.0, longitude: self.arrAirportData[i].geometry?.location.lng ?? 0.0, name: self.arrAirportData[i].name ?? "")
                    }
                }
            } else {
                print("Some thing went wrong")
            }
        }
    }
    
    
    
    //MARK: - Display Marker -
    func displayMarkerInMap(withLocation latitude: Double , longitude: Double, name: String){
        let myLocation = CLLocation(latitude: strLatitude ?? 0.0, longitude: strLongitude ?? 0.0)
        let myBuddysLocation = CLLocation(latitude: latitude, longitude: longitude)
        let distance = myLocation.distance(from: myBuddysLocation) / 1000
        let london = MKPointAnnotation()
        london.title = name
        london.subtitle = String(format: "distance from user location %.01fkm", distance)
        london.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        mapViewObject.addAnnotation(london)
        
    }
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .roundedRect)
        }
        return view
    }
}

