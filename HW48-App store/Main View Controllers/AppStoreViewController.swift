//
//  AppStoreViewController.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/8.
//

import UIKit
import Kingfisher
import StoreKit

class AppStoreViewController: UIViewController {
    
    let largetTitle: String = "Top Charts"
    
    private let freeAppStoreUrl: String = "https://rss.applemarketingtools.com/api/v2/tw/apps/top-free/25/apps.json"
    private let paidAppStoreUrl: String = "https://rss.applemarketingtools.com/api/v2/tw/apps/top-paid/25/apps.json"
    
    var freeAppsData: AppStore?
    var paidAppsData: AppStore?

    var activityIndicator: UIActivityIndicatorView!
    
    var paidAppsId: [String]?
    var paidAppPrice: iTunes?
    
    // MARK: - UI Setup:
    var segmenteControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Free App", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Paid App", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    } ()
    
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
    
    var allAppBtn: UIButton = {
        let btn: UIButton = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.title = "All Apps"
        config.baseForegroundColor = Colors.blue
        btn.configuration = config
        
        btn.configurationUpdateHandler = { btn in
            btn.alpha = btn.isHighlighted ? 0.5 : 1
        }
        return btn
    } ()
    
    var freeTableViewRefreshControl: UIRefreshControl = {
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.CustomTitleColor
        return refreshControl
    } ()
    
    var paidTableViewRefreshControl: UIRefreshControl = {
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.CustomTitleColor
        return refreshControl
    } ()
    
    
    // MARK: - Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        
        self.freeAppTableView.addSubview(activityIndicator)
        self.paidAppTableView.addSubview(activityIndicator)
        
        setupUI()
        
        fetchITunesData()
    }
    
    // MARK: - Set up UI:
    func setupUI () {
        
        freeAppTableView.isHidden = false
        paidAppTableView.isHidden = true
        
        self.view.backgroundColor = Colors.CustomBackgroundColor
        addTargets()
        setNavigationView()
        addConstraints()
        
        configFreeTableView()
        configPaidTableView()
        
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

        fetchPaidAppsData(url: paidAppStoreUrl) { result in
            switch result {
            case .success(let data):
                self.paidAppsData = data
                self.paidAppsId   = data.feed.results.map { $0.id } // 取得所有的Paid App的id
                
                print("\(self.paidAppsId!)")
                
                DispatchQueue.main.async {
                    self.paidAppTableView.reloadData()
                    self.fetchITunesData()
                }
            case .failure(let error):
                print("Failed to fetch paid apps data: \(error)")
            }
        }
    }
    
    
    // MARK: - Set up NavigationView:
    func setNavigationView () {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = largetTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: allAppBtn)
        
        // Add appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Colors.clear
        
        let scrollingAppearance = UINavigationBarAppearance()
        scrollingAppearance.configureWithTransparentBackground()
        scrollingAppearance.backgroundColor = Colors.clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
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
    
    // MARK: - Add Targets:
    func addTargets () {
        segmenteControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        allAppBtn.addTarget(self, action: #selector(allAppsBtn), for: .touchUpInside)
        
        freeTableViewRefreshControl.addTarget(self, action: #selector(freeTableViewRefreshControlActivited), for: .valueChanged)
        paidTableViewRefreshControl.addTarget(self, action: #selector(paidTableViewRefreshControlActivited), for: .valueChanged)
    }
    
    // MARK: - Add Constraints:
    func addConstraints () {
        view.addSubview(segmenteControl)
        NSLayoutConstraint.activate([
            segmenteControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            segmenteControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20),
            segmenteControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmenteControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        view.addSubview(freeAppTableView)
        NSLayoutConstraint.activate([
            freeAppTableView.topAnchor.constraint(equalTo: segmenteControl.bottomAnchor, constant: 20),
            freeAppTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            freeAppTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            freeAppTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // paidAppTableVIew
        view.addSubview(paidAppTableView)
        NSLayoutConstraint.activate([
            paidAppTableView.topAnchor.constraint(equalTo: segmenteControl.bottomAnchor, constant: 20),
            paidAppTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paidAppTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paidAppTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
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
    
    @objc func freeTableViewRefreshControlActivited (_ sender: Any) {
        freeTableViewRefreshControl.endRefreshing()
        print("DEBUG PRINT: refreshControl Activited")
    }
    
    @objc func paidTableViewRefreshControlActivited (_ sender: Any) {
        paidTableViewRefreshControl.endRefreshing()
        print("DEBUG PRINT: refreshControl Activited")
    }
    
    @objc func allAppsBtn (_ sender: UIBarButtonItem) {
        print("DEBUG PRINT: allAppsBtn")
    }
        
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
    
    // MARK: - Fetch Paid Apps:
    func fetchPaidAppsData(url: String, completion: @escaping (Result<AppStore, NetworkError>) -> Void) {

        guard let url = URL(string: paidAppStoreUrl) else { return }
        
        // 當資料尚未讀取時，activity Indicator是轉動的
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            print(String(data: data!, encoding: .utf8) ?? "Invalid data")
            
            // 當網路連接後，activity Indicator停止轉動。
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
            // Define error:
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            // Define httpResponse:
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Unable to fetchPaidApps response")
                 completion(.failure(.unexpectedStatusCode))
                 return
             }
            
            // Define data:
            guard let data = data else {
                print("Unable to fetchPaidApps data")
                completion(.failure(.noDataReceived))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let appStoreDatas = try decoder.decode(AppStore.self, from: data)
                self?.paidAppsId = appStoreDatas.feed.results.map { $0.id }
                print("PRINT All the id in do catch \(String(describing: self?.paidAppsId!))")
                
                completion(.success(appStoreDatas))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
    
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
}

// MARK: - Extension:
extension AppStoreViewController: UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == paidAppTableView {
            print("DEBUG PRINT: Paid App Data \(paidAppsData?.feed.results.count ?? 1)")
            return paidAppsData?.feed.results.count ?? 0
        } else {
            print("DEBUG PRINT: Free App Data \(freeAppsData?.feed.results.count ?? 1)")
            return freeAppsData?.feed.results.count ?? 0
        }
    }
    
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
}

#Preview {
    UINavigationController(rootViewController: AppStoreViewController())
}


// TEST
