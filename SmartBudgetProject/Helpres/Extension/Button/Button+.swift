//
//  Button+.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 16.05.2025.
//

import UIKit

extension UIButton {
    enum ButtonStyle {
        case yellow(title: String?, imageName: String? = nil)
        case white(title: String?)
        case gray(title: String?)
        case blue(title: String?)
    }
    
    static func create(style: ButtonStyle, completion: (() -> Void)? = nil) -> UIButton {
        let button = UIButton()
        let action = UIAction { _ in completion?() }
        button.addAction(action, for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSizeConstans.body, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        
        switch style {
        case .yellow(let title, let imageName):
            button.setTitle(title, for: .normal)
            button.backgroundColor = UIColor(hex: ColorConstans.yellow)
            if let imageName = imageName {
                button.setupImageButton(name: imageName)
            }
            
        case .white(let title):
            button.setTitle(title, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray.cgColor
            
        case .gray(let title):
            button.setTitle(title, for: .normal)
            button.backgroundColor = .systemGray5
            
        case .blue(let title):
            button.setTitle(title, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = .white
        }
        return button
    }
    
    private func setupImageButton(name: String?) {
        guard let name, let image = UIImage(named: name) else { return }
        var config = UIButton.Configuration.plain()
        config.image = image
        config.imagePlacement = .trailing
        self.configuration = config
        self.imageView?.frame.origin.y = ((self.bounds.height - (self.imageView?.frame.height ?? 0)) / 2) + 3.5
    }
}
