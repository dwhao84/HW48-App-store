//
//  AppDetailHeadView.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/14.
//

import UIKit

class AppDetailHeadView: UIView {
    
    static let appDetailHeadView: String = "AppDetailHeadView"

    var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.defaultImage
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = Colors.lightGray.cgColor
        return imageView
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        addConstraint()
    }
    
    func addConstraint() {
        bannerImageView.heightAnchor.constraint(equalTo: bannerImageView.widthAnchor, multiplier: 0.55).isActive = true
        
        self.addSubview(bannerImageView)
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: self.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

#Preview {
    let appDetailHeadView: UIView = AppDetailHeadView()
    return appDetailHeadView
}


