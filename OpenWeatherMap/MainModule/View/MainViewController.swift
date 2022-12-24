//
//  ViewController.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 07.12.2022.
//

import UIKit
import Alamofire


class MainViewController: UIViewController, MainViewProtocol {
    
    var coordinates: [String]? = []
        
    var presenter: MainViewPresenterProtocol?
    let navBar = UINavigationController()
    var isSearch: Bool = false
    var filteredTableData: [String] = []
    var weatherLocale: WeatherLocale?
    var latitude: String?
    var longitude: String?
    var coordinatesOutput: String?
    
    private lazy var citiesTableView: UITableView = {
        let tableview = UITableView(frame: CGRectZero, style: .grouped)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.delegate = self
        tableview.showsVerticalScrollIndicator = false
        tableview.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.identifier
        )
        tableview.separatorStyle = .none
        return tableview
    }()
    
    private lazy var titleWeather: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Weather"
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.backgroundColor = .clear
        return searchBar
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activitiIndicator = UIActivityIndicatorView()
        activitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        activitiIndicator.color = .white
        activitiIndicator.style = .large
        return activitiIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitle()
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
        deleteTextBackInNavigation()
        presenter?.getCoordinates()
        citiesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        citiesTableView.reloadData()
    }
    
    func deleteTextBackInNavigation() {
        let backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .white
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func setupTableView() {
        view.addSubview(citiesTableView)
        citiesTableView.rowHeight = 83
        citiesTableView.topAnchor.constraint(
            equalTo: titleWeather.bottomAnchor).isActive = true
        citiesTableView.leftAnchor.constraint(
            equalTo: view.leftAnchor).isActive = true
        citiesTableView.rightAnchor.constraint(
            equalTo: view.rightAnchor).isActive = true
        citiesTableView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupTitle() {
        view.addSubview(titleWeather)
        titleWeather.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleWeather.leftAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        titleWeather.rightAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    func setupActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    func setupSearchBar() {
        citiesTableView.tableHeaderView = searchBar
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherData = presenter?.weatherData?.city[indexPath.row]
        let detailedViewController = ModuleBuilder.createDetailedModule(weatherData: weatherData)
        navigationController?.pushViewController(detailedViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearch) {
            return filteredTableData.count
        } else {
            let cities = presenter?.weatherData?.city.count
            return cities ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesCell", for: indexPath) as? CustomTableViewCell {
            
            if (isSearch) {
                cell.city = filteredTableData[indexPath.row]
                cell.temperature = presenter?.weatherData?.city[indexPath.row].tempC
                cell.setSecondLabel()
                return cell
            } else if indexPath == [0, 0] {
                cell.lastUpdate = presenter?.weatherDataWithLocation?.city[0].city // weatherData?.city[indexPath.row].city
                cell.city = "My Location"
                
                cell.temperature = presenter?
                    .weatherDataWithLocation?
                    .city[indexPath.row]
                    .tempC
                cell.imageNameFromData = presenter?
                    .weatherDataWithLocation?
                    .city[indexPath.row]
                    .conditionCode
                cell.setSecondLabel()
                return cell
            } else {
                let time = presenter?
                    .weatherData?
                    .city[indexPath.row]
                    .lastUpdated
                cell.lastUpdate = self.timeFormatter(time)
                
                cell.city = presenter?
                    .weatherData?
                    .city[indexPath.row]
                    .city
                cell.temperature = presenter?
                    .weatherData?
                    .city[indexPath.row]
                    .tempC
                cell.imageNameFromData = presenter?
                    .weatherData?
                    .city[indexPath.row]
                    .conditionCode
                cell.setSecondLabel()
                return cell
            }
        }
        fatalError("could not dequeueReusableCell")
    }
}

extension MainViewController: UISearchBarDelegate {
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
           isSearch = true
        print("searchBarTextDidBeginEditing")
    }
       
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           isSearch = false
        print("searchBarTextDidEndEditing")
    }
       
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           isSearch = false
        print("searchBarCancelButtonClicked")
    }
       
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           isSearch = false
        print("searchBarSearchButtonClicked")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let tableData = presenter?.getCities() ?? []
        
        if searchText.count == 0 {
            isSearch = false
            self.citiesTableView.reloadData()
        } else {
            filteredTableData = tableData.filter({ (text) -> Bool in
                let tmp: NSString = text as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            
            if (filteredTableData.count == 0) {
                isSearch = false
            } else {
                isSearch = true
            }
            self.citiesTableView.reloadData()
        }
    }
}

extension MainViewController {
    func success() {
        DispatchQueue.main.async {
            self.citiesTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func getCoordinates() -> [String] {
        coordinates?.append(latitude ?? "")
        coordinates?.append(longitude ?? "")
        return coordinates ?? []
    }
}

extension MainViewController {
    func timeFormatter(_ timeResult: Int?) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeResult ?? 0))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}

extension UIWindow {
    func initTheme() {
        overrideUserInterfaceStyle = Theme.current.userInterfaceStyle
    }
}
