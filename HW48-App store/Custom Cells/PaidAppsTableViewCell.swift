//
//  PaidAppsTableViewCell.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/12.
//

import UIKit
import Kingfisher

class PaidAppsTableViewCell: UITableViewCell {
    
    static let identifier: String = "PaidAppsTableViewCell"
    
    let iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.appIconTemplate
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = Colors.lightGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    let numberLabel: UILabel = {
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
    
    let appNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "App Name"
        label.textColor = Colors.CustomTitleColor
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let appDescripionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "App Description"
        label.textColor = Colors.lightGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let priceBtn: UIButton = {
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
    
    // MARK: - prepareForReuse
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
        
        priceBtn.widthAnchor.constraint(equalToConstant: 105).isActive = true
        priceBtn.heightAnchor.constraint(equalTo: priceBtn.widthAnchor, multiplier: 0.35).isActive = true
        
        
        // 照片 & 順序
        imageContentStackView.addArrangedSubview(iconImageView)
        imageContentStackView.addArrangedSubview(numberLabel)
        
        // App名稱 & App產品說明
        contentStackView.addArrangedSubview(appNameLabel)
        contentStackView.addArrangedSubview(appDescripionLabel)
        
        secondStackView.addArrangedSubview(imageContentStackView)
        secondStackView.addArrangedSubview(contentStackView)
        
        mainStackView.addArrangedSubview(secondStackView)
        mainStackView.addArrangedSubview(priceBtn)
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
    
    // In PaidAppsTableViewCell.swift
    func configure(appStoreData: Result?, iTunesPrice: Double?) {
        // Configure app name and description
        if let appName = appStoreData?.name,
           let artistName = appStoreData?.artistName {
            appNameLabel.text = appName
            appDescripionLabel.text = artistName
        } else {
            appNameLabel.text = "Unknown App"
            appDescripionLabel.text = "Unknown Developer"
        }
        
        // Configure price button
        if let price = iTunesPrice {
            let boldText = NSAttributedString(
                string: "NT$\(price)",
                attributes: [.font: UIFont.boldSystemFont(ofSize: 15)]
            )
            priceBtn.setAttributedTitle(boldText, for: .normal)
        } else {
            let boldText = NSAttributedString(
                string: "Loading",
                attributes: [.font: UIFont.boldSystemFont(ofSize: 15)]
            )
            priceBtn.setAttributedTitle(boldText, for: .normal)
        }
        
        // Configure app icon
        if let imageURL = appStoreData?.artworkUrl100,
           let url = URL(string: imageURL) {
            iconImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "01.png")
            )
        } else {
            iconImageView.image = UIImage(named: "01.png")
        }
    }
}

// MARK: - Preview:
#Preview(traits: .fixedLayout(width: 428, height: 100), body: {
    let cell: UITableViewCell = PaidAppsTableViewCell()
    return cell
})

