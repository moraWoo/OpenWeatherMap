//
//  HeaderCollectionViewCell.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 14.12.2022.
//

import UIKit

class HeaderCollectionViewCell: UIView {
    
    static let identifier = "headerCell"
    var city: String?
    var temperature: Double?
    var highTemp: Double?
    var lowTemp: Double?
    var text: String?
    var textDiscription: String?

    var stackViewOfLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var stackViewOfSecondLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var stackViewOfTemperatureLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 34)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 96, weight: .thin)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var highTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var lowTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var tempAndWeatherSecondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .thin)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeader()
    }
    
    func setupHeader() {
        addSubview(stackViewOfLabels)

        stackViewOfLabels.topAnchor.constraint(
            equalTo: topAnchor, constant: 100).isActive = true
        stackViewOfLabels.leftAnchor.constraint(
            equalTo: leftAnchor).isActive = true
        stackViewOfLabels.rightAnchor.constraint(
            equalTo: rightAnchor).isActive = true
        
        stackViewOfTemperatureLabels.addArrangedSubview(highTempLabel)
        stackViewOfTemperatureLabels.addArrangedSubview(lowTempLabel)
        
        stackViewOfLabels.addArrangedSubview(cityLabel)
        stackViewOfLabels.addArrangedSubview(tempLabel)
        stackViewOfLabels.addArrangedSubview(weatherLabel)
        stackViewOfLabels.addArrangedSubview(stackViewOfTemperatureLabels)
        
        cityLabel.text = city
        setupDataForUI()
        reloadUI()

    }
    
    func setupDataForUI() {
        guard let temperature = temperature else { return }
        var stringLabel = String(format: "%.1f", temperature)
        tempLabel.text = stringLabel + "º"
        tempAndWeatherSecondLabel.text = (String(temperature) + "º" + "| " + (textDiscription ?? ""))

        guard let highTemp = highTemp else { return }
        stringLabel = String(format: "%.1f", highTemp)
        highTempLabel.text = "H:" + stringLabel + "º  "
        
        guard let lowTemp = lowTemp else { return }
        stringLabel = String(format: "%.1f", lowTemp)
        lowTempLabel.text = "L:" + stringLabel + "º"
        textDiscription = text
        weatherLabel.text = text
    }
    
    func setupSecondHeader() {
        
        addSubview(stackViewOfSecondLabels)

        stackViewOfSecondLabels.topAnchor.constraint(
            equalTo: topAnchor, constant: 70).isActive = true
        stackViewOfSecondLabels.leftAnchor.constraint(
            equalTo: leftAnchor, constant: 20).isActive = true
        stackViewOfSecondLabels.rightAnchor.constraint(
            equalTo: rightAnchor, constant: -20).isActive = true
        
        stackViewOfSecondLabels.addArrangedSubview(cityLabel)
        stackViewOfSecondLabels.addArrangedSubview(tempAndWeatherSecondLabel)
        cityLabel.text = city
        textDiscription = text
        weatherLabel.text = text
        reloadUI()
    }
    
    private func reloadUI() {
        setNeedsLayout()
        layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


