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
    weak var coordinator: OnboardingCoordinator?
    let viewModel: SetupPresentViewModel
    
    init(viewModel: SetupPresentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = persentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = persentView.titleLabel
        
        persentView.clickOnConfirmButton = { [weak self] in
            self?.coordinator?.finishOnBoarding()
        }
    }
}


