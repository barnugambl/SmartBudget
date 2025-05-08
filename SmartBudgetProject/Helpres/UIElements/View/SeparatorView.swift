//
//  SeparatorView.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 14.04.2025.
//

import UIKit

class SeparatorView: UIView {
    private lazy var label = Label(textLabel: "или", textSize: 14, textColor: .systemGray3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private lazy var leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private func setupLayout() {
        addSubviews(leftLine, label, rightLine)
        
        leftLine.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(label.snp.leading).offset(-24)
            make.centerY.equalToSuperview()
            make.height.equalTo(1.75)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        rightLine.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(24)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(1.75)
        }
    }
}
