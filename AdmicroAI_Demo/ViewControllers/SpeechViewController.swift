//
//  SpeechViewController.swift
//  AdmicroAI_Demo
//
//  Created by VietChat on 21/11/2023.
//

import UIKit

class SpeechViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var speechTypes: [SpeechTypes] = SpeechTypes.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Speech To Text"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        activityView.isHidden = true
    }
}

extension SpeechViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return speechTypes[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return speechTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.titleLable.text = speechTypes[indexPath.section].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectSpeechTypes = speechTypes[indexPath.section]
        switch selectSpeechTypes {
        case .SpeechToText:
            let vc = SpeechDetailViewController()
            vc.titleHeader = selectSpeechTypes.title
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = SpeechTTSViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
