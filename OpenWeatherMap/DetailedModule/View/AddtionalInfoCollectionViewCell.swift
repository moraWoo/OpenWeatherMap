//
//  AddtionalInfoCollectionViewCell.swift
//  Collection-View-Layout-iOS13
//
//  Created by Ильдар on 19.12.2022.
//  Copyright © 2022 atikhonov. All rights reserved.
//

import UIKit

class AddtionalInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "addtionalInfoCell"
    var nameOfProperty: String?
    var valueOfProperty: String?
    
    private var stackViewOfLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nameOfPropertyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor(
            red: 255/255,
            green: 255/255,
            blue: 255/255,
            alpha: 0.5)
        label.text = "SUNRISE"
        return label
    }()
    
    private lazy var valueOfPropertiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.text = "07:05"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddtionalInfo()
    }
    
    func setupAddtionalInfo() {
        addSubview(stackViewOfLabels)
        
        stackViewOfLabels.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
        stackViewOfLabels.leftAnchor.constraint(
            equalTo: leftAnchor).isActive = true
        stackViewOfLabels.rightAnchor.constraint(
            equalTo: rightAnchor).isActive = true
        
        stackViewOfLabels.addArrangedSubview(nameOfPropertyLabel)
        stackViewOfLabels.addArrangedSubview(valueOfPropertiesLabel)
        
        nameOfPropertyLabel.text = nameOfProperty
        valueOfPropertiesLabel.text = valueOfProperty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
