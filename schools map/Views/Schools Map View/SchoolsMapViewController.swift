//
//  SchoolsMapViewController.swift
//  schools map
//
//  Created by Michael Baldock on 11/05/2019.
//  Copyright © 2019 Shed Light. All rights reserved.
//

import Foundation
import MapKit

class SchoolsMapViewController: UIViewController {
  
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var distanceFromSchoolLabel: UILabel!
  @IBOutlet var intakeRadiusLabel: UILabel!
  @IBOutlet var offersBasedOnDistanceLabel: UILabel!
  @IBOutlet var estimatedQueuePositionLabel: UILabel!
  @IBOutlet var stackView: UIStackView!
  let schoolsMapViewModel: SchoolsMapViewModel = SchoolsMapViewModel()
  var schoolsMapViewDelegate: SchoolsMapViewDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //declare link to view model
    schoolsMapViewModel.viewDelegate = self
    
    //setup MKMapViewDelegate
    schoolsMapViewDelegate = SchoolsMapViewDelegate(mapView: mapView,
                                                    delegate: self)
    mapView.delegate = schoolsMapViewDelegate
    
    //initial view setup
    stackView.isHidden = true
    mapView.showsUserLocation = true
    
    //view model update
    updateView(animated: false)
    
    //Starting View Model functions
    //Default user location for now, will be removed when provide UI to input postcode
    schoolsMapViewModel.setRegionWithPostcode("N8 0QJ")
    schoolsMapViewModel.getSchools()
  }
  
  private func updateView(animated:Bool) {
    
    mapView.setRegion(schoolsMapViewModel.mapRegion, animated: animated)
    
    if let userPlaceMark = schoolsMapViewModel.userLocationPlacemark {
      mapView.addAnnotation(userPlaceMark)
    }
    
    for school in schoolsMapViewModel.schools {
      mapView.addAnnotation(school)
      mapView.addOverlay(school.intakeBoundary)
    }
  }
  
}

extension SchoolsMapViewController: ViewModelViewDelegateProtocol {
  
  func updateView() {
    updateView(animated: true)
  }
}

extension SchoolsMapViewController: SchoolsMapViewParentDelegate {
  
  var userLocation: CLLocation? {
    get {
      return schoolsMapViewModel.userLocation
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect school: School) {
    
    if let knownUserLocation = schoolsMapViewModel.userLocation {
      
      let schoolLocation = CLLocation(latitude: school.coordinate.latitude,
                                      longitude: school.coordinate.longitude)
      
      let distance = schoolLocation.distance(from: knownUserLocation)
      distanceFromSchoolLabel.text = "\(distance)m"
    }
    
    intakeRadiusLabel.text = "\(school.intakeBoundary.radius)m"
    offersBasedOnDistanceLabel.text = "\(school.offersBasedOnDistance)"
    
    //TODO
    estimatedQueuePositionLabel.text = "TODO..."
    stackView.isHidden = false
    
  }  
  
}
