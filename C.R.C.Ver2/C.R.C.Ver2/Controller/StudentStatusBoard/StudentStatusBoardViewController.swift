//
//  StudentStatusBoardViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/26.
//

import UIKit

class StudentStatusBoardViewController: UIViewController {

    @IBOutlet weak var comeStudentTableView: UITableView!
    @IBOutlet weak var notComeStudentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }

    func setting() {
        comeStudentTableView.delegate = self
        comeStudentTableView.dataSource = self
        comeStudentTableView.tag = 1
        comeStudentTableView.tableFooterView = UIView()
        comeStudentTableView.layer.cornerRadius = 10
        
        notComeStudentTableView.delegate = self
        notComeStudentTableView.dataSource = self
        notComeStudentTableView.tag = 2
        notComeStudentTableView.tableFooterView = UIView()
        notComeStudentTableView.layer.cornerRadius = 10
    }

}

extension StudentStatusBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentStatusBoardTableViewCell", for: indexPath) as! StudentStatusBoardTableViewCell
        
        return cell
    }
}

