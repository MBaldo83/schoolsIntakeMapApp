//
//  SchoolsHardCodedData.swift
//  schools map
//
//  Created by Michael Baldock on 11/05/2019.
//  Copyright © 2019 Shed Light. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension SchoolsRepository {
  
  static func getHardCodedData() -> [School] {
    
    return [School(name: "North Haringey",
                   coordinate: CLLocationCoordinate2D(latitude: 51.58572, longitude: -0.10619),
                   intakeRadius: 424,
                   color: UIColor.red.withAlphaComponent(0.25),
                   offersBasedOnDistance:40),
            School(name: "Belmont Junior",
                   coordinate: CLLocationCoordinate2D(latitude: 51.59276, longitude: -0.09365),
                   intakeRadius: 456,
                   color: UIColor.blue.withAlphaComponent(0.25),
                   offersBasedOnDistance:30),
            School(name: "St Mary's",
                   coordinate: CLLocationCoordinate2D(latitude: 51.58596, longitude: -0.11523),
                   intakeRadius: 600,
                   color: UIColor.yellow.withAlphaComponent(0.25),
                   offersBasedOnDistance:40)]
  }
  
}
