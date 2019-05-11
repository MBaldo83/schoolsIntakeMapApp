//
//  SchoolsMapViewModel.swift
//  schools map
//
//  Created by Michael Baldock on 11/05/2019.
//  Copyright © 2019 Shed Light. All rights reserved.
//

import Foundation
import MapKit

protocol ViewModelViewDelegateProtocol: class {
  func updateView()
}

class SchoolsMapViewModel {
  
  var mapRegion: MKCoordinateRegion
  weak var viewDelegate: ViewModelViewDelegateProtocol?
  var userLocationPlacemark: MKPlacemark?
  var userLocation: CLLocation?
  var schools: [School] = [School]()
  var schoolsRepository = SchoolsRepository()
  
  init() {
    
    self.mapRegion = SchoolsMapViewModel.defaultRegion()
  }
  
  func getSchools() {
    schools = schoolsRepository.getSchools()
    viewDelegate?.updateView()
  }
  
  func setRegionWithPostcode(_ postcode:String) {
    
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(postcode) { [weak self] placemarks, error in
      
      if let placemark = placemarks?.first,
         let location = placemark.location,
         let strongSelf = self {
        
        strongSelf.mapRegion.center = location.coordinate
        strongSelf.userLocationPlacemark = MKPlacemark(placemark: placemark)
        strongSelf.userLocation = location
        
        strongSelf.viewDelegate?.updateView()
      }
    }
  }
  
}

// Default Static Methods to define initial state
extension SchoolsMapViewModel {
  
  static let initialMapCentreLatitude: Double = 51.5915
  static let initialMapCentreLongitude: Double = -0.10631
  static let initialMapSpanDiameter: Double = 0.03
  
  private static func defaultRegion () -> MKCoordinateRegion {
    
    let mapInitialCentre = CLLocationCoordinate2D(latitude: initialMapCentreLatitude,
                                                  longitude: initialMapCentreLongitude)
    let mapInitialSpan = MKCoordinateSpan(latitudeDelta: initialMapSpanDiameter,
                                          longitudeDelta: initialMapSpanDiameter)
    return MKCoordinateRegion(center:mapInitialCentre,
                              span: mapInitialSpan)
  }
}
