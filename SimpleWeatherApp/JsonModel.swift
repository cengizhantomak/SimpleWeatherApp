//
//  JsonModel.swift
//  SimpleWeatherApp
//
//  Created by Cengizhan Tomak on 23.05.2023.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord: Coord
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
