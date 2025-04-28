//
//  InitialBudgetViewController.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 22.04.2025.
//

import Foundation
import UIKit

class InitialBudgetViewController: UIViewController {
    private var initBudgetView = InitialBudgetView()
    private var viewModel: InitialBudgetViewModel
    var coordinator: AppCoordinator?

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
    }
}
