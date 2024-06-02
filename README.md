#  HW#48 - App Store 

這次的練習，主要是練習如何串接App store的API，顯示App store榜上25個熱門的Apps，再利用Segmented Control切換付費版以及免費版的內容。

### 功能和畫面需求:
* 利用 segmented control 切換 Free Apps / Paid Apps 列表
* 從 RSS Feed Generator API 取得 App 排行榜
* 點選列表的 App 後顯示 App 的詳細頁面，串接 iTunes Search API
* 利用 SKStoreProductViewController 顯示 App 的購買頁面
* 支援Dark Mode

### 利用 segmented control 切換 Free Apps / Paid Apps 列表:
<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/main/HW48-App%20store/Supporting%20FIles/Assets.xcassets/Demo%20Gif/HW48_AppStore_SegmentedControl_switched.dataset/HW48_AppStore_SegmentedControl_switched.gif" width="385" height="800"/>
</p>

* 先建立兩個tableView，分別為freeTableView & paidTableView。

```
     var freeAppTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
     var paidAppTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } () 
```

* 設定tableView內容，依照不同的tableView連接不同tableViewCell，並加上refreshControl 。

```
// MARK: - Configure TableViews:
    func configFreeTableView () {
        freeAppTableView.delegate   = self
        freeAppTableView.dataSource = self
        freeAppTableView.rowHeight = 100
        freeAppTableView.allowsSelection = true
        freeAppTableView.separatorStyle = .singleLine
        freeAppTableView.register(FreeAppsTableViewCell.self, forCellReuseIdentifier: FreeAppsTableViewCell.identifier)
        freeAppTableView.isScrollEnabled = true
        freeAppTableView.refreshControl = freeTableViewRefreshControl
    }
    
    func configPaidTableView () {
        paidAppTableView.delegate   = self
        paidAppTableView.dataSource = self
        paidAppTableView.rowHeight = 100
        paidAppTableView.allowsSelection = true
        paidAppTableView.separatorStyle = .singleLine
        paidAppTableView.register(PaidAppsTableViewCell.self, forCellReuseIdentifier: PaidAppsTableViewCell.identifier)
        paidAppTableView.isScrollEnabled = true
        paidAppTableView.refreshControl = paidTableViewRefreshControl
    }
```

* 設定freeAppsTableViewCell & paidAppsTableViewCell:
##### FreeAppsTableViewCell:

```
import UIKit

import UIKit

class FreeAppsTableViewCell: UITableViewCell {

    static let identifier: String = "FreeAppsTableViewCell"
    
    var iconImageView: UIImageView = {
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
        var title = AttributedString("Open")
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
        
        // App名稱 & App產品說明
        contentStackView.addArrangedSubview(appNameLabel)
        contentStackView.addArrangedSubview(appDescripionLabel)
        
        secondStackView.addArrangedSubview(imageContentStackView)
        secondStackView.addArrangedSubview(contentStackView)
        
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
    let cell: UITableViewCell = FreeAppsTableViewCell()
    return cell
})
```

##### PaidAppsTableViewCell:

```
import UIKit

class PaidAppsTableViewCell: UITableViewCell {
    
    static let identifier: String = "PaidAppsTableViewCell"
    
    var iconImageView: UIImageView = {
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
}

// MARK: - Preview:
#Preview(traits: .fixedLayout(width: 428, height: 100), body: {
    let cell: UITableViewCell = PaidAppsTableViewCell()
    return cell
})
```

* 利用Closure的寫法，建立_segmentedControl_。
```
// MARK: - UI Setup:
    var segmenteControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Free App", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Paid App", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    } ()
```

* _segmentedControl 加上addTarget ，以確保segmentedControl有連上segmentedControlValueChanged的method。
```
segmenteControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
```

* 用 @objc func的寫法，建立segmentedControlValueChanged，再用sender.selectedSegmentIndex來切換不同tableView的內容，當case等於0的時候，顯示freeAppTableView；當case 為1時，顯示paidAppTableView。

```
// MARK: - Add Actions:
    @objc func segmentedControlValueChanged (_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("DEBUG PRINT: Switch to Free App")
            paidAppTableView.isHidden = true
            freeAppTableView.isHidden = false
            freeAppTableView.reloadData()
        case 1:
            print("DEBUG PRINT: Switch to Paid App")
            paidAppTableView.isHidden = false
            freeAppTableView.isHidden = true
            paidAppTableView.reloadData()
        default:
            break
        }
    }
```

> Reference:
![利用多個 container view 切換頁面](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用多個-container-view-切換頁面-6d00fe848572)


### 從 RSS Feed Generator API 取得 App 排行榜:

這次的API是由RSS Feed Generator裡面找到的，裡面可以找到各個國家的各種資料(書籍 / App / Music / 廣播)，並且運用設定好的參數產生一個API，並且顯示你要的資料。
> ![RSS Feed Generator](https://medium.com/r?url=https%3A%2F%2Frss.applemarketingtools.com%2F)

這次主要是使用App Store排名前25個App的內容，做為練習，所以首先分別建立兩個不同的API網址，在AppViewController裡面。

```
private let freeAppStoreUrl: String = "https://rss.applemarketingtools.com/api/v2/tw/apps/top-free/25/apps.json"
private let paidAppStoreUrl: String = "https://rss.applemarketingtools.com/api/v2/tw/apps/top-paid/25/apps.json"
```

再來建議解析API的資料結構，我們可以把API網址貼到Postman裡面，去查看整個資料結構是如何建立的~

### Library:
* [KingFisher](https://github.com/onevcat/Kingfisher.git)
