//
//  StudentStatusBoardViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/26.
//

import UIKit
import Alamofire

class StudentStatusBoardViewController: UIViewController {

    var model: StudentStatusBoardModel?
    
    @IBOutlet weak var comeStudentTableView: UITableView!
    @IBOutlet weak var notComeStudentTableView: UITableView!
    
    var comeStudentCount = 0
    var notComeStudentCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apiCall(grade: "one")
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
    
    func studentFilter() {
        
        comeStudentCount = 0
        notComeStudentCount = 0
        
        for i in 0 ..< (model?.oneData.count)! {
            if model?.oneData[i].check1 == 1 {
                comeStudentCount += 1
            } else {
                notComeStudentCount += 1
            }
        }
        
        print(comeStudentCount)
        print(notComeStudentCount)
        
        comeStudentTableView.reloadData()
        notComeStudentTableView.reloadData()
    }
    
    func apiCall(grade: String) {
        let URL = "http://10.120.75.224:3000/check/\(grade)"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let data = response.data else { return }
                self.model = try? JSONDecoder().decode(StudentStatusBoardModel.self, from: data)
                print(value)
                self.studentFilter()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension StudentStatusBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return comeStudentCount
        } else {
            return notComeStudentCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentStatusBoardTableViewCell", for: indexPath) as! StudentStatusBoardTableViewCell
        
        if tableView.tag == 1 && model?.oneData[indexPath.row].check1 == 1 {
            cell.studentName.text = model?.oneData[indexPath.row].student_name1 ?? ""
            cell.studentClassNumber.text = "\(model?.oneData[indexPath.row].student_data1 ?? 0)"
            print("a \(indexPath.row)")
        } else if tableView.tag == 2 && model?.oneData[indexPath.row].check1 == 0 {
            cell.studentName.text = model?.oneData[indexPath.row].student_name1 ?? ""
            cell.studentClassNumber.text = "\(model?.oneData[indexPath.row].student_data1 ?? 0)"
            print("b \(indexPath.row)")
        }
        
        return cell
    }
}

