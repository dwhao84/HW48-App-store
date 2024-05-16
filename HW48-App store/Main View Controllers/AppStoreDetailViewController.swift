//
//  AppStoreDetailViewController.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/8.
//

import UIKit

class AppStoreDetailViewController: UIViewController, AppDetailTableViewCellDelegate {
    
    func appDetailTableViewCell(_ cell: AppDetailTableViewCell, didTapButton button: UIButton, buttonType: ButtonType) {
        guard tableView.indexPath(for: cell) != nil else { return }
        switch buttonType {
        case .functionBtn:
                    let content = "Share this App"
                    let url = URL(string: "")
            let activityVC = UIActivityViewController(activityItems: [content, url!], applicationActivities: nil)
                    self.present(activityVC, animated: true)
        case .shareBtn:
            print(" ")
        }
    }
    
    let tableView: UITableView = {
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
        
        // MARK: - HeaderView
        tableView.register(AppDetailHeaderView.nib(), forHeaderFooterViewReuseIdentifier: AppDetailHeaderView.identifier)
        
        // MARK: - TableViewCell
        // MARK: AppDetailTableViewCell
        tableView.register(AppDetailTableViewCell.self, forCellReuseIdentifier: AppDetailTableViewCell.identifier)
        
        // MARK: RatingTableViewCell
        tableView.register(RatingTableViewCell.self, forCellReuseIdentifier: RatingTableViewCell.identifier)
        
        // MARK: WhatIsNewTableViewCell
        tableView.register(WhatIsNewTableViewCell.self, forCellReuseIdentifier: WhatIsNewTableViewCell.identifier)
        
        // MARK: - tableView Setting:
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = true
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
    
    // MARK: TableViewCell:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // MARK: AppDetailTableViewCell
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AppDetailTableViewCell.identifier, for: indexPath) as! AppDetailTableViewCell
            cell.delegate = self
            return cell
        
        // MARK: RatingTableViewCell
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: RatingTableViewCell.identifier, for: indexPath) as! RatingTableViewCell
            return cell
            
        // MARK: WhatIsNewTableViewCell
        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: WhatIsNewTableViewCell.identifier, for: indexPath) as! WhatIsNewTableViewCell
            return cell
            
        } else if indexPath.row == 3 {
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 180
        } else if indexPath.row == 1 {
            return 100
        } else if indexPath.row == 2{
            return 150
        }
        return UITableView.automaticDimension
    }
    
    
    // MARK: - HeaderView:
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = AppDetailHeaderView()
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        print("DEBUG PRINT: deselectRow \(indexPath.row)")
    }
}
    
#Preview {
    UINavigationController(rootViewController: AppStoreDetailViewController())
}
