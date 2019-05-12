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
  
  weak var viewDelegate: ViewModelViewDelegateProtocol?
  private var schoolsRepository = SchoolsRepository()
  private(set) var userLocation: CLLocation?
  
  init() {
    
    self.mapRegion = SchoolsMapViewModel.defaultRegion()
  }
  //MARK: Properties bound to views
  // Getting value has no side affect
  // Setting value has side affect of updating view delegate
  var mapRegion: MKCoordinateRegion {
    didSet{
      viewDelegate?.updateView()
    }
  }
  
  var userLocationPlacemark: MKPlacemark? {
    didSet{
      viewDelegate?.updateView()
    }
  }
  
  var schools: [School2] = [School2]() {
    didSet {
      viewDelegate?.updateView()
    }
  }
  
  var yearBeingViewed: Int? {
    didSet {
      viewDelegate?.updateView()
    }
  }
  
  //MARK: Functions to get data
  // No Side affect of getting data
  var intakeBoundariesForCurrentYear: [SchoolIntakeBoundary] {
    get {
      guard let currentYear = yearBeingViewed else {
        return [SchoolIntakeBoundary]()
      }
      
      let intakeYearsMatchingCurrentYear = schools.flatMap({$0.schoolIntakeYears.filter({$0.year == currentYear})})
      print(intakeYearsMatchingCurrentYear)
      return intakeYearsMatchingCurrentYear.compactMap({$0.boundary})
    }
  }
  
  //MARK: Functions to start data request
  // Has side affect of setting data and updating view
  func requestSchools() {
    schools = schoolsRepository.getSchools()
  }
  
  func requestMapRegionWith(postcode:String) {
    
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(postcode) { [weak self] placemarks, error in
      
      if let placemark = placemarks?.first,
         let location = placemark.location,
         let strongSelf = self {
        
        strongSelf.mapRegion.center = location.coordinate
        strongSelf.userLocation = location
        strongSelf.userLocationPlacemark = MKPlacemark(placemark: placemark)
        
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
  
  static func defaultYear () -> Int {
    
    //TODO Fix this to use calendar when you have some internet!
    return 2019
  }
  
  static func defaultUserPostode () -> String {
    return "N8 0QJ"
  }
  
}
