//
//  WeeklyForecastCollectionViewCell.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 15.12.2022.
//

import UIKit

class WeeklyForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "weeklyForecast"
    var day: String?
    var maxTemp: String?
    var minTemp: String?
    var humidity: String?
    var condIcon: String?
    var imageNameFromData: Int?
    
    private var stackViewOfItems: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var stackViewOfImageAndHumidity: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    private var stackViewOfHighAndLowTemp: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20

        return stackView
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Wednesday"

        return label
    }()
    
    private lazy var imageWeather: UIImageView = {
        let imageName = "sunny"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = UIColor(
            red: 255/255,
            green: 255/255,
            blue: 255/255,
            alpha: 0.5)
        label.text = "80%"
        return label
    }()
    
    private lazy var temperatureHighLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.text = "20" + "º"
        label.textColor = .white
        return label
    }()
    
    private lazy var temperatureLowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.text = "-10" + "º"
        label.textColor = UIColor(
            red: 255/255,
            green: 255/255,
            blue: 255/255,
            alpha: 0.5)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWeeklyForecast()
    }
    
    func setupWeeklyForecast() {
        
        addSubview(stackViewOfItems)
        
        NSLayoutConstraint.activate([
            stackViewOfItems.topAnchor.constraint(equalTo: topAnchor),
            stackViewOfItems.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackViewOfItems.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            stackViewOfItems.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.widthAnchor.constraint(equalToConstant: 100),
        ])
        
        NSLayoutConstraint.activate([
            imageWeather.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            stackViewOfHighAndLowTemp.widthAnchor.constraint(equalToConstant: 110),
        ])
        
        stackViewOfImageAndHumidity.addArrangedSubview(imageWeather)
        stackViewOfImageAndHumidity.addArrangedSubview(humidityLabel)

        stackViewOfHighAndLowTemp.addArrangedSubview(temperatureHighLabel)
        stackViewOfHighAndLowTemp.addArrangedSubview(temperatureLowLabel)
        
        stackViewOfItems.addArrangedSubview(dayLabel)
        stackViewOfItems.addArrangedSubview(stackViewOfImageAndHumidity)
        stackViewOfItems.addArrangedSubview(stackViewOfHighAndLowTemp)

        setupLabelsAndImages()
    }
    
    func setupLabelsAndImages() {
        dayLabel.text = day
        temperatureHighLabel.text = maxTemp
        temperatureLowLabel.text = minTemp
        humidityLabel.text = (humidity ?? "") + "%"
        let image = String(imageNameFromData ?? 1000)
        imageWeather.image = UIImage(named: image)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
