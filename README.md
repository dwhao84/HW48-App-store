<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/08d1d4652c2408d548b139ec4a57c3d31c2d9d1e/HW48-App%20store/Supporting%20FIles/Assets.xcassets/AppStore_Banner.imageset/AppStore_Banner.jpg" width="700" height="450"/>
</p>
#  HW#48 - App Store 

這次的練習，主要是練習如何串接App store的API，顯示App store榜上25個熱門的Apps，再利用`Segmented Control`切換付費版以及免費版的內容。

[#6 App Store 的 Free Apps / Paid Apps 排行榜](https://medium.com/彼得潘的真實-ios-app-畫面功能復刻/6-app-store-的-free-apps-paid-apps-排行榜-87678082fa80)

## 功能和畫面需求:
* 利用 `segmented control` 切換 Free Apps / Paid Apps 列表
* 從 RSS Feed Generator API 取得 App 排行榜
* 點選列表的 App 後顯示 App 的詳細頁面，串接 iTunes Search API
* 利用 `SKStoreProductViewController` 顯示 App 的購買頁面
* 支援Dark Mode

## 利用 segmented control 切換 Free Apps / Paid Apps 列表:
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

* 設定tableView內容，依照不同的tableView連接不同tableViewCell，並加上`refreshControl` 。

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

* 設定`freeAppsTableViewCell` & `paidAppsTableViewCell`:
### FreeAppsTableViewCell:

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

#### PaidAppsTableViewCell:

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

* 利用Closure的寫法，建立 `segmentedControl`。
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

* `segmentedControl` 加上addTarget ，以確保`segmentedControl`有連上`segmentedControlValueChanged`的method。
```
segmenteControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
```

* 用 `@objc func`的寫法，建立`segmentedControlValueChanged`，再用`sender.selectedSegmentIndex`來切換不同tableView的內容，當case等於0的時候，顯示`freeAppTableView`；當case 為1時，顯示`paidAppTableView`。

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

[利用多個 container view切換頁面](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用多個-container-view-切換頁面-6d00fe848572)


## 從 RSS Feed Generator API 取得 App 排行榜:

<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/tree/98ae975008a9fc5874c686f9d21b8618487be15c/HW48-App%20store/Supporting%20FIles/Assets.xcassets/Demo%20Gif/HW48_AppStore_tableView.dataset" width="385" height="800"/>
</p>

這次的API是由RSS Feed Generator裡面找到的，裡面可以找到各個國家的各種資料(書籍 / App / Music / 廣播)，並且運用設定好的參數產生一個API，並且顯示你要的資料。

<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/08d1d4652c2408d548b139ec4a57c3d31c2d9d1e/HW48-App%20store/Supporting%20FIles/Assets.xcassets/README%20Img%20Source/RSS%20Builder.imageset/CleanShot%202024-06-02%20at%2000.00.07%402x.png" width="700" height="450"/>
</p>

[RSS Feed Generator](https://medium.com/r?url=https%3A%2F%2Frss.applemarketingtools.com%2F)

這次主要是使用App Store排名前25個App的內容，做為練習，所以首先分別建立兩個不同的API網址，在`AppViewController`裡面。

```
private let freeAppStoreUrl: String = "https://rss.applemarketingtools.com/api/v2/tw/apps/top-free/25/apps.json"
private let paidAppStoreUrl: String = "https://rss.applemarketingtools.com/api/v2/tw/apps/top-paid/25/apps.json"
```

再來建議解析API的資料結構，我們可以把API網址貼到Postman裡面，去查看整個資料結構是如何建立的~
<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/73c53f55d6cff685e61db6a6937f18ca17e3bad3/HW48-App%20store/Supporting%20FIles/Assets.xcassets/README%20Img%20Source/Postman_FreeApp.imageset/CleanShot%202024-06-02%20at%2012.17.16%402x.png" width="700" height="450"/>
</p>
<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/73c53f55d6cff685e61db6a6937f18ca17e3bad3/HW48-App%20store/Supporting%20FIles/Assets.xcassets/README%20Img%20Source/Postman_PaidApp.imageset/CleanShot%202024-06-02%20at%2012.14.57%402x.png" width="700" height="450"/>
</p>

下列為解析完的資料結構。
```
import UIKit

/*
 // Paid:
 https://rss.applemarketingtools.com/api/v2/tw/apps/top-paid/25/apps.json
 // Free:
 //https://rss.applemarketingtools.com/api/v2/tw/apps/top-free/25/apps.json
 
 因此若想在列表顯示價錢，必須用 App ID 搭配 iTunes Search API 查詢 App 的詳細資料。
 比方 App ID 是 1164801111，查詢詳細資料的網址如下:
 https://itunes.apple.com/lookup?id=1164801111&country=tw
 */

struct AppStore: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let title: String
    let id: String
    let author: Author
    let links: [Link]
    let copyright: String
    let country: String
    let icon: String
    let updated: String
    let results: [Result]
}

struct Author: Codable {
    let name: String
    let url: String
}

struct Link: Codable {
    let linksSelf: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

struct Result: Codable {
    let artistName: String
    let id: String
    let name: String
    let releaseDate: String?
    let kind: String
    let artworkUrl100: String
    let url: String
}
```

再來，就是運用之前所學的`URLSesson.shared.dataTask`的方式，再將API網址用JSON
Decoder的方式解析網頁資料，在之前的練習的時候，我沒用到`Result type`的寫法，但在這次的練習當中，
我有運用到`Result type`的寫法，因為用了`Resulttype`的寫法，比較好抓到當網路沒辦法串接時的問題所在，可以有效知道是在哪個環節出了問題，是在Data端呢? 還是在`httpResponse`出現了問題? 還是在網址的地方撰寫錯了? 都可以從`Result type`的寫法，
清楚的知道整個網路串接的狀況。在這段程式中，最後會將Decode過後的`appStoreDatas`儲存到我設定的`freeAppsData`裡面，以便將儲存好的資料內容，把資料顯示在未來的tableView上面。

```
var freeAppsData: AppStore?
```

FetchFreeAppsData:
```
// MARK: - Fetch Free App Data:
    func fetchFreeAppsData(url: String, completion: @escaping (Result<AppStore, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            print("Unable to fetchFreeApps url")
            completion(.failure(.wrongURL))
            return
        }
        
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            DispatchQueue.main.async { self?.activityIndicator.stopAnimating() }
            
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Unable to get response")
                completion(.failure(.unexpectedStatusCode))
                return
            }
            
            guard let data = data else {
                print("Unable to get data")
                completion(.failure(.noDataReceived))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let appStoreDatas = try decoder.decode(AppStore.self, from: data)
                self?.freeAppsData = appStoreDatas
                completion(.success(appStoreDatas))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
```

再來就是建立`Result type`時，可以用表格的方式理解，當Networking進行的時候會遇到不同的狀態，而Networking的結果，會用enum切換狀態，
所以會有下面那段程式的寫法。

```
// MARK: - Result type:
    enum Result<Value, Error: Swift.Error> {
        case success(Value)
        case failure(Error)
    }
    
    enum NetworkError: Error {
        case wrongURL
        case requestFailed
        case decodeError
        case unexpectedStatusCode
        case noDataReceived
    }
```

再來是call這個function的result，放到viewDidLoad裡面去建立，當case是success的時候，則讓資料會存到`freeAppsData`裡面。
```
switch result {
            case .success(let appStoreData):
                self.freeAppsData = appStoreData
```
當case為failure時，則產生error。
```
fetchFreeAppsData(url: freeAppStoreUrl) { result in
            switch result {
            case .success(let appStoreData):
                self.freeAppsData = appStoreData
                DispatchQueue.main.async {
                    self.freeAppTableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch free apps data: \(error)")
            }
        }
```

* 最後總結一下`Result type`的特性:
1. 可以將非同步程式執行中所遇到的錯誤回傳出來
1. 以更安全的方式處理錯誤
1. 提高程式可讀以及更容易維護
1. 不會有模稜兩可的狀態，只有 Success 跟 Failure 兩種狀態

> Reference:
* URLSession: 

[模仿 Apple 官方範例串接 JSON API，定義 function 型別的 completion 參數 & 使用 Result type](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/模仿-apple-官方範例串接-json-api-定義-function-型別的-completion-參數-使用-result-type-9b058c77df5d)


* Result type:

[成功和失敗二擇一的 Result type](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/成功和失敗二擇一的-result-type-e234c6fccc9c)
[非黑即白的 Result type](https://hackmd.io/@leoho0722/r1ICGuQxo)

## 點選列表的 App 後顯示 App 的詳細頁面，串接 iTunes Search API:

<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/98ae975008a9fc5874c686f9d21b8618487be15c/HW48-App%20store/Supporting%20FIles/Assets.xcassets/Demo%20Gif/HW48_AppStore_Show%20paidApp%20price.dataset/HW48_App%20Store_Show%20paidApp%20price.gif" width="385" height="800"/>
</p>

---

由於我要從上方 `fetch paid App` 的data中取得App id ，並透過iTunes API去找到付費App的各項資料，所以要先建立一個 `paidAppsId` ，作為存取App id裡字串的陣列。
```
var paidAppsId: [String]?
```

再來就是，建立一個叫`paidAppPrice`的變數，為iTunes的型別。
```
var paidAppPrice: iTunes?
```

由於我先隨便套用了一個app id作為Postman測試，看看能不能從中取到app的price，看來是可以。

<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/73c53f55d6cff685e61db6a6937f18ca17e3bad3/HW48-App%20store/Supporting%20FIles/Assets.xcassets/README%20Img%20Source/Postman_iTunes.imageset/CleanShot%202024-06-02%20at%2018.39.54%402x.png" width="700" height="450"/>
</p>

再來就是建立iTunes的資料結構。
```
import UIKit

struct iTunes: Codable {
    let resultCount: Int
    let results: [Results]
}

struct Results: Codable {
    let screenshotUrls: [String]
    let ipadScreenshotUrls: [String]
    let artworkUrl60: String
    let artworkUrl512: String
    let supportedDevices: [String]
    let releaseNotes: String?       // Add Optional
    let price: Double
    
    
    // 確保每個key都會被找到
    enum CodingKeys: String, CodingKey {
        case price              = "price"
        case screenshotUrls     = "screenshotUrls"
        case ipadScreenshotUrls = "ipadScreenshotUrls"
        case artworkUrl60       = "artworkUrl60"
        case artworkUrl512      = "artworkUrl512"
        case supportedDevices   = "supportedDevices"
        case releaseNotes       = "releaseNotes"
    }
}
```

再來就是建立fetchITunesData的method，為了得到各項付費App的資料，
所以我們要用組合URLComponents的寫法，透組合好的網址找到各項App的資料，我們最主要調整的內容會是query的內容，因爲參數最主要是在這邊做更動。

```
  var urlComponents = URLComponents()
  urlComponents.host   = "itunes.apple.com"
  urlComponents.scheme = "https"
  urlComponents.path   = "/lookup"
  
  // 将 paidAppsId 数组转换为逗号分隔的字符串
  let idsString = paidAppsId.joined(separator: ",")
  urlComponents.query = "id=\(idsString)&country=tw"
  let appsUrl = urlComponents.url
  print("\(appsUrl!)")
```

建立好URLComponents，就可以將不同字串的陣列內容帶到，URLComponents的url裡面，由於paidAppsId是一個字串的陣列，所以需要將資料加工一下，我就將陣列的內容用`joined(separator:)`的這個方法，將資料內容加上seperator，這樣就有辦法確保URLComponents的內容，可以產生每個App的API網址，然後再用`URLSession.shared.dataTask`的寫法取得所有App的價格。
```
// MARK: - Fetch iTunes data:
        func fetchITunesData() {
            guard let paidAppsId = paidAppsId, !paidAppsId.isEmpty else {
                print("paidAppsId is nil")
                return
            }

            var urlComponents = URLComponents()
            urlComponents.host   = "itunes.apple.com"
            urlComponents.scheme = "https"
            urlComponents.path   = "/lookup"
            
            // 将 paidAppsId 数组转换为逗号分隔的字符串
            let idsString = paidAppsId.joined(separator: ",")
            urlComponents.query = "id=\(idsString)&country=tw"
            let appsUrl = urlComponents.url
            print("\(appsUrl!)")

            guard let url = appsUrl else {
                print("DEBUG PRINT: Unable to get baseUrl in fetch iTunes data")
                return
            }

            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                print(String(data: data!, encoding: .utf8) ?? "Invalid data")

                // Define error
                if let error = error {
                    print("DEBUG PRINT: Error fetching iTunes data: \(error.localizedDescription)")
                    return
                }

                // Define httpResponse
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Error with response, unexpected status code: \(String(describing: response))")
                    return
                }

                // Define data:
                guard let data = data else {
                    print("DEBUG PRINT: No iTunes data Received")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let iTunesData = try decoder.decode(iTunes.self, from: data)
                    DispatchQueue.main.async {
                        self?.paidAppPrice = iTunesData
                        
                        print("Prices: \(String(describing: self?.paidAppPrice))")
                    }
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                    print("Full error: \(error)")
                }
            }.resume()
        }
```

取得App的價格資料，我們再用tableViewDataSource的`indexPath.row`去找到對應的App的價格，從我們建立的變數中 `paidAppPrice?.results[indexPath.row].price` 裡面去找資料。
```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView ==  paidAppTableView {
            print("DEBUG PRINT: cellForRowAt -> paidAppTableView")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PaidAppsTableViewCell.identifier, for: indexPath) as! PaidAppsTableViewCell
            
            let appStoreIndexPath    = paidAppsData?.feed.results[indexPath.row]
            let iTunesPriceIndexPath = paidAppPrice?.results[indexPath.row].price
            
            cell.appNameLabel.text       = appStoreIndexPath?.name
            cell.numberLabel.text        = String(indexPath.row + 1)
            
            if let price = iTunesPriceIndexPath {
                  let boldText = NSAttributedString(string: "NT$\(price)", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
                  cell.priceBtn.setAttributedTitle(boldText, for: .normal)
              } else {
                  let boldText = NSAttributedString(string: "Loading", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
                  cell.priceBtn.setAttributedTitle(boldText, for: .normal)
              }
            
            cell.priceBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            
            if let imageURL = appStoreIndexPath?.artworkUrl100, let url = URL(string: imageURL) {
                cell.iconImageView.kf.setImage(with: url)
                print("DEBUG PRINT: paidAppTableView's Kingfisher is working.")
            } else {
                cell.iconImageView.image = UIImage(named: "01.png")
                print("DEBUG PRINT: paidAppTableView's Kingfisher is not working.")
            }
            return cell
            
        } else {
            
            print("DEBUG PRINT: cellForRowAt -> freeAppTableView")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FreeAppsTableViewCell.identifier, for: indexPath) as! FreeAppsTableViewCell
            
            let appStoreIndexPath = freeAppsData?.feed.results[indexPath.row]
            cell.appNameLabel.text       = appStoreIndexPath?.name
            cell.numberLabel.text        = String(indexPath.row + 1)
            cell.appDescripionLabel.text = appStoreIndexPath?.artistName
            
            if let imageURL = appStoreIndexPath?.artworkUrl100, let url = URL(string: imageURL) {
                cell.iconImageView.kf.setImage(with: url)
                print("DEBUG PRINT: freeAppTableView's Kingfisher is working.")
            } else {
                cell.iconImageView.image = UIImage(named: "01.png")
                print("DEBUG PRINT: freeAppTableView's Kingfisher is not working.")
            }
            return cell
        }
    }
```

> Reference:
* URLComponents:
1. [使用 baseURL，URLComponents & URLQueryItem 產生URL](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-baseurl-urlcomponents-urlqueryitem-產生-url-1e4539a33a89) 
1. [URLComponents](https://developer.apple.com/documentation/foundation/urlcomponents?source=post_page-----1e4539a33a89--------------------------------)
1. [joined(separator:)](https://developer.apple.com/documentation/swift/array/joined(separator:)-7uber)


## 利用 SKStoreProductViewController 顯示 App 的購買頁面:
<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/98ae975008a9fc5874c686f9d21b8618487be15c/HW48-App%20store/Supporting%20FIles/Assets.xcassets/Demo%20Gif/HW48_AppStore_Show%20StoreKit.dataset/HW48_Show%20StoreKit.gif" width="385" height="800"/>
</p>

* Import StoreKit
```
import StoreKit
```

* 運用tableView's delegate裡的`didSelectRowAt`，當paidAppTableView的內容被選取時，建立一個常數為`selectedPaidId`，做為存取paidApps裡面的id值，並且將得到的id傳到`SKStoreProductParameterITunesItemIdentifier`裡面，就透過可以用`SKStoreProductViewController`顯示App的細項。
要注意的事情是，這個`SKStoreProductViewController`，只能在實機測試，在Simulator(模擬器)裡是跑不出來的；下方有完整的Apple文件可以參考，還蠻好懂的！
```
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == paidAppTableView {
            
            let selectedPaidAppId = paidAppsData?.feed.results[indexPath.row].id
            
            print("DEBUG PRINT: Selected INDEX \(indexPath.row)")
            print("DEBUG PRINT: \(selectedPaidAppId ?? "")")
            
            let store = SKStoreProductViewController()
            store.delegate = self
            
            let parameters = [SKStoreProductParameterITunesItemIdentifier: selectedPaidAppId]
            store.loadProduct(withParameters: parameters as [String : Any], completionBlock: nil)
            present(store, animated: true, completion: nil)
            
        } else if tableView == freeAppTableView {
            
            let selectedPaidAppId = freeAppsData?.feed.results[indexPath.row].id
            
            print("DEBUG PRINT: Selected INDEX \(indexPath.row)")
            print("DEBUG PRINT: \(selectedPaidAppId ?? "")")
            
            let store = SKStoreProductViewController()
            store.delegate = self
            
            let parameters = [SKStoreProductParameterITunesItemIdentifier: selectedPaidAppId]
            store.loadProduct(withParameters: parameters as [String : Any], completionBlock: nil)
            present(store, animated: true, completion: nil)
        }
    }
```

> Reference:
* Offering media for sale in your app: 

[Offering media for sale in your app](https://developer.apple.com/documentation/storekit/offering_media_for_sale_in_your_app)


## 支援Dark Mode:
<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/98ae975008a9fc5874c686f9d21b8618487be15c/HW48-App%20store/Supporting%20FIles/Assets.xcassets/Demo%20Gif/HW48_AppStore_Support%20DarkMode.dataset/HW48_AppStore_Support%20DarkMode.gif" width="385" height="800"/>
</p>

用Struct的方式建立Colors的data，並用`static let`的方式建立`CustomBackgroundColor`，以便使用這個`Colors.CustomBackgroundColor`的方法去呈現，根據是否為Dark mode的狀態去調整背景及字體顏色。

```
import UIKit

struct Colors {
    static let CustomTitleColor: UIColor      = UIColor(named: "CustomColor") ?? UIColor.white
    static let CustomBackgroundColor: UIColor = UIColor(named: "CustomBackgroundColor") ?? Colors.black
}
```

<p align="center">
<img src="https://github.com/dwhao84/HW48-App-store/blob/57b5f0f6265633d50ea13dabc57aa0cf68c88456/HW48-App%20store/Supporting%20FIles/Assets.xcassets/README%20Img%20Source/Setup%20Dark%20Mode.imageset/CleanShot%202024-06-01%20at%2019.57.11%402x.png" width="700" height="450"/>
</p>


> Reference:
* Supporting Dark Mode in Your Interface

[Supporting Dark Mode in Your Interface](https://developer.apple.com/documentation/uikit/appearance_customization/supporting_dark_mode_in_your_interface)
* StackOverflow:

[How do I easily support light and dark mode with a custom color used in my app?](https://stackoverflow.com/questions/56487679/how-do-i-easily-support-light-and-dark-mode-with-a-custom-color-used-in-my-app)

### Library:
* [KingFisher](https://github.com/onevcat/Kingfisher.git)
