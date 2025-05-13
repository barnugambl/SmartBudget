//
//  SetupCategoryViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import Foundation
import UIKit

class SetupCategoryViewController: UIViewController {
    private var setupCategoryView = SetupCategoryView()
    private var viewModel: SetupCategoryViewModel
    weak var coordinator: OnboardingCoordinator?

    init(viewModel: SetupCategoryViewModel, title: String, iconName: String, iconColor: UIColor) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupCategoryView.setupCategoryView(title: title, iconName: iconName, iconColor: iconColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = setupCategoryView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func setupNavigation() {
        setupCategoryView.clickOnchangeButton = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
