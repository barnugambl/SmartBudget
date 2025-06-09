import UIKit
import DGCharts
import SnapKit

final class BudgetView: UIView {
    lazy var titleLabel = UILabel.create(text: R.string.localizable.expensesLabel(), fontSize: FontSizeConstans.title)
    
    lazy var loadIndicator = CustomSpinnerSimple()
    
    lazy var pieChartView: PieChartView = {
        let pieChart = PieChartView()
        pieChart.drawEntryLabelsEnabled = false
        pieChart.rotationEnabled = false
        pieChart.highlightPerTapEnabled = true
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.7
        pieChart.drawEntryLabelsEnabled = true
        
        pieChart.noDataText = "Упс, произошла ошибка попробуйте позже"
        pieChart.noDataTextColor = .systemGray3
        pieChart.noDataFont = UIFont.systemFont(ofSize: 16)
        return pieChart
    }()
    
    lazy var budgetCategoryTableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.register(BudgetCategoryViewCell.self, forCellReuseIdentifier: BudgetCategoryViewCell.reuseIdentifier)
        return table
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = UIColor(hex: ColorConstans.yellow)
        return control
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        loadIndicator.startAnimation()
    }
    
    func showView() {
        loadIndicator.stopAnimation()
        budgetCategoryTableView.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        budgetCategoryTableView.refreshControl = refreshControl
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
        addSubviews(budgetCategoryTableView, loadIndicator)
        budgetCategoryTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        loadIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constans.heightSpinner)
        }
    }
    
    func createCenterAttributedText(amount: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(
            string: "Бюджет\n",
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
