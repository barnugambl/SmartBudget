//
//  InitialBudgetViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import Foundation
import UIKit
import Combine

final class InitialBudgetViewController: UIViewController {
    private var initBudgetView = InitialBudgetView(categories: CategoryDto.defaultCategories())
    private let viewModel: InitialBudgetViewModel
    private var cancellable: Set<AnyCancellable> = .init()
    weak var coordinator: OnboardingCoordinator?
    
    init(viewModel: InitialBudgetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = initBudgetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        bindingViewModel()
    }
    
    private func bindingViewModel() {
        viewModel.budgetService.initialBudgetSubject
            .sink { [weak self] _, categories in
                guard let self else { return }
                self.initBudgetView.categories = categories
            }
            .store(in: &cancellable)
        
        initBudgetView.amountTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.incomeString, on: viewModel)
            .store(in: &cancellable)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.initBudgetView.setErrorMessage(message)
            }
            .store(in: &cancellable)
        
        viewModel.budgetService.updateColorSubject
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] color, name in
                self?.handleColorUpdate(name: name, color: color)
            }
            .store(in: &cancellable)
    }
    
    private func handleColorUpdate(name: String, color: UIColor) {
        if let index = initBudgetView.categories.firstIndex(where: { $0.name == name }) {
            initBudgetView.categories[index].iconColor = color
            initBudgetView.categoryViews[index].updateColor(color)
        }
    }
    
    private func setupNavigation() {
        navigationItem.titleView = initBudgetView.titleLabel
        
        initBudgetView.clickOnConfirmButton = { [weak self] categories in
            guard let self else { return }
            if self.viewModel.validateOnSumbit() {
                self.viewModel.budgetService.initialBudgetSubject.send((viewModel.incomeString, categories))
                self.coordinator?.showSetupPersentScreen()
            }
        }
        initBudgetView.clickOnCategory = { [weak self] category in
            self?.coordinator?.showSetupCategoryScreen(category: category)
        }
    }
}
