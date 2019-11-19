//
//  Favourites.swift
//  RATP
//
//  Created by jpo on 19/11/2019.
//  Copyright © 2019 jpo. All rights reserved.
//

import Foundation

class Favourites {
    static var lignes: [Ligne] = []
    
    
    static func addLigne(code: String, direction:String, station:String) {
        lignes.append(Ligne(code: code, direction: direction, station: station))
    }
    
    static func updateTimeOnLine(index: Int, time: String) {
        lignes[index].setNext(next: time)
    }
}

