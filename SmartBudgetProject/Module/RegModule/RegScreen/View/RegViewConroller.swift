//
//  RegViewConroller.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 14.04.2025.
//

import Foundation
import UIKit

final class RegViewConroller: UIViewController {
    private var viewModel: RegViewModel
    private var regView = RegView()
    weak var coordinator: AuthCoordinator?
    
    init(viewModel: RegViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = regView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func setupNavigation() {
        regView.onEvent = { [weak self] event in
            switch event {
            case .didTapLogin:
                self?.coordinator?.showLoginFlow()
            case .didTapSendCode:
                self?.coordinator?.showCheckNumberFlow(type: .registration)
            case .didTapTId:
                break
            }
        }
    }
}
