//
//  WhatIsNewTableViewCell.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/14.
//

import UIKit

class WhatIsNewTableViewCell: UITableViewCell {
    
    static let identifier: String = "WhatIsNewTableViewCell"
    
    var whatIsNewLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "What's New"
        label.textColor = Colors.CustomTitleColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var versionNumberLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Version 331.0"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var versionHistoryBtn: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.plain()
        var title = AttributedString("Version History")
        title.font = UIFont.systemFont(ofSize: 15)
        config.attributedTitle = title
        config.titleAlignment = .trailing
        config.baseForegroundColor = Colors.blue
        config.contentInsets.trailing = 0
        btn.configuration = config
//        btn.backgroundColor = Colors.lightGray
        // configurationUpdateHandler
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var updatedLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "1d ago"
        label.textColor = Colors.CustomTitleColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var descriptionTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.text = "What's New...XXXXXXXXXX"
        textView.textColor = Colors.CustomTitleColor
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textAlignment = .left
//        textView.backgroundColor = Colors.blue
        textView.backgroundColor = Colors.clear
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    } ()
    
    var leftStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    var rightStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .trailing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    var mainStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    // MARK: - init:
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        configStackView()
        addConstraints()
    }
    
    func configStackView () {
        versionHistoryBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        versionHistoryBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        leftStackView.addArrangedSubview(whatIsNewLabel)
        leftStackView.addArrangedSubview(versionNumberLabel)
        
        rightStackView.addArrangedSubview(versionHistoryBtn)
        rightStackView.addArrangedSubview(updatedLabel)
    }
    
    func addConstraints () {
        self.addSubview(leftStackView)
        self.addSubview(rightStackView)
//        self.addSubview(mainStackView)
        self.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            leftStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            leftStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            rightStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            rightStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            descriptionTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 65),
            descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

#Preview(traits: .fixedLayout(width: 428, height: 125), body: {
    let whatisNewTableViewCell = WhatIsNewTableViewCell()
    return whatisNewTableViewCell
})
