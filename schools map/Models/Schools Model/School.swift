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
  let offersBasedOnDistance: Int
  let schoolIntakeYears: [SchoolIntakeYear]
  
  init(name:String,
       coordinate:CLLocationCoordinate2D,
       schoolIntakeYears:[SchoolIntakeYear],
       color:UIColor,
       offersBasedOnDistance:Int) {
    
    self.name = name
    self.centreCoordinate = coordinate
    
    var intakeYearsTemp = [SchoolIntakeYear]()
    for var intakeYear in schoolIntakeYears {
      intakeYear.boundary = SchoolIntakeBoundary(center: coordinate, radius: intakeYear.radius)
      intakeYear.boundary?.color = color
      intakeYearsTemp.append(intakeYear)
    }
    
    self.schoolIntakeYears = intakeYearsTemp
    
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

struct SchoolIntakeYear {
  let year: Int
  let radius: CLLocationDistance
  var boundary: SchoolIntakeBoundary?
}

//TODO: Remove #2
class SchoolIntakeBoundary2: MKCircle {
  var color: UIColor?
}

//TODO: Remove #2
class SchoolDistanceToUser2: MKCircle { }
