//
//  AppStoreTableViewCell.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/9.
//

import UIKit

class AppStoreTableViewCell: UITableViewCell {

    static let identifier: String = "AppStoreTableViewCell"
    
    var iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "01.png")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
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
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let serviceBtn: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = Colors.blue
        config.title = "Open"
        config.cornerStyle = .capsule
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
    
    let imageContentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillEqually
        stackView.spacing = 10
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
        iconImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1).isActive = true
                
        // 照片 & 順序
        imageContentStackView.addArrangedSubview(iconImageView)
        imageContentStackView.addArrangedSubview(numberLabel)
        
        // App名稱 & App產品說明
        contentStackView.addArrangedSubview(appNameLabel)
        contentStackView.addArrangedSubview(appDescripionLabel)
    }
    
    func addConstraints() {
        self.addSubview(imageContentStackView)
        self.addSubview(contentStackView)
        self.addSubview(serviceBtn)
        
        serviceBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        serviceBtn.heightAnchor.constraint(equalTo: serviceBtn.widthAnchor, multiplier: 0.45).isActive = true
        
        NSLayoutConstraint.activate([
            
            // 設定 imageContentStackView
            imageContentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageContentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            
            // 設定 cotentStackView
            contentStackView.leadingAnchor.constraint(equalTo: imageContentStackView.trailingAnchor, constant: -40),
            contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: serviceBtn.leadingAnchor, constant: -20),
            
            serviceBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            serviceBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
        ])
        
    }
    
//    static func nib() -> UINib {
//        return UINib(nibName: "AppStoreTableViewCell", bundle: nil)
//    }
    
}

// MARK: - Preview:
#Preview(traits: .fixedLayout(width: 428, height: 100), body: {
    let cell: UITableViewCell = AppStoreTableViewCell()
    return cell
})
