//
//  WeatherModel.swift
//  Clima
//
//  Created by Başar Noyan on 26.07.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let temperature: Double
    let cityName: String
    
    var conditionName: String{
        switch conditionId {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                default:
                    return "cloud"
                }
    }
    
    var temperatureString: String{
        return String(format: "%0.1f", temperature) 
    }
    
   
}
