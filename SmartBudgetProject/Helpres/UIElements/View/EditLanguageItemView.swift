//
//  EditLanguageItemView.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 10.06.2025.
//

import SnapKit
import UIKit

final class EditLanguageItemView: UIView {
    private let titleLabel = UILabel.create(text: R.string.localizable.editLanguageButton(), fontSize: 16)
    private let iconContainer = UIView()
    private let icon = UIImageView(image: UIImage(named: R.image.language_icon.name))
    private let chevronButton = UIButton(type: .system)
    private lazy var languageStack = UIStackView.create(stackSpacing: 20, views: [])

    private let languages = ["ru": "Русский", "en": "English"]
    private var isExpanded = false
    private var selectedLanguage: String = "ru"

    var onLanguageSelected: ((String) -> Void)?

    private var heightConstraint: Constraint?
    private var languageLabels: [String: UIStackView] = [:]

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    func configure(selectedLanguage: String, onSelect: @escaping (String) -> Void) {
        self.selectedLanguage = selectedLanguage
        self.onLanguageSelected = onSelect
        updateCheckmarks()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.systemGray3.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4

        icon.contentMode = .scaleAspectFit
        iconContainer.backgroundColor = UIColor(hex: "#007AFF")
        iconContainer.layer.cornerRadius = 22

        chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        chevronButton.tintColor = .systemGray3
        chevronButton.addTarget(self, action: #selector(toggleLanguageList), for: .touchUpInside)
        languageStack.alpha = 0

        for (code, title) in languages {
            let label = UILabel.create(text: title, fontSize: 15)

            let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmark.tintColor = .systemBlue
            checkmark.isHidden = (code != selectedLanguage)

            let rowStack = UIStackView(arrangedSubviews: [label, checkmark])
            rowStack.axis = .horizontal
            rowStack.spacing = 8
            rowStack.distribution = .equalSpacing
            rowStack.isUserInteractionEnabled = true
            rowStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(languageTapped(_:))))
            rowStack.accessibilityIdentifier = code

            languageStack.addArrangedSubview(rowStack)
            languageLabels[code] = rowStack
        }

        addSubviews(titleLabel, iconContainer, chevronButton, languageStack)
        iconContainer.addSubview(icon)
    }

    private func setupLayout() {
        iconContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(44)
        }

        icon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(22)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainer.snp.trailing).offset(16)
            make.top.equalToSuperview().inset(16)
        }

        chevronButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(22)
        }

        languageStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        self.snp.makeConstraints { make in
            heightConstraint = make.height.equalTo(60).constraint
        }
    }

    @objc private func toggleLanguageList() {
        isExpanded.toggle()

        UIView.animate(withDuration: 0.3) {
            let angle: CGFloat = self.isExpanded ? .pi / 2 : 0
            self.chevronButton.transform = CGAffineTransform(rotationAngle: angle)
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.heightConstraint?.update(offset: self.isExpanded ? 140 : 60)
            self.languageStack.alpha = self.isExpanded ? 1 : 0
            self.layoutIfNeeded()
        })
    }

    @objc private func languageTapped(_ gesture: UITapGestureRecognizer) {
        guard
            let stack = gesture.view as? UIStackView,
            let langCode = stack.accessibilityIdentifier else { return }

        selectedLanguage = langCode
        onLanguageSelected?(langCode)
        updateCheckmarks()
    }

    private func updateCheckmarks() {
        for (code, stack) in languageLabels {
            if let checkmark = stack.arrangedSubviews.last as? UIImageView {
                checkmark.isHidden = (code != selectedLanguage)
            }
        }
    }
}
