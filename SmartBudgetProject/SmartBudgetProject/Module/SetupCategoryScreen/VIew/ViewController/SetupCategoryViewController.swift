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
    var coordinator: AppCoordinator?

    init(viewModel: SetupCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = setupCategoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
