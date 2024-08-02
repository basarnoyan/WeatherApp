import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let weatherListKey = "weatherList"
    
    func saveWeatherList(_ weatherList: [WeatherModel]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherList) {
            UserDefaults.standard.set(encoded, forKey: weatherListKey)
        }
    }
    
    func loadWeatherList() -> [WeatherModel] {
        if let savedWeatherList = UserDefaults.standard.object(forKey: weatherListKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedWeatherList = try? decoder.decode([WeatherModel].self, from: savedWeatherList) {
                return loadedWeatherList
            }
        }
        return []
    }
    
    func removeWeather(for cityName: String) {
        var weatherList = loadWeatherList()
        weatherList.removeAll { $0.cityName == cityName }
        saveWeatherList(weatherList)
    }
}
