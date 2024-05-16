//
//  AppDetailView.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/14.
//

import UIKit

class AppDetailView: UIView {
    
    var appImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.defaultImage
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = Colors.lightGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    var appTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "App Name"
        label.textColor = Colors.CustomTitleColor
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var appDescriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "App Description"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var iAPLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = """
                In-App
                Purchases
                """
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var shareBtn: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.blue
        config.image = Images.share
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var functionBtn: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.filled()
        var title = AttributedString("Get")
        title.font = UIFont.boldSystemFont(ofSize: 18)
        config.attributedTitle = title
        config.baseForegroundColor = Colors.white
        config.baseBackgroundColor = Colors.blue
        config.cornerStyle = .capsule
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    var contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    var mainStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    
    // MARK: - init:
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        configureStackView()
        addConstraints()
        functionBtn.addTarget(self, action: #selector(functionBtnTapped), for: .touchUpInside)
    }
    
    @objc func functionBtnTapped (_ sender: UIButton) {
        print("functionBtnTapped")
        
    }
    
    func configureStackView () {
        
        appImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        appImageView.heightAnchor.constraint(equalTo: appImageView.widthAnchor, multiplier: 1).isActive = true
        
        functionBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        functionBtn.heightAnchor.constraint(equalTo: functionBtn.widthAnchor, multiplier: 0.45).isActive = true
        
        shareBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        shareBtn.heightAnchor.constraint(equalTo: shareBtn.widthAnchor, multiplier: 1).isActive = true
        
        stackView.addArrangedSubview(functionBtn)
        stackView.addArrangedSubview(iAPLabel)
        
        contentStackView.addArrangedSubview(appTitleLabel)
        contentStackView.addArrangedSubview(appDescriptionLabel)
        contentStackView.addArrangedSubview(stackView)
        
        mainStackView.addArrangedSubview(appImageView)
        mainStackView.addArrangedSubview(contentStackView)
    }
    
    func addConstraints () {
        self.addSubview(mainStackView)
        self.addSubview(shareBtn)
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            shareBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            shareBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
    }
}

#Preview(traits: .fixedLayout(width: 428, height: 160), body: {
    let appDetailView = AppDetailView()
    return appDetailView
})
