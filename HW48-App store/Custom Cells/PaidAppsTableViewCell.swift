//
//  PaidAppsTableViewCell.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/12.
//

import UIKit

class PaidAppsTableViewCell: UITableViewCell {
    
    static let identifier: String = "PaidAppsTableViewCell"
    
    var iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "01.png")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = Colors.lightGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    var numberLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "1"
        label.textColor = Colors.CustomTitleColor
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var appNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "App Name"
        label.textColor = Colors.CustomTitleColor
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var appDescripionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "App Description"
        label.textColor = Colors.lightGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let serviceBtn: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = Colors.blue
        var title = AttributedString("Price")
        title.font = UIFont.boldSystemFont(ofSize: 17)
        config.attributedTitle = title
        config.cornerStyle = .capsule
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    let imageContentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    let contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    let secondStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    let mainStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if isHighlighted == true {
            contentView.backgroundColor = Colors.lightGray
        } else {
            contentView.backgroundColor = Colors.clear
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("DEBUG PRINT: prepareForReuse")
    }
    
    // MARK: - Setup UI:
    func setupUI () {
        configStackView()
        addConstraints()
    }
    
    func configStackView () {
        numberLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        appNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        
        iconImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1).isActive = true
        
        serviceBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        serviceBtn.heightAnchor.constraint(equalTo: serviceBtn.widthAnchor, multiplier: 0.45).isActive = true
        
        
        // 照片 & 順序
        imageContentStackView.addArrangedSubview(iconImageView)
        imageContentStackView.addArrangedSubview(numberLabel)
        //        imageContentStackView.backgroundColor = Colors.blue
        
        // App名稱 & App產品說明
        contentStackView.addArrangedSubview(appNameLabel)
        contentStackView.addArrangedSubview(appDescripionLabel)
        //        contentStackView.backgroundColor = Colors.blue
        
        secondStackView.addArrangedSubview(imageContentStackView)
        secondStackView.addArrangedSubview(contentStackView)
        //        secondStackView.backgroundColor = Colors.blue
        
        mainStackView.addArrangedSubview(secondStackView)
        mainStackView.addArrangedSubview(serviceBtn)
    }
    
    func addConstraints() {
        self.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            // 設定 secondStackView
            mainStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
    }
}

// MARK: - Preview:
#Preview(traits: .fixedLayout(width: 428, height: 100), body: {
    let cell: UITableViewCell = PaidAppsTableViewCell()
    return cell
})

