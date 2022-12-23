//
//  TextInfoCollectionViewCell.swift
//  Collection-View-Layout-iOS13
//
//  Created by Ильдар on 19.12.2022.
//  Copyright © 2022 atikhonov. All rights reserved.
//

import UIKit

class TextInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "textInfoCell"
    var text: String?
    
    private lazy var textInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(
            red: 255/255,
            green: 255/255,
            blue: 255/255,
            alpha: 0.5)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextInfo()
    }
    
    func setupTextInfo() {
        addSubview(textInfoLabel)
        
        textInfoLabel.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
        textInfoLabel.leftAnchor.constraint(
            equalTo: leftAnchor).isActive = true
        textInfoLabel.rightAnchor.constraint(
            equalTo: rightAnchor).isActive = true
        
        textInfoLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
