//
//  DetailedViewController.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 13.12.2022.
//

import UIKit

let reuseIdOne = String(describing: HeaderCollectionViewCell.self)
let reuseIdTwo = String(describing: HourlyForecastCollectionViewCell.self)
let reuseIdThree = String(describing: WeeklyForecastCollectionViewCell.self)
let reuseIdFour = String(describing: TextInfoCollectionViewCell.self)
let reuseIdFive = String(describing: AddtionalInfoCollectionViewCell.self)


class DetailedViewController: UIViewController, DetailedViewProtocol, UICollectionViewDelegate, UIScrollViewDelegate {
    
    enum Section: Int, CaseIterable {
        case hourlyForecast
        case weeklyForecast
        case additionalInfo
        case textInfo
    }
    
    let nameOfProperty = [
        "SUNRISE",
        "SUNSET",
        "CHANCE OF RAIN",
        "HUMIDITY",
        "WIND",
        "FEELS LIKE",
        "PRECIPITATION",
        "PRESSURE",
        "VISIBILITY",
        "UV INDEX"
    ]
    
    let days = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ]
    
    var presenter: DetailedViewPresenterProtocol?
    var weatherDataCity: City?
    
    var hourlyForecastDataTimeEpoch: [Int] = []
    var hourlyForecastDataTemp: [Double] = []
    var hourlyForecastDataCode: [Int] = []

    var weeklyForecastDate: [String] = []
    var weeklyForecastHumidity: [Double] = []
    var weeklyForecastHighTemp: [Double] = []
    var weeklyForecastLowTemp: [Double] = []
    var weeklyForecastCondCode: [Int] = []

    var additionalInfoData: [String] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    let viewHeader = HeaderCollectionViewCell()
    lazy var heightHead = viewHeader.heightAnchor.constraint(equalToConstant: 300)
    let scrollView = UIScrollView()
    
    private lazy var hourlyForecast: ClosedRange<Int> = (1)...(24)
    private lazy var weeklyForecast: ClosedRange<Int> = (hourlyForecast.upperBound + 1)...(hourlyForecast.upperBound + 3)
    private lazy var textInfo: ClosedRange<Int> = (weeklyForecast.upperBound + 1)...(weeklyForecast.upperBound + 1)
    private lazy var additionalInfo: ClosedRange<Int> = (textInfo.upperBound + 1)...(textInfo.upperBound + 10)
    
    private var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setWeatherData()
        configureHierarchy()
        configureDataSource()
        weatherDataToAdditionalInfo()
        weatherDataToHourlyForecast()
        weatherDataToWeeklyForecast()
    }
    
    func setWeatherData(weatherData: City?) {
        weatherDataCity = weatherData
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section = self.layoutSection(for: sectionKind, layoutEnvironment: layoutEnvironment)
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16.0
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor(red: 63/255, green: 132/255, blue: 221/255, alpha: 1)
        collectionView.backgroundColor = .clear
        
        collectionView.register(
            HourlyForecastCollectionViewCell.self,
            forCellWithReuseIdentifier: reuseIdTwo
        )
        collectionView.register(
            WeeklyForecastCollectionViewCell.self,
            forCellWithReuseIdentifier: reuseIdThree
        )
        collectionView.register(
            TextInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: reuseIdFour
        )
        collectionView.register(
            AddtionalInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: reuseIdFive
        )

        setupScrollView()
        setupViewHeader()
        
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func setupViewHeader() {
        weatherDataToFirstBlock(viewHeader)

        viewHeader.translatesAutoresizingMaskIntoConstraints = false
        viewHeader.topAnchor.constraint(
            equalTo: view.topAnchor).isActive = true
        viewHeader.leftAnchor.constraint(
            equalTo: view.leftAnchor).isActive = true
        viewHeader.rightAnchor.constraint(
            equalTo: view.rightAnchor).isActive = true
        
        viewHeader.city = weatherDataCity?.city
        viewHeader.lowTemp = weatherDataCity?.lTemp
        viewHeader.highTemp = weatherDataCity?.hTemp
        viewHeader.temperature = weatherDataCity?.tempC
        viewHeader.text = weatherDataCity?.text
                
        viewHeader.setupHeader()
        heightHead.isActive = true
        viewHeader.backgroundColor = UIColor(red: 63/255, green: 132/255, blue: 221/255, alpha: 1)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(
            equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(
            equalTo: view.rightAnchor).isActive = true
        collectionView.contentInset.top = 250
        scrollView.addSubview(viewHeader)
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerViewInitialY = self.viewHeader.frame.origin.y
        scrollView.addSubview(self.viewHeader)
        scrollView.delegate = self
        var headerFrame = viewHeader.frame
        headerFrame.origin.y = CGFloat(max(headerViewInitialY, scrollView.contentOffset.y))
        viewHeader.frame = headerFrame
        let yHeader = scrollView.contentOffset.y + 400
        self.heightHead.constant = 150
        
        HeaderCollectionViewCell.animate(withDuration: 0.25) {
            if yHeader > 100 && yHeader < 130 {
                self.viewHeader.highTempLabel.isHidden = true
                self.viewHeader.lowTempLabel.isHidden = true
                self.reloadUI()
            } else if yHeader > 130 && yHeader < 150 {
                self.viewHeader.weatherLabel.isHidden = true
                self.reloadUI()
            } else if yHeader > 160 && yHeader < 180 {
                self.viewHeader.tempLabel.isHidden = true
                self.viewHeader.tempAndWeatherSecondLabel.isHidden = false
                self.viewHeader.setupSecondHeader()
                self.reloadUI()
            } else if yHeader < 100 && yHeader > 40 {
                // move down
                self.viewHeader.cityLabel.isHidden = false
                self.viewHeader.highTempLabel.isHidden = false
                self.viewHeader.lowTempLabel.isHidden = false
                self.viewHeader.weatherLabel.isHidden = false
                self.viewHeader.tempLabel.isHidden = false
                self.viewHeader.tempAndWeatherSecondLabel.isHidden = true
                
                self.viewHeader.setupHeader()
                self.reloadUI()
            }
            self.reloadUI()
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    private func reloadUI() {
        self.viewHeader.setNeedsLayout()
        self.viewHeader.layoutIfNeeded()
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            if self.hourlyForecast ~= identifier {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdTwo, for: indexPath) as? HourlyForecastCollectionViewCell else { fatalError("Cannot create the cell") }
                
                let time = self.timeFormatter(self.hourlyForecastDataTimeEpoch[indexPath.row])
                cell.timeEpoch = time
                let temp = String(self.hourlyForecastDataTemp[indexPath.row])
                cell.temp = temp
                let code = self.hourlyForecastDataCode[indexPath.row]
                cell.imageNameFromData = code
                cell.setupHourlyForecast()
                return cell
            }
            
            if self.weeklyForecast ~= identifier {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdThree, for: indexPath) as? WeeklyForecastCollectionViewCell else { fatalError("Cannot create the cell") }
                cell.day = self.weeklyForecastDate[indexPath.row]
                cell.maxTemp = String(self.weeklyForecastHighTemp[indexPath.row])
                cell.minTemp = String(self.weeklyForecastLowTemp[indexPath.row])
                cell.humidity = String(self.weeklyForecastHumidity[indexPath.row])
                let code = self.weeklyForecastCondCode[indexPath.row]
                cell.imageNameFromData = code
                cell.setupWeeklyForecast()
                return cell
            }
            
            if self.textInfo ~= identifier {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdFour, for: indexPath) as? TextInfoCollectionViewCell else { fatalError("Cannot create the cell") }
                cell.text = self.weatherDataCity?.text
                cell.setupTextInfo()
                return cell
            }
            
            if self.additionalInfo ~= identifier {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdFive, for: indexPath) as? AddtionalInfoCollectionViewCell else { fatalError("Cannot create the cell") }
                cell.nameOfProperty = self.nameOfProperty[indexPath.row]
                cell.valueOfProperty = self.additionalInfoData[indexPath.row]
                cell.setupAddtionalInfo()
                return cell
            }
            
            fatalError("Cannot create the cell")
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        let sections: [Section] = [.hourlyForecast, .weeklyForecast, .textInfo, .additionalInfo]
        
        snapshot.appendSections([sections[0]])
        snapshot.appendItems(Array(hourlyForecast))
        snapshot.appendSections([sections[1]])
        snapshot.appendItems(Array(weeklyForecast))
        snapshot.appendSections([sections[2]])
        snapshot.appendItems(Array(textInfo))
        snapshot.appendSections([sections[3]])
        snapshot.appendItems(Array(additionalInfo))
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func layoutSection(for section: Section, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch section {
        case .hourlyForecast:
            return hourlyForecastSection()
        case .weeklyForecast:
            return weeklyForecastSection()
        case .textInfo:
            return textInfoSection()
        case .additionalInfo:
            return additionalInfoSection()
        }
    }
    
    private func hourlyForecastSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0/3.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.interItemSpacing = .fixed(1.0)
        
        let rootGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/3.0), heightDimension: .absolute(125))
        let rootGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rootGroupSize, subitems: [group])
        let section = NSCollectionLayoutSection(group: rootGroup)
        section.interGroupSpacing = 1
        section.orthogonalScrollingBehavior = .groupPaging
    
        return section
    }
    
    private func weeklyForecastSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func textInfoSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        
        return section
    }
    
    private func additionalInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = .init(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        return section
    }
}

