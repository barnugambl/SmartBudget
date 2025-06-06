//
//  ColorView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 23.04.2025.
//

import UIKit

final class ColorView: UIView {
    var onClickColor: ((String) -> Void)?
    
    private lazy var colors: [String] = [
        "#FF3B30", "#FF9500", "#FFCC00", "#34C759", "#5AC8FA",
        "#007AFF", "#5856D6", "#AF52DE", "#FF2D55", "#A2845E",
        "#00C7BE", "#32ADE6", "#FF00FF", "#8E8E93", "#007AFF"
    ]
    private lazy var containerStack = UIStackView.create(stackSpacing: 10, stackDistribution: .equalSpacing)
    
    private var selectedButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        setupColorsButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.systemGray3.cgColor
        layer.shadowOffset = .init(width: 0, height: 2)
        layer.shadowOpacity = 4
    }
    
    private func setupLayout() {
        addSubview(containerStack)
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
        }
    }
    
    private func setupColorsButton() {
        let buttonSize: CGFloat = 32
        let rows = colors.chunked(into: 5)
        
        for row in rows {
            let rowStack = UIStackView.create(stackAxis: .horizontal, stackSpacing: 10,
                                 stackDistribution: .equalSpacing)
            for color in row {
                let button = UIButton()
                button.backgroundColor = UIColor(hex: color)
                button.layer.cornerRadius = buttonSize / 2
                button.layer.masksToBounds = true
                button.transform = CGAffineTransform.identity
                
                let action = UIAction { [weak self, weak button] _ in
                    guard let self, let button else { return }
                    
                    UIView.animate(withDuration: 0.3) {
                        self.selectedButton?.transform = CGAffineTransform.identity
                    }
                    
                    self.selectedButton?.layer.borderWidth = 0
                    self.selectedButton = button
                    
                    UIView.animate(withDuration: 0.3) {
                        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    }
        
                    self.onClickColor?(color)
                }
                
                button.addAction(action, for: .touchUpInside)
                
                button.snp.makeConstraints { make in
                    make.height.width.equalTo(buttonSize)
                }
                
                rowStack.addArrangedSubview(button)
            }
            containerStack.addArrangedSubview(rowStack)
        }

    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
