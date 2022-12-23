//
//  CustomTableViewCell.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 09.12.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CitiesCell"
    var city: String?
    var temperature: Double?
    var lastUpdate: String?
    var imageNameFromData: Int?
    
    private var stackViewOfCells: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var stackViewOfLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var lastUpdateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "15:00"
        return label
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var imageWeather: UIImageView = {
        let imageName = "1000"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 50, weight: .thin)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        addSubview(stackViewOfCells)
        NSLayoutConstraint.activate([
            stackViewOfCells.topAnchor.constraint(equalTo: topAnchor),
            stackViewOfCells.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackViewOfCells.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            stackViewOfCells.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
        
        stackViewOfCells.addArrangedSubview(stackViewOfLabels)
        
        NSLayoutConstraint.activate([
            stackViewOfLabels.topAnchor.constraint(
                equalTo: stackViewOfCells.topAnchor,
                constant: 10
            ),
            stackViewOfLabels.bottomAnchor.constraint(
                equalTo: stackViewOfCells.bottomAnchor,
                constant: -10
            )
        ])
        
        stackViewOfLabels.addArrangedSubview(lastUpdateLabel)
        stackViewOfLabels.addArrangedSubview(cityNameLabel)
        
        stackViewOfCells.addArrangedSubview(imageWeather)
        stackViewOfCells.addArrangedSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            imageWeather.topAnchor.constraint(
                equalTo: stackViewOfCells.topAnchor,
                constant: 10
            ),
            imageWeather.bottomAnchor.constraint(
                equalTo: stackViewOfCells.bottomAnchor,
                constant: -10
            ),
            imageWeather.widthAnchor.constraint(
                equalTo: imageWeather.heightAnchor
            ),
            imageWeather.centerXAnchor.constraint(equalTo: stackViewOfCells.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(
                equalTo: stackViewOfCells.topAnchor,
                constant: 10
            ),
            temperatureLabel.bottomAnchor.constraint(
                equalTo: stackViewOfCells.bottomAnchor,
                constant: -10
            )
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSecondLabel() {
        cityNameLabel.text = city
        guard let temperature = temperature else { return }
        let temperatureString = String(format: "%.1f", temperature)
        temperatureLabel.text = temperatureString + " º"
        lastUpdateLabel.text = lastUpdate
        let image = String(imageNameFromData ?? 1000)
        imageWeather.image = UIImage(named: image)
    }
}