extension DetailedViewController {
    func weatherDataToFirstBlock(_ viewHeader: HeaderCollectionViewCell) {
        viewHeader.city = weatherDataCity?.city
        viewHeader.lowTemp = weatherDataCity?.lTemp
        viewHeader.highTemp = weatherDataCity?.hTemp
        viewHeader.temperature = weatherDataCity?.tempC
    }
    
    func weatherDataToHourlyForecast() {
        for i in 0...23 {
            let timeEpoch = weatherDataCity?.forecastday?[i].timeEpoch
            hourlyForecastDataTimeEpoch.append(timeEpoch ?? 0)
        }
        
        for i in 0...23 {
            let temp = (weatherDataCity?.forecastday?[i].avgtempC)
            hourlyForecastDataTemp.append(temp ?? 0)
        }
        
        for i in 0...23 {
            let code = (weatherDataCity?.forecastday?[i].conditionCode)
            hourlyForecastDataCode.append(code ?? 0)
        }
    }
    
    func weatherDataToWeeklyForecast() {
        
        for i in 0...2 {
            let weekday = getDayNameBy(
                stringDate:
                    weatherDataCity?
                    .forecastWeekly?[i]
                    .date ?? ""
            )

            weeklyForecastDate.append(weekday)
            
            weeklyForecastHighTemp.append(
                weatherDataCity?
                    .forecastWeekly?[i]
                    .maxtempC ?? 0
            )
            weeklyForecastLowTemp.append(
                weatherDataCity?
                    .forecastWeekly?[i]
                    .mintempC ?? 0
            )
            weeklyForecastHumidity.append(
                weatherDataCity?
                    .forecastWeekly?[i]
                    .avghumidity ?? 0
            )
            weeklyForecastCondCode.append(
                weatherDataCity?
                    .forecastWeekly?[i]
                    .conditionCode ?? 0
            )
        }
    }
    
