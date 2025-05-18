//
//  Label+.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.05.2025.
//

import UIKit

extension UILabel {
    static func create(text: String? = nil, fontSize: CGFloat, weight: UIFont.Weight = .regular,
                       textColor: UIColor = .black, numberOfLines: Int = 0, frame: CGRect = .zero) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        return label
    }
}
