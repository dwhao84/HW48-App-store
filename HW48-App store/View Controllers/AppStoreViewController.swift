//
//  AppStoreViewController.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/8.
//

import UIKit
import Kingfisher

class AppStoreViewController: UIViewController {
    
    let largetTitle: String = "Top Charts"
    
    var appStoreData: AppStore?
    
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
        fetchData()
        setupUI()
        
    }
    
    // MARK: - Set up UI:
    func setupUI () {
        self.view.backgroundColor = Colors.CustomBackgroundColor
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
    }
    
    // MARK: - Configure TableViews:
    func configFreeTableView () {
        freeAppTableView.delegate = self
        freeAppTableView.dataSource = self
        freeAppTableView.rowHeight = 100
        freeAppTableView.allowsSelection = true
        freeAppTableView.separatorStyle = .singleLine
        freeAppTableView.register(AppStoreTableViewCell.self, forCellReuseIdentifier: AppStoreTableViewCell.identifier)
        freeAppTableView.isScrollEnabled = true
        freeAppTableView.refreshControl = refreshControl
    }
    
    func configPaidTableView () {
        paidAppTableView.delegate = self
        paidAppTableView.dataSource = self
        paidAppTableView.rowHeight = 100
        paidAppTableView.allowsSelection = true
        paidAppTableView.separatorStyle = .singleLine
        paidAppTableView.register(AppStoreTableViewCell.self, forCellReuseIdentifier: AppStoreTableViewCell.identifier)
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
        view.addSubview(freeAppTableView)
        NSLayoutConstraint.activate([
            segmenteControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            segmenteControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20),
            segmenteControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmenteControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
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
            
        case 1:
            print("DEBUG PRINT: Switch to Paid App")
            paidAppTableView.isHidden = false
            freeAppTableView.isHidden = true
            
        default:
            break
        }
    }
    
    @objc func refreshControlActivited (_ sender: Any) {
        refreshControl.endRefreshing()
        print("DEBUG PRINT: refreshControl Activited ")
    }
    
    // MARK: - Fetch Data:
    func fetchData() {
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
                    self?.appStoreData = appStoreDatas
                    self?.freeAppTableView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                print("Full error: \(error)")
            }
        }.resume()
    }
}


// MARK: - Extension:
extension AppStoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(appStoreData?.feed.results.count ?? 1)")
        return appStoreData?.feed.results.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppStoreTableViewCell.identifier, for: indexPath) as! AppStoreTableViewCell
        
        let appStoreIndexPath = appStoreData?.feed.results[indexPath.row]
        cell.appNameLabel.text       = appStoreIndexPath?.name
        cell.numberLabel.text        = String(indexPath.row + 1)
        cell.appDescripionLabel.text = appStoreIndexPath?.artistName
        
        if let imageURL = appStoreIndexPath?.artworkUrl100, let url = URL(string: imageURL) {
            cell.iconImageView.kf.setImage(with: url)
            print("DEBUG PRINT: Kingfisher is working.")
        } else {
            cell.iconImageView.image = UIImage(named: "01.png")
            print("DEBUG PRINT: Kingfisher is not working.")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG PRINT: Selected INDEX \(indexPath.row)")
    }
}

#Preview {
    UINavigationController(rootViewController: AppStoreViewController())
}
