//
//  AppStoreDetailViewController.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/8.
//

import UIKit

class AppStoreDetailViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
    let ratingTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI () {
        setupTableView()
        addConstraints()
    }
    
    func setupTableView () {
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.register(AppDetailHeadView.nib(), forHeaderFooterViewReuseIdentifier: AppDetailHeadView.identifier)
        
        tableView.register(AppDetailTableViewCell.self, forCellReuseIdentifier: AppDetailTableViewCell.identifier)
        
        tableView.rowHeight = 180
        tableView.allowsSelection = false
    }
    
    func addConstraints () {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension AppStoreDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableView:
            print("DEBUG PRINT: numberOfRowsInSection is 1")
            return 1
        default:
            break
        }
        print("DEBUG PRINT: numberOfRowsInSection is 0")
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailTableViewCell.identifier, for: indexPath) as! AppDetailTableViewCell
            return cell
            
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = AppDetailHeadView()
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        180
    }
    
}

#Preview {
    UINavigationController(rootViewController: AppStoreDetailViewController())
}
