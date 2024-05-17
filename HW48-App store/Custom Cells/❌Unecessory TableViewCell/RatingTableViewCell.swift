//
//  RatingTableViewCell.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/14.
//

import UIKit

class RatingTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    static let identifier: String = "RatingTableViewCell"
    
    // MARK: - ScrollView
    var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = true
        return scrollView
    } ()
    
    // MARK: - App Rating description:
    var ratingLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "RATINGS"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var ratingValueBtn: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.lightGray
        
        var title = AttributedString("20")
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        config.attributedTitle = title
        
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var ratingStarCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "★"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var ratingStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    // MARK: - App's Age description:
    var ageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "AGE"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var ageLimitBtn: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.lightGray
        
        var title = AttributedString("4+")
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        config.attributedTitle = title
        
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var yearsOldLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Years Old"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var ageStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    // MARK: - Category
    var chartLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "CHART"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var rankBtn: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.lightGray
        
        var title = AttributedString("No.1")
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        config.attributedTitle = title
        
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Category"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var categoryStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    // MARK: - Developer Description:
    var developerLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "DEVELOPER"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var developerImageBtn: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.lightGray
        config.image = Images.developerIcon.applyingSymbolConfiguration(.init(pointSize: 22))
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var companyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "XXX COMPANY"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var developerStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    // MARK: - Language Description:
    var languageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "LANGUAGE"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var englishLabel: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.lightGray
        
        var title = AttributedString("EN")
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        config.attributedTitle = title
        
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var moreLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "+ 9 More"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var languageStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    
    // MARK: - App's size description:
    var sizeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "SIZE"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var fileSizeLabel: UIButton = {
        let btn: UIButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Colors.lightGray
        
        var title = AttributedString("10")
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        config.attributedTitle = title
        
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.configurationUpdateHandler = {
            btn in btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var appUnitLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "MB"
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var sizeStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    // MARK: - Main Stack View:
    var mainStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 25
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
        configureStackView()
        addConstraint()
        
        scrollView.isScrollEnabled = true
        scrollView.delegate = self
    }
    
    func configureStackView () {
        
        ageStackView.addArrangedSubview(ageLabel)
        ageStackView.addArrangedSubview(ageLimitBtn)
        ageStackView.addArrangedSubview(yearsOldLabel)
        
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(ratingValueBtn)
        ratingStackView.addArrangedSubview(ratingStarCountLabel)
        
        categoryStackView.addArrangedSubview(chartLabel)
        categoryStackView.addArrangedSubview(rankBtn)
        categoryStackView.addArrangedSubview(categoryLabel)
        
        sizeStackView.addArrangedSubview(sizeLabel)
        sizeStackView.addArrangedSubview(fileSizeLabel)
        sizeStackView.addArrangedSubview(appUnitLabel)
        
        languageStackView.addArrangedSubview(languageLabel)
        languageStackView.addArrangedSubview(englishLabel)
        languageStackView.addArrangedSubview(moreLabel)
        
        developerStackView.addArrangedSubview(developerLabel)
        developerStackView.addArrangedSubview(developerImageBtn)
        developerStackView.addArrangedSubview(companyLabel)
        
        mainStackView.addArrangedSubview(ratingStackView)
        mainStackView.addArrangedSubview(ageStackView)
        mainStackView.addArrangedSubview(categoryStackView)
        mainStackView.addArrangedSubview(developerStackView)
        mainStackView.addArrangedSubview(languageStackView)
        mainStackView.addArrangedSubview(sizeStackView)
    }
    
    func addConstraint() {
        self.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            // Set scrollView constraints
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Set mainStackView constraints within scrollView
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
    // MARK: - Preview:
    #Preview(traits: .fixedLayout(width: 528, height: 100), body: {
        let ratingTableViewCell = RatingTableViewCell()
        return ratingTableViewCell
    })
