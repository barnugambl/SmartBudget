//
//  ProfileViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 21.04.2025.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    private var viewModel: ProfileViewModel
    private var profileView = ProfileView()
    weak var coordinator: ProfileCoordinator?

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTabBar()
    }
    
    private func setupTabBar() {
        navigationItem.titleView = profileView.titleLabel
        
        let action = UIAction { [weak self] _ in
            self?.coordinator?.logout()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", primaryAction: action)
    }
    
    private func setupNavigation() {
        profileView.onEvent = { [weak self] event in
            switch event {
            case .didTapEditProfile:
                self?.coordinator?.showEdtiProfleFlow()
            case .didTapExpenseHistory:
                break
            case .didTapFinanses:
                break
            }
        }
    }
}
