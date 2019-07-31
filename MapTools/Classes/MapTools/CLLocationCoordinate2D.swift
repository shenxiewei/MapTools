//
//  CLLocationCoordinate2D.swift
//  SodaMove
//
//  Created by 汤世昭 on 2018/2/2.
//  Copyright © 2018年 汤世昭. All rights reserved.
//

import Foundation

typealias Coordinate = CLLocationCoordinate2D

extension Coordinate {
    init(lat: Double, long: Double) {
        self.init()
        self.latitude = lat
        self.longitude = long
    }
    
    /// 地图上亮点之间的直线距离（单位：米）
    func distance(from anotherCoordinate: Coordinate) -> Double {
        let aLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let bLocation = CLLocation(latitude: anotherCoordinate.latitude, longitude: anotherCoordinate.longitude)
        let distance: CLLocationDistance = aLocation.distance(from: bLocation)
        return distance
    }
    
    static func == (left: Coordinate, right: Coordinate) -> Bool {
        return (left.latitude == right.latitude) && (left.longitude == right.longitude)
    }
    
    static func != (left: Coordinate, right: Coordinate) -> Bool {
        return !(left == right)
    }
}
