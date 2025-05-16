//
//  ScrollView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 15.05.2025.
//

import UIKit

extension UIScrollView {
    static func create(scrollVerticalIndicator: Bool = false) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = scrollVerticalIndicator
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .systemBackground
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }
}

