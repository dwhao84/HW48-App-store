//
//  AppStoreViewController.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/8.
//

import UIKit

class AppStoreViewController: UIViewController {

    let largetTitle: String = "Top Charts"
    
    var segmenteControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Free App", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Paid App", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    } ()
    
    var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
    var containerView : UIView = {
        let containerView: UIView = UIView()
        
        return containerView
    } ()
     
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
        
    func setupUI () {
        segmenteControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        setNavigationView()
        addConstraints()
        configureTableView()
        self.view.backgroundColor = .white
    }

    func setNavigationView () {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = largetTitle
    }
    
    func configureTableView () {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
    }
    
    func addConstraints () {
        view.addSubview(segmenteControl)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            segmenteControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmenteControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:20),
            segmenteControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmenteControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmenteControl.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func segmentedControlValueChanged (_ sender: UISegmentedControl) {
        
        switch segmenteControl.selectedSegmentIndex {
        case 0:
            print("DEBUG PRINT: Switch to Free App")
            
        case 1:
            print("DEBUG PRINT: Switch to Paid App")
            
            
        default:
            break
        }
    }
    
}


extension AppStoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}

#Preview {
    UINavigationController(rootViewController: AppStoreViewController())
}
