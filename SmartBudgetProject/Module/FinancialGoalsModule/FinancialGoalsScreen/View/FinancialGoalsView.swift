//
//  FinancialGoalsView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit

class FinancialGoalsView: UIView {    
    lazy var financialGoalsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.register(FinanceGoalsTableViewCell.self, forCellReuseIdentifier: FinanceGoalsTableViewCell.reuseIdentifier)
        table.separatorStyle = .none
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubviews(financialGoalsTableView)
        financialGoalsTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constans.insetSmall)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

