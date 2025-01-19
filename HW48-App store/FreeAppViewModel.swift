//
//  FreeAppViewModel.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2025/1/19.
//

import UIKit

class FreeAppViewModel {
    var freeAppStore: AppStore?
    
    var iconImage: String {
        return ""
    }
    
    var numberLabel: String {
        return ""
    }
    
    var appNameLabel: String {
        return ""
    }
    
    var appDescripionLabel: String {
        return ""
    }
    
    init(freeAppStore: AppStore? = nil) {
        self.freeAppStore = freeAppStore
        
    }
    
}


//let iconImageView: UIImageView = {
//    let imageView: UIImageView = UIImageView()
//    imageView.contentMode = .scaleAspectFit
//    imageView.image = Images.appIconTemplate
//    imageView.layer.cornerRadius = 20
//    imageView.clipsToBounds = true
//    imageView.layer.borderWidth = 0.2
//    imageView.layer.borderColor = Colors.lightGray.cgColor
//    imageView.translatesAutoresizingMaskIntoConstraints = false
//    return imageView
//} ()
//
//let numberLabel: UILabel = {
//    let label: UILabel = UILabel()
//    label.text = "1"
//    label.textColor = Colors.CustomTitleColor
//    label.textAlignment = .left
//    label.numberOfLines = 0
//    label.font = UIFont.boldSystemFont(ofSize: 20)
//    label.adjustsFontSizeToFitWidth = true
//    label.translatesAutoresizingMaskIntoConstraints = false
//    return label
//} ()
//
//let appNameLabel: UILabel = {
//    let label: UILabel = UILabel()
//    label.text = "App Name"
//    label.textColor = Colors.CustomTitleColor
//    label.textAlignment = .left
//    label.font = UIFont.boldSystemFont(ofSize: 20)
//    label.numberOfLines = 2
//    label.translatesAutoresizingMaskIntoConstraints = false
//    return label
//} ()
// 
//let appDescripionLabel: UILabel = {
//    let label: UILabel = UILabel()
//    label.text = "App Description"
//    label.textColor = Colors.lightGray
//    label.textAlignment = .left
//    label.numberOfLines = 1
//    label.font = UIFont.systemFont(ofSize: 13)
//    label.translatesAutoresizingMaskIntoConstraints = false
//    return label
//} ()
//
//let serviceBtn: UIButton = {
//    let btn: UIButton = UIButton()
//    var config = UIButton.Configuration.gray()
//    config.baseForegroundColor = Colors.blue
//    var title = AttributedString("Open")
//    title.font = UIFont.boldSystemFont(ofSize: 17)
//    config.attributedTitle = title
//    config.cornerStyle = .capsule
//    btn.configuration = config
//    btn.translatesAutoresizingMaskIntoConstraints = false
//    
//    btn.configurationUpdateHandler = {
//        btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
//    }
//    return btn
//} ()
