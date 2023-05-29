//
//  CitySelectionVC.swift
//  SimpleWeatherApp
//
//  Created by Kerem Tuna Tomak on 29.05.2023.
//

import UIKit

class CitySelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var citiesTableView: UITableView!
    
    var cities = [City]()
    var allCities = [City]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        
        allCities = loadJson(filename: "city.list") ?? [City]()
        cities = allCities
    }
    
    // MARK: - JSON Load
    func loadJson(filename fileName: String) -> [City]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([City].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = citiesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel?.text = city.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        let weatherVC = self.tabBarController?.viewControllers?[0] as! WeatherVC
        weatherVC.cityId = city.id
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            cities = allCities
        } else {
            cities = allCities.filter({ city in
                city.name.localizedStandardContains(searchText)
            })
        }
        citiesTableView.reloadData()
    }
}
