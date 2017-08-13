//
//  PassengerAnnotation.swift
//  Thumbup
//
//  Created by Ed McCormic on 7/20/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import Foundation
import MapKit

class PassengerAnnotation: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, key: String){
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    
    
}
