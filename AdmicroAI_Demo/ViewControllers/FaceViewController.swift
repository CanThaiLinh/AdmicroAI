//
//  FaceViewController.swift
//  AdmicroAI_Demo
//
//  Created by VietChat on 21/11/2023.
//

import UIKit
import AdmicroAI

class FaceViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var faceTypes: [FaceTypes] = FaceTypes.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Face"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
}

extension FaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return faceTypes[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return faceTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.titleLable.text = "\(faceTypes[indexPath.section])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectFaceType = faceTypes[indexPath.section]
        switch selectFaceType {
        case .FaceRegister, .FaceUpdate:
            let vc = FaceRegisterViewController()
            vc.titleHeader = selectFaceType.title
            vc.sectionTypes = selectFaceType
            navigationController?.pushViewController(vc, animated: true)
        case .FaceFilter:
            let vc = FaceFilterHistoryViewController()
            vc.titleHeader = selectFaceType.title
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = FaceDetailViewController()
            vc.titleHeader = selectFaceType.title
            vc.faceTypes = selectFaceType
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
