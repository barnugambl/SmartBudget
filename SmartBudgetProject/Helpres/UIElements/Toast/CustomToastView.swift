//
//  CustomToastView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 25.05.2025.
//

import Foundation
import UIKit

final class CustomToastView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: FontSizeConstans.subbody, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
        
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var stackView = UIStackView.create(stackAxis: .horizontal, stackSpacing: Constans.tinyStackSpacing, stackAlignment: .center,
                                                     views: [iconImageView, messageLabel])
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        layer.cornerRadius = Constans.cornerRadiusSmall
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: -100)
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constans.insetSmall)
            make.leading.trailing.equalToSuperview().inset(Constans.insetSmall)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(Constans.insetMedium)
        }
    }
    
    func configure(with message: String, icon: UIImage?) {
        messageLabel.text = message
        iconImageView.image = icon
    }
    
    private func show(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = .identity
        }, completion: { _ in
            completion?()
        })
    }
    
    private func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -100)
        }, completion: { _ in
            self.removeFromSuperview()
            completion?()
        })
    }
    
    static func showSuccessToast(on view: UIView?, message: String, duration: TimeInterval = 2.0,
                                 icon: UIImage? = UIImage(systemName: "checkmark.circle.fill")) {
        guard let view else { return }
        let toastView = CustomToastView()
        toastView.configure(with: message, icon: icon)
        view.addSubview(toastView)
        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constans.insetSmall)
            make.leading.greaterThanOrEqualToSuperview().offset(Constans.insetLarge)
            make.trailing.lessThanOrEqualToSuperview().offset(-Constans.insetLarge)
        }
        
        view.layoutIfNeeded()
        
        toastView.show {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                toastView.hide()
            }
        }
    }
}
