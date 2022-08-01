//
//  WeatherInformation.swift
//  Weather
//
//  Created by 이준혁 on 2022/07/31.
//

import Foundation

struct WeatherInformation: Codable {    // Codable -> 자신을 변환하거나 외부 표현으로 변환할 수 있다. (외부 표현이란 JSON같은 형식을 의미한다.)
    // Decodable, Encodable
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
