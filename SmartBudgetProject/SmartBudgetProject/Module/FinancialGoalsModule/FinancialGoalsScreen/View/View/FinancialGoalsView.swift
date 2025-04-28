//
//  FinancialGoalsView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit

class FinancialGoalsView: UIView {
    private var modelView = FinancialGoalViewModel()
    
    lazy var financialGoalsTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
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
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

extension FinancialGoalsView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let currentItem = modelView.financialGoals[indexPath]
//    }
}
