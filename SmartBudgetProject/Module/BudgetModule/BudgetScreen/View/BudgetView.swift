import UIKit
import DGCharts
import SnapKit

final class BudgetView: UIView {
    lazy var titleLabel = UILabel.create(text: R.string.localizable.expensesLabel(), fontSize: FontSizeConstans.title)
    lazy var pieChartView: PieChartView = {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupTableHeader() {
        let width = UIScreen.main.bounds.width
        
        // top + spacing + chart + bottom
        let headerHeight: CGFloat = 16 + 20 + 256 + 32
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: headerHeight))
        pieChartView.frame = CGRect(x: 32, y: 20,
                                    width: width - 64, height: 256)
        headerView.addSubview(pieChartView)
        budgetCategoryTableView.tableHeaderView = headerView
    }

    private func setupLayout() {
        addSubview(budgetCategoryTableView)
        budgetCategoryTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func createCenterAttributedText(amount: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(
            string: "\(R.string.localizable.pieChartLabel)\n",
            attributes: [
                .font: UIFont.systemFont(ofSize: FontSizeConstans.body),
                .foregroundColor: UIColor.gray,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        centerText.append(
            NSAttributedString(
                string: amount,
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: FontSizeConstans.title),
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle
                ]
            )
        )
        
        return centerText
    }
}

extension BudgetView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pieChartView.highlightValue(Highlight(x: Double(indexPath.row), y: 0, dataSetIndex: 0))
    }
}
