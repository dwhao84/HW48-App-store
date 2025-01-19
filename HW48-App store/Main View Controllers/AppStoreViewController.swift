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
    private let viewModel = AppStoreViewModel()
    
    var freeAppsData: AppStore?
    var paidAppsData: AppStore?
    
    // MARK: - UI Setup:
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .customBackground
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let segmenteControl = {
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
        setupUI()
        setupBindings()
        viewModel.loadInitalData()
    }
    
    private func setupBindings() {
        viewModel.onFreeAppsDataUpdated = { [weak self] in
            self?.freeAppTableView.reloadData()
        }
        
        viewModel.onPaidAppsDataUpdated = { [weak self] in
            self?.paidAppTableView.reloadData()
        }
        
        viewModel.onPaidAppsPriceUpdated = { [weak self] in
            self?.paidAppTableView.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            // 顯示錯誤訊息
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.isLoading = { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Set up UI:
    func setupUI () {
        self.view.backgroundColor = Colors.CustomBackgroundColor
        
        freeAppTableView.isHidden = false
        paidAppTableView.isHidden = true
        
        addTargets()
        setNavigationView()
        addConstraints()
        
        configFreeTableView()
        configPaidTableView()
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
}

// MARK: - Extension:
extension AppStoreViewController: UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case paidAppTableView:
            return viewModel.getPaidAppCount()
        case freeAppTableView:
            return viewModel.getFreeAppCount()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case paidAppTableView:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PaidAppsTableViewCell.identifier,
                for: indexPath
            ) as! PaidAppsTableViewCell
            
            let appData = viewModel.getPaidApp(at: indexPath.row)
            cell.configure(appStoreData: appData.appData, iTunesPrice: appData.price)
            return cell
            
        case freeAppTableView:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: FreeAppsTableViewCell.identifier,
                for: indexPath
            ) as! FreeAppsTableViewCell
            
            if let appData = viewModel.getFreeApp(at: indexPath.row) {
                cell.configure(with: appData, index: indexPath.row)
            }
            return cell
            
        default:
            return UITableViewCell() // 預設的 cell，實際使用時可能不會遇到這種情況
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case paidAppTableView:
            if let selectedPaidAppId = paidAppsData?.feed.results[indexPath.row].id {
                showSKStoreProductVC(selectedID: selectedPaidAppId)
            }
            
        case freeAppTableView:
            if let selecteFreeAppStoreID = freeAppsData?.feed.results[indexPath.row].id {
                showSKStoreProductVC(selectedID: selecteFreeAppStoreID)
            }
            
        default:
            break
        }
    }
    
    func showSKStoreProductVC(selectedID: String) {
        let store = SKStoreProductViewController()
        store.delegate = self
        let parameters = [SKStoreProductParameterITunesItemIdentifier: selectedID]
        store.loadProduct(withParameters: parameters as [String : Any], completionBlock: nil)
        present(store, animated: true, completion: nil)
    }
}

#Preview {
    UINavigationController(rootViewController: AppStoreViewController())
}
