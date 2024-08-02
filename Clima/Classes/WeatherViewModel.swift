import Foundation

protocol WeatherViewModelDelegate: AnyObject {
    func didUpdateWeather()
}

class WeatherViewModel {
    var weatherList: [WeatherModel] = [] {
            didSet {
                saveWeatherList()
                delegate?.didUpdateWeather()
            }
        }
    weak var delegate: WeatherViewModelDelegate?
    
    private let weatherListKey = "weatherList"
       
       init() {
           loadWeatherList()
       }
       
       func addWeather(_ weather: WeatherModel) {
           if let existingIndex = weatherList.firstIndex(where: { $0.cityName == weather.cityName }) {
               weatherList.remove(at: existingIndex)
           }
           weatherList.insert(weather, at: 0)
       }
    
        func removeWeather(at index: Int) {
           weatherList.remove(at: index)
           delegate?.didUpdateWeather()
        }
       
       private func saveWeatherList() {
           let encoder = JSONEncoder()
           if let encoded = try? encoder.encode(weatherList) {
               UserDefaults.standard.set(encoded, forKey: weatherListKey)
           }
       }
       
       private func loadWeatherList() {
           if let savedWeatherList = UserDefaults.standard.object(forKey: weatherListKey) as? Data {
               let decoder = JSONDecoder()
               if let loadedWeatherList = try? decoder.decode([WeatherModel].self, from: savedWeatherList) {
                   weatherList = loadedWeatherList
               }
           }
       }
   }


