import UIKit
import DGCharts
import SnapKit

class ExpensesView: UIView {
    
    private lazy var titleLabel = Label(textLabel: "Мои расходы", textSize: 24)
    var viewModel = ExpensesViewModel()
    var entries: [PieChartDataEntry] = []
    var data: [BudgetCategory] = []

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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if pieChartView.superview == nil {
            setupDataPieChart()
            setupPieChart()
            setupTableHeader()
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDataPieChart() {
        data = viewModel.financialGoals
        entries = data.map { item in
            let entry = PieChartDataEntry(value: Double(item.plannedAmount))
            entry.label = item.name
            return entry
        }
    }
    
    private func setupPieChart() {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [.systemMint, .systemPink, .systemBlue]
        dataSet.valueColors = [.black]
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet.drawValuesEnabled = false
        dataSet.sliceSpace = 10
        dataSet.selectionShift = 5
        
        let chartData = PieChartData(dataSet: dataSet)
        pieChartView.data = chartData
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "Бюджет\n",
                                                   attributes: [
                                                       .font: UIFont.systemFont(ofSize: 16),
                                                       .foregroundColor: UIColor.gray,
                                                       .paragraphStyle: paragraphStyle
                                                   ])
        
        let budget = viewModel.financialGoals.map({ $0.plannedAmount })
        let sumBudget = budget.reduce(0, +)
        
        centerText.append(NSAttributedString(string: "\(sumBudget)₽",
                                             attributes: [
                                                 .font: UIFont.boldSystemFont(ofSize: 24),
                                                 .foregroundColor: UIColor.black,
                                                 .paragraphStyle: paragraphStyle
                                             ]))
        
        pieChartView.centerAttributedText = centerText
        pieChartView.animate(yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupTableHeader() {
        let width = UIScreen.main.bounds.width
        
        // top + title + spacing + chart + bottom
        let headerHeight: CGFloat = 16 + 24 + 20 + 256 + 32
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: headerHeight))
        titleLabel.frame = CGRect(x: 0, y: 16, width: width, height: 24)
        titleLabel.textAlignment = .center
        pieChartView.frame = CGRect(x: 32, y: titleLabel.frame.maxY + 20,
                                    width: width - 64, height: 256)
        headerView.addSubview(titleLabel)
        headerView.addSubview(pieChartView)
        budgetCategoryTableView.tableHeaderView = headerView
    }

    
    private func setupLayout() {
        addSubview(budgetCategoryTableView)
        budgetCategoryTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension ExpensesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pieChartView.highlightValue(Highlight(x: Double(indexPath.row), y: 0, dataSetIndex: 0))
    }
}
