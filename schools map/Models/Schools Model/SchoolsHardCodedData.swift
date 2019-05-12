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
  
  static func getHardCodedData() -> [School2] {
    
    return [School2(name: "North Haringey",
                   coordinate: CLLocationCoordinate2D(latitude: 51.58572, longitude: -0.10619),
                   schoolIntakeYears:[SchoolIntakeYear(year: 2019, radius: 200, boundary: nil),
                                      SchoolIntakeYear(year: 2018, radius: 150, boundary: nil)],
                   color: UIColor.red.withAlphaComponent(0.25),
                   offersBasedOnDistance:40),
            School2(name: "Belmont Junior",
                   coordinate: CLLocationCoordinate2D(latitude: 51.59276, longitude: -0.09365),
                   schoolIntakeYears:[SchoolIntakeYear(year: 2019, radius: 300, boundary: nil),
                                      SchoolIntakeYear(year: 2018, radius: 320, boundary: nil)],
                   color: UIColor.blue.withAlphaComponent(0.25),
                   offersBasedOnDistance:30),
            School2(name: "St Mary's",
                   coordinate: CLLocationCoordinate2D(latitude: 51.58596, longitude: -0.11523),
                   schoolIntakeYears:[SchoolIntakeYear(year: 2019, radius: 400, boundary: nil),
                                      SchoolIntakeYear(year: 2018, radius: 560, boundary: nil)],
                   color: UIColor.yellow.withAlphaComponent(0.25),
                   offersBasedOnDistance:40)]
  }
  
}
