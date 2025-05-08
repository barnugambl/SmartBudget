//
//  Stack.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 16.04.2025.
//

import UIKit

class Stack: UIStackView {
    private var stackAxis: NSLayoutConstraint.Axis
    private var stackSpaicing: CGFloat
    private var stackDistribution: Stack.Distribution
    private var stackAligment: UIStackView.Alignment
    private var views: [UIView]
    
    init(stackAxis: NSLayoutConstraint.Axis = .vertical,
         stackSpaicing: CGFloat = 0,
         stackDistribution: Stack.Distribution = .fill,
         stackAligment: UIStackView.Alignment = .fill,
         views: [UIView] = [],
         frame: CGRect = .zero) {
        
        self.stackAxis = stackAxis
        self.stackSpaicing = stackSpaicing
        self.stackDistribution = stackDistribution
        self.stackAligment = stackAligment
        self.views = views
        super.init(frame: frame)
        setupStack()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStack() {
        axis = stackAxis
        spacing = stackSpaicing
        distribution = stackDistribution
        alignment = stackAligment
        views.forEach({ addArrangedSubview($0) })
    }
}
