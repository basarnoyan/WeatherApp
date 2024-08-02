

import Foundation

struct WeatherModel: Codable{
    let conditionId: Int
    let temperature: Double
    let cityName: String
    let tempMax: Double
    let tempMin: Double
    let feelsLike: Double
    let humidity: Int
    
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
        return String(Int(temperature))
    }
    
    var tempMaxString: String{
        return String(Int(tempMax))
    }
    
    var tempMinString: String{
        return String(Int(tempMin))
    }
    
    var feelsLikeString: String{
        return String(Int(feelsLike))
    }
    
    var humidityString: String{
        return String(Int(humidity))
    }
    
   
}
