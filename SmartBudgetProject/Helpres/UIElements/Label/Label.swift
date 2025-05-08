//
//  Label.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 13.04.2025.
//

import UIKit

class Label: UILabel {
    var textLabel: String?
    var textSize: CGFloat
    var labelTextColor: UIColor
    var numberLines: Int
    var labelWeight: UIFont.Weight
    
    init(textLabel: String? = nil,
         textSize: CGFloat,
         weight: UIFont.Weight = .regular,
         frame: CGRect = .zero,
         textColor: UIColor = .black,
         numberLines: Int = 0) {
        
        self.textLabel = textLabel
        self.textSize = textSize
        self.labelTextColor = textColor
        self.numberLines = numberLines
        self.labelWeight = weight
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        text = textLabel
        textColor = labelTextColor
        numberOfLines = numberLines
        font = UIFont.systemFont(ofSize: textSize, weight: labelWeight)
    }
}
