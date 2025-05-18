//
//  SetupPersentViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 04.05.2025.
//

import Foundation
import UIKit

class SetupPersentViewController: UIViewController {
    private var persentView = SetupPersentView()
    
    override func loadView() {
        view = persentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = persentView.titleLabel
    }
}


