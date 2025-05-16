//
//  StackView+.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.05.2025.
//

import UIKit

extension UIStackView {
    static func create(stackAxis: NSLayoutConstraint.Axis = .vertical, stackSpacing: CGFloat = 0,
                       stackDistribution: UIStackView.Distribution = .fill,
                       stackAlignment: UIStackView.Alignment = .fill, views: [UIView] = []
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = stackAxis
        stackView.spacing = stackSpacing
        stackView.distribution = stackDistribution
        stackView.alignment = stackAlignment
        views.forEach({ stackView.addArrangedSubview($0) })
        return stackView
    }
}
