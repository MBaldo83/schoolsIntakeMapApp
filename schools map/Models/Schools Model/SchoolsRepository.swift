//
//  SchoolsRepository.swift
//  schools map
//
//  Created by Michael Baldock on 11/05/2019.
//  Copyright © 2019 Shed Light. All rights reserved.
//

import Foundation

class SchoolsRepository {
  
  func getSchools () -> [School2] {
    return SchoolsRepository.getHardCodedData()
  }
}