    func weatherDataToAdditionalInfo() {
        additionalInfoData.append(weatherDataCity?.sunrise ?? "")
        additionalInfoData.append(weatherDataCity?.sunset ?? "")
        additionalInfoData.append(String(weatherDataCity?.chanceOfRain ?? 0) + " %")
        additionalInfoData.append(String(weatherDataCity?.humidity ?? 0) + " %")
        additionalInfoData.append(String(weatherDataCity?.windKph ?? 0) + " kPh")
        additionalInfoData.append(String(weatherDataCity?.feelslikeC ?? 0) + " º")
        additionalInfoData.append(String(weatherDataCity?.totalprecipMm ?? 0) + " mm")
        additionalInfoData.append(String(weatherDataCity?.pressureMB ?? 0) + " MB")
        additionalInfoData.append(String(weatherDataCity?.visKM ?? 0) + " km")
        additionalInfoData.append(String(weatherDataCity?.uv ?? 0))
    }
    
    func timeFormatter(_ timeResult: Int?) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeResult ?? 0))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.setLocalizedDateFormatFromTemplate("h")
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    func getDayNameBy(stringDate: String) -> String
        {
            let df  = DateFormatter()
            df.dateFormat = "YYYY-MM-dd"
            df.locale = Locale(identifier: "en_us")

            let date = df.date(from: stringDate)!
            df.dateFormat = "EEEE"
            return df.string(from: date);
        }
}
