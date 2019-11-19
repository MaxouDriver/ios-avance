//
//  Ligne.swift
//  RATP
//
//  Created by jpo on 19/11/2019.
//  Copyright © 2019 jpo. All rights reserved.
//

import Foundation

struct Ligne {
    let code, direction, station: String
    var next: String
    init(code: String, direction:String, station:String) {
        self.code = code
        self.direction = direction
        self.station = station
        self.next = "undefined"
    }
    
    mutating func setNext(next: String) {
        self.next = next
    }
}
