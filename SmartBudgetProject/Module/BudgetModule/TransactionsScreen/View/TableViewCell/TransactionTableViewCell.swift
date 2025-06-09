//
//  TransactionTableViewCell.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 09.06.2025.
//

import UIKit

enum TransactionCategory: String {
    case products = "Продукты"
    case transport = "Транспорт"
    case utilities = "Коммунальные услуги"
    case entertainment = "Развлечения"
    case other = "Другое"
    case savings = "Накопления"
    
    var iconName: String {
        switch self {
        case .products:
            return R.image.food_icon.name
        case .transport:
            return R.image.transport_icon.name
        case .utilities:
            return R.image.faucet_icon.name
        case .entertainment:
            return R.image.event_icon.name
        case .other:
            return R.image.other_icon.name
        case .savings:
            return R.image.coins_icon.name
        }
    }
}

final class TransactionTableViewCell: UITableViewCell {
    private lazy var descriptionLabel = UILabel.create(fontSize: FontSizeConstans.body, weight: .medium)
    private lazy var dateLabel = UILabel.create(fontSize: FontSizeConstans.subbody, weight: .regular)
    private lazy var amountLabel = UILabel.create(fontSize: FontSizeConstans.body, weight: .medium)
    
    private lazy var iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constans.cornerRadiusLarge
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    private lazy var labelsStackView = UIStackView.create(stackSpacing: 5, stackAlignment: .leading,
                                                          views: [descriptionLabel, dateLabel])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        selectionStyle = .none
        accessoryType = .none
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = Constans.cornerRadiusLarge
        view.layer.masksToBounds = true
        return view
    }()
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubviews(iconContainerView, labelsStackView, amountLabel)
        iconContainerView.addSubview(iconImageView)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constans.insetTiny)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        iconContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constans.insetSmall)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constans.sizeIconContainer)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constans.sizeIcon)
        }
        
        labelsStackView.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView.snp.trailing).offset(Constans.insetTiny)
            make.top.bottom.equalToSuperview().inset(Constans.insetTiny)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constans.insetSmall)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(transaction: Transaction, iconColor: String, iconName: String) {
        descriptionLabel.text = transaction.description
        dateLabel.text = transaction.date
        amountLabel.text = "\(transaction.amount)₽"
        iconContainerView.backgroundColor = UIColor(hex: iconColor)
        iconImageView.image = UIImage(named: iconName)
    }
}

extension TransactionTableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
