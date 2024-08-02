import UIKit

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    var weather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        line.transform = CGAffineTransformMakeRotation(0.784)
        
        if let weather = weather {
            updateUI(with: weather)
        }
    }
    
    func updateUI(with weather: WeatherModel) {
        conditionImageView.image = UIImage(systemName: weather.conditionName)
        temperatureLabel.text = weather.temperatureString
        cityLabel.text = weather.cityName
        // Diğer label'lar için API'dan çekilen detaylı verileri ekleyin
        tempMinLabel.text = "\(weather.tempMinString)"
        tempMaxLabel.text = "\(weather.tempMaxString)"
        feelsLikeLabel.text = "\(weather.feelsLikeString)"
        humidityLabel.text = "\(weather.humidityString)%"
    }
}
    
    

   





