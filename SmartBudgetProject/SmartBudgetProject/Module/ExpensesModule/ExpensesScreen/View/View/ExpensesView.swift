//
//  ExpensesView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 25.04.2025.
//

import UIKit
import DGCharts
import SnapKit

class ExpensesView: UIView {
    private lazy var titleLabel = Label(textLabel: "Мои расходы", textSize: 24)
    var viewModel = ExpensesViewModel()
    var entries: [PieChartDataEntry] = []
    var data: [BudgetCategory] = []
    private var isSyncingScroll = false

    
    private lazy var pieChartView: PieChartView = {
        let pieChart = PieChartView()
        pieChart.drawEntryLabelsEnabled = false
        pieChart.rotationEnabled = false
        pieChart.highlightPerTapEnabled = true
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.7
        pieChart.drawEntryLabelsEnabled = true
        
        return pieChart
    }()
    
    private lazy var myScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.delegate = self
        return scroll
    }()
    
    private lazy var contentView = UIView()
    
    lazy var budgetCategoryTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.register(BudgetCategoryViewCell.self, forCellReuseIdentifier: BudgetCategoryViewCell.reuseIdentifier)
        return table
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        setupDataPieChart()
        setupPieChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDataPieChart() {
        data = viewModel.financialGoals
        
        entries = data.map({ item in
            let entry = PieChartDataEntry(value: Double(item.plannedAmount))
            entry.label = item.name
            return entry
        })
    }
    
    private func setupPieChart() {
        let dataSet = PieChartDataSet(entries: entries, label: "Budget")
        
        dataSet.colors = [.systemMint, .systemPink, .systemBlue]
        dataSet.valueColors = [.black]
        
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet.drawValuesEnabled = false

        dataSet.sliceSpace = 10
        dataSet.selectionShift = 5
        
        
        let chartData = PieChartData(dataSet: dataSet)
        pieChartView.data = chartData
        
        let centerText = NSMutableAttributedString(string: "Бюджет\n",
                                                   attributes: [
                                                      .font: UIFont.systemFont(ofSize: 16),
                                                      .foregroundColor: UIColor.gray
                                                   ])
          
        let budget = viewModel.financialGoals.map({ $0.plannedAmount })
        let sumBudget = budget.reduce(0) { $0 + $1 }

        
        centerText.append(NSAttributedString(string: "\(sumBudget)₽",
                                             attributes: [
                                              .font: UIFont.boldSystemFont(ofSize: 24),
                                              .foregroundColor: UIColor.black
                                             ]))
          
        pieChartView.centerAttributedText = centerText
        pieChartView.animate(yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubviews(myScrollView)
        myScrollView.addSubview(contentView)
        addSubviews(titleLabel, pieChartView, budgetCategoryTableView)
        
        myScrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(myScrollView)
            make.width.equalTo(myScrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(30)
            make.centerX.equalToSuperview()
        }
        
        pieChartView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(256)
        }
        
        budgetCategoryTableView.snp.makeConstraints { make in
            make.top.equalTo(pieChartView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}

extension ExpensesView: UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pieChartView.highlightValue(Highlight(x: Double(indexPath.row), y: 0, dataSetIndex: 0))
    }
}
