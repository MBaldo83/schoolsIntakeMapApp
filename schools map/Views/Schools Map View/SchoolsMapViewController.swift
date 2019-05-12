//
//  SchoolsMapViewController.swift
//  schools map
//
//  Created by Michael Baldock on 11/05/2019.
//  Copyright © 2019 Shed Light. All rights reserved.
//

import Foundation
import MapKit

//This is the paret view controller for the mapview to display schools and intake boundaries
// and all the other views that sit under this
class SchoolsMapViewController: UIViewController {
  
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var distanceFromSchoolLabel: UILabel!
  @IBOutlet var intakeRadiusLabel: UILabel!
  @IBOutlet var offersBasedOnDistanceLabel: UILabel!
  @IBOutlet var estimatedQueuePositionLabel: UILabel!
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var yearLabel: UILabel!
  @IBOutlet var stepper: UIStepper!
  
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
    schoolsMapViewModel.yearBeingViewed = SchoolsMapViewModel.defaultYear()
  
    //Default user location for now, will be removed when provide UI to input postcode
    schoolsMapViewModel.requestMapRegionWith(postcode: SchoolsMapViewModel.defaultUserPostode())
    schoolsMapViewModel.requestSchools()
  }
  
  private func updateView(animated:Bool) {
    
    mapView.setRegion(schoolsMapViewModel.mapRegion, animated: animated)
    
    if let year = schoolsMapViewModel.yearBeingViewed {
      yearLabel.text = "\(year)"
    }
    
    if let userPlaceMark = schoolsMapViewModel.userLocationPlacemark {
      mapView.addAnnotation(userPlaceMark)
    }
    
    for school in schoolsMapViewModel.schools {
      mapView.addAnnotation(school)
    }
    
    for intakeBoundary in schoolsMapViewModel.intakeBoundariesForCurrentYear {
      mapView.addOverlay(intakeBoundary)
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
  
  func mapView(_ mapView: MKMapView, didSelect school: School2) {
    
    if let knownUserLocation = schoolsMapViewModel.userLocation {
      
      let schoolLocation = CLLocation(latitude: school.coordinate.latitude,
                                      longitude: school.coordinate.longitude)
      
      let distance = schoolLocation.distance(from: knownUserLocation)
      distanceFromSchoolLabel.text = "\(distance)m"
    }
    
//    intakeRadiusLabel.text = "\(school.intakeBoundary.radius)m"
    offersBasedOnDistanceLabel.text = "\(school.offersBasedOnDistance)"
    
    //TODO
    estimatedQueuePositionLabel.text = "TODO..."
    stackView.isHidden = false
    
  }  
  
}
