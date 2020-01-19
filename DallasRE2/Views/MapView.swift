//
//  MapView.swift
//  LunchTyme
//
//  Created by Yu Zhang on 8/1/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//

import MapKit

class MapView: MKMapView, MKMapViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 200)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

