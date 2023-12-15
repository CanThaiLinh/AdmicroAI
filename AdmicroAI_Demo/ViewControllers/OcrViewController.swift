//
//  OcrViewController.swift
//  AdmicroAI_Demo
//
//  Created by VietChat on 21/11/2023.
//

import UIKit

class OcrViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var orcTypes: [OCRTypes] = OCRTypes.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ORC"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
}

extension OcrViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return orcTypes[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orcTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.titleLable.text = orcTypes[indexPath.section].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = OCRDetailViewController()
        vc.titleHeader = orcTypes[indexPath.section].title
        vc.ocrTypes = orcTypes[indexPath.section]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
