//
//  Animal.swift
//  AnimalSpotter
//
//  Created by Jessie Ann Griffin on 9/11/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Animal: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let timeSeen: Date // number of second since reference date Jan 1, 2001
    let description: String
    let imageURL: String
}
