//
//  School.swift
//  schools map
//
//  Created by Michael Baldock on 11/05/2019.
//  Copyright © 2019 Shed Light. All rights reserved.
//

import Foundation
import MapKit

//TODO: Remove #2
class School2: NSObject {
  
  let name: String
  let centreCoordinate: CLLocationCoordinate2D
  let intakeBoundary: SchoolIntakeBoundary
  let offersBasedOnDistance: Int
  
  init(name:String,
       coordinate:CLLocationCoordinate2D,
       intakeRadius:CLLocationDistance,
       color:UIColor,
       offersBasedOnDistance:Int) {
    
    self.name = name
    self.centreCoordinate = coordinate
    self.intakeBoundary = SchoolIntakeBoundary(center: coordinate, radius: intakeRadius)
    self.intakeBoundary.color = color
    self.offersBasedOnDistance = offersBasedOnDistance
    
    super.init()
  }
}

extension School2: MKAnnotation {
  
  var title: String? {
    get {
      return name
    }
  }
  
  var coordinate: CLLocationCoordinate2D {
    get {
      return centreCoordinate
    }
  }
  
}

//TODO: Remove #2
class SchoolIntakeBoundary2: MKCircle {
  var color: UIColor?
}

//TODO: Remove #2
class SchoolDistanceToUser2: MKCircle { }
