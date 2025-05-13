//
//  CompletedButton.swift
//  SmartBudget
//
//  Created by Терёхин Иван on 13.04.2025.
//

import UIKit

class DefaultButton: UIButton {
    var title: String?
    var buttonBackgroundColor: UIColor
    var titleColor: UIColor
    var titleFontSize: CGFloat
    var completion: (() -> Void)?
    var layerBorderWidth: CGFloat
    var layerBorderColor: CGColor
    var cornerRadius: CGFloat
    var nameImage: String?
    
    init(title: String? = nil,
         buttonBackgroundColor: UIColor = UIColor(hex: "FFDD2D"),
         titleColor: UIColor = UIColor(hex: "333333"),
         titleFontSize: CGFloat = 16,
         nameImage: String? = nil,
         frame: CGRect = .zero,
         cornerRadius: CGFloat = 10,
         layerBorderWidth: CGFloat = 0,
         layerBorderColor: CGColor = UIColor.clear.cgColor,
         completion: (() -> Void)? = nil) {
        
        self.title = title
        self.buttonBackgroundColor = buttonBackgroundColor
        self.completion = completion
        self.titleFontSize = titleFontSize
        self.titleColor = titleColor
        self.nameImage = nameImage
        self.cornerRadius = cornerRadius
        self.layerBorderColor = layerBorderColor
        self.layerBorderWidth = layerBorderWidth
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.completion?()
        }), for: .touchUpInside)
        layer.borderWidth = layerBorderWidth
        layer.borderColor = layerBorderColor
        backgroundColor = buttonBackgroundColor
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = cornerRadius
        titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize, weight: .regular)
        
        guard let nameImage else { return }
        setupImageButton(name: nameImage)
    }
    
    private func setupImageButton(name: String?) {
        guard let image = UIImage(named: name!) else { return }
        setImage(image, for: .normal)
        tintColor = .blue
        semanticContentAttribute = .forceRightToLeft
        imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: -16)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
    }
}
