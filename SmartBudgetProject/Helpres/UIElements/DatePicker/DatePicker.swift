//
//  DatePicker.swift
//  SmartBudgetProject
//
//  Created by Терёхин Иван on 01.05.2025.
//

import UIKit

final class DatePicker: UIViewController {
    var onDateSelected: ((Date) -> Void)?
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.minimumDate = Date()
        return picker
    }()
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 15
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupActionButton()
    }
    
    private func setupLayout() {
        view.addSubviews(datePicker, doneButton)
        
        datePicker.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        })
            
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }
    
    private func setupActionButton() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.onDateSelected?(self.datePicker.date)
            dismiss(animated: true)
        }
        
        doneButton.addAction(action, for: .touchUpInside)
    }
}

