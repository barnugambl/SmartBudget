//
//  FinancialGoalsView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit

final class FinancialGoalsView: UIView {    
    lazy var financialGoalsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.register(FinanceGoalsTableViewCell.self, forCellReuseIdentifier: FinanceGoalsTableViewCell.reuseIdentifier)
        table.separatorStyle = .none
        table.isHidden = true
        return table
    }()
    
    lazy var loadIndicator = CustomSpinnerSimple()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        loadIndicator.startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    func showTable() {
        loadIndicator.stopAnimation()
        financialGoalsTableView.isHidden = false
    }
    
    private func setupLayout() {
        addSubviews(financialGoalsTableView, loadIndicator)
        financialGoalsTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetSmall)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        loadIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constans.heightSpinner)
        }
    }
}

