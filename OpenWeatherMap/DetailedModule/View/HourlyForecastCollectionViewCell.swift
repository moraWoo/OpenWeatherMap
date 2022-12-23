//
//  HourlyForecastCollectionViewCell.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 13.12.2022.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "collectionCell"
    var hourlyForecast: String?
    var timeEpoch: String?
    var temp: String?
    var imageNameFromData: Int?
    
    private var stackViewOfItems: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.text = "12pm"
        return label
    }()
    
    private lazy var imageWeather: UIImageView = {
        let imageName = String(imageNameFromData ?? 1006)
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.text = "-10" + "º"
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHourlyForecast()
    }
    
    func setupHourlyForecast() {
        addSubview(stackViewOfItems)
        NSLayoutConstraint.activate([
            stackViewOfItems.topAnchor.constraint(equalTo: topAnchor),
            stackViewOfItems.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackViewOfItems.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            stackViewOfItems.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
        stackViewOfItems.addArrangedSubview(firstLabel)
        stackViewOfItems.addArrangedSubview(imageWeather)
        stackViewOfItems.addArrangedSubview(temperatureLabel)
        firstLabel.text = timeEpoch
        temperatureLabel.text = (temp ?? "") + "º"
        
        let image = String(imageNameFromData ?? 1000)
        imageWeather.image = UIImage(named: image)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

