import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var weatherViewModel = WeatherViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.placeholder = NSLocalizedString("Search", comment: "")
        let customCellNib = UINib(nibName: "WeatherTableViewCell", bundle: nil)
        tableView.register(customCellNib, forCellReuseIdentifier: "WeatherCell")
        
       
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        weatherViewModel.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    
    func configureCell(_ cell: TableViewCell, weather: WeatherModel) {
        cell.degreeLabel.text = weather.temperatureString
        cell.cellWeatherView.image = UIImage(systemName: weather.conditionName)
        cell.cityLabel.text = weather.cityName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "goToDetail" {
               if let indexPath = tableView.indexPathForSelectedRow {
                   let destinationVC = segue.destination as! DetailsViewController
                   let selectedWeather = weatherViewModel.weatherList[indexPath.row]
                   destinationVC.weather = selectedWeather
               }
           }
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "goToDetail", sender: self)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let buttonPressed = UIButton()
        searchButtonPressed(buttonPressed)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
            searchTextField.text = ""
        }
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherViewModel.addWeather(weather)
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func didUpdateWeather() {
        tableView.reloadData()
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! TableViewCell
        let weather = weatherViewModel.weatherList[indexPath.row]
        configureCell(cell, weather: weather)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        self.weatherViewModel.removeWeather(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
             cell.transform = CGAffineTransform(translationX: -tableView.bounds.width, y: 0)

             UIView.animate(
                 withDuration: 0.8,
                 delay: 0.05 * Double(indexPath.row),
                 usingSpringWithDamping: 0.8,
                 initialSpringVelocity: 0,
                 options: .curveEaseInOut,
                 animations: {
                     cell.alpha = 1
                     cell.transform = .identity
                 },
                 completion: nil
             )
    }
}

extension String{
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
