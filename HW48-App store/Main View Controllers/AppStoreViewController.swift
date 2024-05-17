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
    
    var freeAppsData: AppStore?
    var paidAppsData: AppStore?
    
    // Get the app's id from paidAppsData
    var freeAppId: String?
    var paidAppId: String?
    
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
        return btn
    } ()
    
    var refreshControl: UIRefreshControl = {
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.CustomTitleColor
        return refreshControl
    } ()
    
    // MARK: - Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
        
        fetchFreeAppsData()
        fetchPaidAppsData()
//        fetchITunesData()
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
        freeAppTableView.refreshControl = refreshControl
    }
    
    func configPaidTableView () {
        paidAppTableView.delegate   = self
        paidAppTableView.dataSource = self
        paidAppTableView.rowHeight = 100
        paidAppTableView.allowsSelection = true
        paidAppTableView.separatorStyle = .singleLine
        paidAppTableView.register(PaidAppsTableViewCell.self, forCellReuseIdentifier: PaidAppsTableViewCell.identifier)
        paidAppTableView.isScrollEnabled = true
        paidAppTableView.refreshControl = refreshControl
    }
    
    // MARK: - Add Targets:
    func addTargets () {
        segmenteControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(refreshControlActivited), for: .valueChanged)
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
    
    @objc func refreshControlActivited (_ sender: Any) {
        refreshControl.endRefreshing()
        print("DEBUG PRINT: refreshControl Activited ")
    }
        
    // MARK: - Result type:
    enum AppStoreDataFetchError: Error {
        case invalidURL        // URL failed
        case requestFailed     // request failed
        case responseFailed    // response failed
        case jsonDecodeFailed  // json decode failed
    }
    
    // MARK: - Fetch Free App Data:
    func fetchFreeAppsData() {
        let baseUrl: String = "https://rss.applemarketingtools.com/api/v2/tw/apps/top-free/25/apps.json"
        guard let url = URL(string: baseUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            print(String(data: data!, encoding: .utf8) ?? "Invalid data")
            
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("No data Received")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let appStoreDatas = try decoder.decode(AppStore.self, from: data)
                DispatchQueue.main.async {
                    self?.freeAppsData = appStoreDatas
                    self?.freeAppTableView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                print("Full error: \(error)")
            }
        }.resume()
    }
    
    // MARK: - Fetch Paid Apps:
    func fetchPaidAppsData() {
        let baseUrl: String = "https://rss.applemarketingtools.com/api/v2/tw/apps/top-paid/25/apps.json"
        guard let url = URL(string: baseUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            print(String(data: data!, encoding: .utf8) ?? "Invalid data")
            
            // Define error:
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            // Define httpResponse:
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            // Define data:
            guard let data = data else {
                print("No data Received")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let appStoreDatas = try decoder.decode(AppStore.self, from: data)
                DispatchQueue.main.async {
                                
                    self?.paidAppsData = appStoreDatas
                    self?.paidAppTableView.reloadData()
//                    self?.fetchITunesData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                print("Full error: \(error)")
            }
        }.resume()
    }
    
    // MARK: - Fetch iTunes data:
    func fetchITunesData () {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.query = "lookup?id=\(paidAppId!)&country=tw"
        let fullUrl = urlComponents.url
        let baseUrl = fullUrl
        
        guard let url =  baseUrl else {
            print("DEBUG PRINT: Unable to get baseUrl in fetch iTunes data")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
            
            let decoder = JSONDecoder()
            do {
                let urlData = try decoder.decode(iTunes.self, from: data)
                DispatchQueue.main.async {
                    self.paidAppPrice = urlData
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
            print("DEBUG PRINT: Paid App Data \(freeAppsData?.feed.results.count ?? 1)")
            return paidAppsData?.feed.results.count ?? 1
        } else {
            print("DEBUG PRINT: Free App Data \(paidAppsData?.feed.results.count ?? 1)")
            return freeAppsData?.feed.results.count ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView ==  paidAppTableView {
            print("DEBUG PRINT: cellForRowAt -> paidAppTableView")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PaidAppsTableViewCell.identifier, for: indexPath) as! PaidAppsTableViewCell
            
            let appStoreIndexPath = paidAppsData?.feed.results[indexPath.row]
            
            cell.appNameLabel.text       = appStoreIndexPath?.name
            cell.numberLabel.text        = String(indexPath.row + 1)
            cell.appDescripionLabel.text = appStoreIndexPath?.artistName
            
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
