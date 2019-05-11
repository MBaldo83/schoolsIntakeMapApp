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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //declare link to view model
    schoolsMapViewModel.viewDelegate = self
    
    //initial view setup
    stackView.isHidden = true
    mapView.showsUserLocation = true
    
    //view model update
    updateView(animated: false)
    
    //Default user location for now, will be removed when provide UI to input postcode
    schoolsMapViewModel.setRegionWithPostcode("N8 0QJ")
  }
  
  private func updateView(animated:Bool) {
    
    mapView.setRegion(schoolsMapViewModel.mapRegion, animated: animated)
    
    if let userPlaceMark = schoolsMapViewModel.userLocationPlacemark {
      mapView.addAnnotation(userPlaceMark)
    }
  }
  
}

extension SchoolsMapViewController: ViewModelViewDelegateProtocol {
  
  func updateView() {
    updateView(animated: true)
  }
}
