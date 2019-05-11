//
//  SchoolsMapViewDelegate.swift
//  schools map
//
//  Created by Michael Baldock on 11/05/2019.
//  Copyright © 2019 Shed Light. All rights reserved.
//

import Foundation
import MapKit

protocol SchoolsMapViewParentDelegate: class {
  func mapView(_ mapView:MKMapView, didSelect school:School)
  var userLocation: CLLocation? { get }
}

class SchoolsMapViewDelegate: NSObject {
  
  let mapView: MKMapView
  weak var parentDelegate: SchoolsMapViewParentDelegate?
  
  init(mapView: MKMapView, delegate: SchoolsMapViewParentDelegate) {
    self.mapView = mapView
    self.parentDelegate = delegate
    
    super .init()
  }
  
  fileprivate func removeOverlaysDistanceOverlays() {
    
    for overlay in mapView.overlays {
      if overlay is SchoolDistanceToUser {
        mapView.removeOverlay(overlay)
      }
    }
  }
  
}

extension SchoolsMapViewDelegate: MKMapViewDelegate {
  
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
      
      removeOverlaysDistanceOverlays()
      
      if let knownUserLocation = parentDelegate?.userLocation {
        
        let schoolLocation = CLLocation(latitude: selectedSchool.coordinate.latitude,
                                        longitude: selectedSchool.coordinate.longitude)
        
        let distance = schoolLocation.distance(from: knownUserLocation)
        print("distance from User: \(distance)m")
        
        mapView.addOverlay(SchoolDistanceToUser(center: selectedSchool.coordinate, radius: distance))
        
      }
      
      parentDelegate?.mapView(mapView, didSelect: selectedSchool)
    }
  }
  
}
