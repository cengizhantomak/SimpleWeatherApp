//
//  WeatherVC.swift
//  SimpleWeatherApp
//
//  Created by Cengizhan Tomak on 23.05.2023.
//

import UIKit

class WeatherVC: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var maxMinLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var seaLevelLabel: UILabel!
    @IBOutlet weak var coordLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var coordView: UIView!
    @IBOutlet weak var seaLevelView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    
    var cityId: Int? {
        didSet {
            if let cityId = cityId {
                UserDefaults.standard.set(cityId, forKey: "cityId")
            }
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedCityId = UserDefaults.standard.object(forKey: "cityId") as? Int {
            fetchWeatherData(for: savedCityId)
        } else {
            cityId = 745044 // Istanbul
            fetchWeatherData(for: cityId!)
        }
    }
    
    // MARK: - API Call
    func fetchWeatherData(for cityId: Int) {
        let apiKey = "032819d54ac180c3b112ec2f3c8ff595"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=\(apiKey)&units=metric"
        print(urlString)
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let weatherData = try? JSONDecoder().decode(WeatherModel.self, from: data) else {
                print("Error decoding JSON")
                return
            }
            
            DispatchQueue.main.async {
                self?.updateUI(with: weatherData)
            }
        }.resume()
    }
    
    // MARK: - Update UI
    func updateUI(with weatherData: WeatherModel) {
        if let name = weatherData.name {
            self.cityNameLabel.text = name
        } else {
            self.cityNameLabel.text = "Unknown"
        }
        if let temp = weatherData.main?.temp {
            self.currentLabel.text = "Current: \(Int(temp))°C"
        }
        if let feelsLike = weatherData.main?.feels_like {
            self.feelsLikeLabel.text = "Feels Like: \(Int(feelsLike))°C"
        }
        if let tempMax = weatherData.main?.temp_max, let tempMin = weatherData.main?.temp_min {
            self.maxMinLabel.text = "H: \(Int(tempMax))°C  L: \(Int(tempMin))°C"
        }
        if let humidity = weatherData.main?.humidity {
            self.humidityLabel.text = "% \(humidity)"
        }
        if let windSpeed = weatherData.wind?.speed {
            self.windLabel.text = "Speed: \(Int(windSpeed)) km/h"
        }
        if let gustSpeed = weatherData.wind?.gust {
            self.windLabel.text! += "\nGust: \(Int(gustSpeed)) km/h"
        }
        if let seaLevel = weatherData.main?.sea_level {
            self.seaLevelLabel.text = String(seaLevel)
        }
        if let latitude = weatherData.coord?.lat, let longitude = weatherData.coord?.lon {
            self.coordLabel.text = "Latitude: \(Int(latitude))\nLongitude: \(Int(longitude))"
        }
        if let description = weatherData.weather?.first?.description {
            self.descriptionLabel.text = description
        }
    }
    
    // MARK: - Setup UI
    func setupView() {
        let views: [UIView] = [humidityView, windView, coordView, seaLevelView]
        for view in views {
            view.layer.cornerRadius = 15
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor.black.cgColor
        }
    }
}
