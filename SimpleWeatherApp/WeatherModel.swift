//
//  WeatherModel.swift
//  SimpleWeatherApp
//
//  Created by Cengizhan Tomak on 23.05.2023.
//

import Foundation

struct WeatherModel: Codable {
    let name: String?
    let main: Main?
    let wind: Wind?
    let weather: [Weather]?
    let coord: Coordinate?
}

struct Main: Codable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let humidity: Int?
    let sea_level: Int?
}

struct Wind: Codable {
    let speed: Double?
    let gust: Double?
}

struct Weather: Codable {
    let description: String?
}

struct Coordinate: Codable {
    let lon: Double?
    let lat: Double?
}
