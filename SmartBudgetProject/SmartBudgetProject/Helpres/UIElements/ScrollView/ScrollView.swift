//
//  ScrollView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import UIKit

class ScrollView: UIScrollView {
    private let scrollVerticalIndicator: Bool
    
    init(scrollVerticalIndicator: Bool = false, frame: CGRect = .zero) {
        self.scrollVerticalIndicator = scrollVerticalIndicator
        super.init(frame: frame)
        setupScroll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScroll() {
        showsVerticalScrollIndicator = scrollVerticalIndicator
        alwaysBounceVertical = true
        backgroundColor = .systemBackground
    }
    
}
