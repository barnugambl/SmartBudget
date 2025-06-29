//
//  SetupCategoryViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import Foundation
import UIKit

final class SetupCategoryViewController: UIViewController {
    private var setupCategoryView = SetupCategoryView()
    private var viewModel: SetupCategoryViewModel
    private var category: CategoryDto
    weak var coordinator: OnboardingCoordinator?

    init(viewModel: SetupCategoryViewModel, category: CategoryDto) {
        self.viewModel = viewModel
        self.category = category
        super.init(nibName: nil, bundle: nil)
        setupCategoryView.setupCategoryView(category: category)
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
        navigationItem.titleView = setupCategoryView.titleLabel
        
        setupCategoryView.clickOnchangeButton = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        setupCategoryView.clickOnConfirmButton = { [weak self] color, name in
            guard let self else { return }
            viewModel.budgetService.updateColorSubject.send((color, name))
            self.navigationController?.popViewController(animated: true)
        }
    }
}
