//
//  ViewController.swift
//  schools map
//
//  Created by Michael Baldock on 29/04/2019.
//  Copyright © 2019 Shed Light. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
  
  @IBOutlet var mapView: MKMapView!
  var userLocation: CLLocation?
  
  let schoolsData = [School(name: "North Haringey",
                            coordinate: CLLocationCoordinate2D(latitude: 51.58572, longitude: -0.10619),
                            intakeRadius: 424,
                            color: UIColor.red.withAlphaComponent(0.25)),
                     School(name: "Belmont Junior",
                            coordinate: CLLocationCoordinate2D(latitude: 51.59276, longitude: -0.09365),
                            intakeRadius: 456,
                            color: UIColor.blue.withAlphaComponent(0.25)),
                     School(name: "St Mary's",
                            coordinate: CLLocationCoordinate2D(latitude: 51.58596, longitude: -0.11523),
                            intakeRadius: 600,
                            color: UIColor.yellow.withAlphaComponent(0.25))]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.showsUserLocation = true
    
    for school in schoolsData {
      mapView.addAnnotation(school)
      mapView.addOverlay(school.intakeBoundary)
    }
    
    let mapSpanDiameter = 0.03
    let mapInitialCentre = CLLocationCoordinate2D(latitude: 51.5915,
                                                  longitude: -0.10631)
    let mapInitialSpan = MKCoordinateSpan(latitudeDelta: mapSpanDiameter,
                                          longitudeDelta: mapSpanDiameter)
    let mapRegion = MKCoordinateRegion(center:mapInitialCentre,
                                       span: mapInitialSpan)
    mapView.setRegion(mapRegion, animated: false)

    let location = "N8 0QJ"
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(location) { [weak self] placemarks, error in

      if let placemark = placemarks?.first,
         let location = placemark.location {

        guard let strongSelf = self else {return}
        let mark = MKPlacemark(placemark: placemark)

        var region = strongSelf.mapView.region
        region.center = location.coordinate
        strongSelf.mapView.setRegion(region, animated: true)
        strongSelf.mapView.addAnnotation(mark)
        strongSelf.userLocation = location
      }
    }
    
  }
}

extension ViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    
    if let intakeBoundary = overlay as? SchoolIntakeBoundary {
      let circleView = MKCircleRenderer(overlay: intakeBoundary)
      circleView.strokeColor = intakeBoundary.color
      circleView.fillColor = intakeBoundary.color
      circleView.lineWidth = 1
      return circleView
    } else if let userDistanceOverlay = overlay as? SchoolDistanceToUser {
      let circleView = MKCircleRenderer(overlay: userDistanceOverlay)
      circleView.strokeColor = UIColor.black.withAlphaComponent(0.1)
      circleView.fillColor = UIColor.black.withAlphaComponent(0.1)
      circleView.lineWidth = 1
      return circleView
    }
    
    return MKOverlayRenderer()
  }

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

    if let selectedSchool = view.annotation as? School {
      print("school: \(selectedSchool.name)")

      if let knownUserLocation = userLocation {
        let schoolLocation = CLLocation(latitude: selectedSchool.coordinate.latitude,
                                        longitude: selectedSchool.coordinate.longitude)
        let distance = schoolLocation.distance(from: knownUserLocation)
        print("distance from User: \(distance)m")

        mapView.addOverlay(SchoolDistanceToUser(center: selectedSchool.coordinate, radius: distance))
      }

    }

  }
  
}

class School: NSObject, MKAnnotation {
  
  var title: String? {
    get {
      return name
    }
  }
  let name: String
  let coordinate: CLLocationCoordinate2D
  let intakeBoundary: SchoolIntakeBoundary
  
  init(name:String,
       coordinate:CLLocationCoordinate2D,
       intakeRadius:CLLocationDistance,
       color:UIColor) {
    
    self.name = name
    self.coordinate = coordinate
    self.intakeBoundary = SchoolIntakeBoundary(center: coordinate, radius: intakeRadius)
    self.intakeBoundary.color = color
    
    super.init()
  }
}

class SchoolIntakeBoundary: MKCircle {
  var color: UIColor?
}

class SchoolDistanceToUser: MKCircle { }

