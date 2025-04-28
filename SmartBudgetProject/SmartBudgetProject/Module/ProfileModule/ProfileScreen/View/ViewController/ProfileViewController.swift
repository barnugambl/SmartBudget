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
    var coordinator: AppCoordinator?

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
    }
    
    private func setupNavigation() {
        profileView.onEvent = { [weak self] event in
            switch event {
            case .didTapEditProfile:
                self?.coordinator?.showEditProfileScreen()
            case .didTapExpenseHistory:
                break
            case .didTapFinanses:
                break
            }
        }
    }
}
