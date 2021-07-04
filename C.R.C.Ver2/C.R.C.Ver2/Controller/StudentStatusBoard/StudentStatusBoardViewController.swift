//
//  StudentStatusBoardViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/26.
//

import UIKit
import Alamofire

class StudentStatusBoardViewController: UIViewController {
    
    enum StudentGrade: String {
        case One = "one"
        case Two = "two"
        case Three = "three"
    }
    
    var model: StudentStatusBoardModel?
    
    var studentGrade: StudentGrade = .One
    
    @IBOutlet weak var comeStudentTableView: UITableView!
    @IBOutlet weak var notComeStudentTableView: UITableView!
    
    @IBOutlet weak var comeStudentTotalCountLabel: UILabel!
    @IBOutlet weak var notComeStudentTotalCountLabel: UILabel!
    
    var comeStudentName = [String]()
    var comeStudentClassNumber = [Int]()
    
    var notComeStudentName = [String]()
    var notComeStudentClassNumber = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apiCall(grade: studentGrade.rawValue)
    }
    
    @IBAction func studentGradeSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            studentGrade = StudentGrade.One
            apiCall(grade: studentGrade.rawValue)
        case 1:
            studentGrade = StudentGrade.Two
            apiCall(grade: studentGrade.rawValue)
        case 2:
            studentGrade = StudentGrade.Three
            apiCall(grade: studentGrade.rawValue)
        default:
            return
        }
    }
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        apiCall(grade: studentGrade.rawValue)
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
        comeStudentName.removeAll()
        comeStudentClassNumber.removeAll()
        
        notComeStudentName.removeAll()
        notComeStudentClassNumber.removeAll()
        
        for i in 0 ..< (model?.data.count ?? 0) {
            if model?.data[i].student_check == 1 {
                comeStudentName.append(model?.data[i].student_name ?? "")
                comeStudentClassNumber.append(model?.data[i].student_data ?? 0)
            } else {
                notComeStudentName.append(model?.data[i].student_name ?? "")
                notComeStudentClassNumber.append(model?.data[i].student_data ?? 0)
            }
        }
        
        comeStudentTableView.reloadData()
        notComeStudentTableView.reloadData()
        
        comeStudentTotalCountLabel.text = "\(comeStudentName.count)"
        notComeStudentTotalCountLabel.text = "\(notComeStudentName.count)"
    }
    
    func apiCall(grade: String) {
        let URL = "http://192.168.43.203:3000/check/\(grade)"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let data = response.data else { return }
                self.model = try? JSONDecoder().decode(StudentStatusBoardModel.self, from: data)
                self.studentFilter()
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension StudentStatusBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("2222")
        return tableView.tag == 1 ? comeStudentName.count : notComeStudentName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentStatusBoardTableViewCell", for: indexPath) as! StudentStatusBoardTableViewCell
        if tableView.tag == 1 {
            cell.studentName.text = comeStudentName[indexPath.row]
            cell.studentClassNumber.text = "\(comeStudentClassNumber[indexPath.row])"
            print("0000")
            
        } else if tableView.tag == 2 {
            cell.studentName.text = notComeStudentName[indexPath.row]
            cell.studentClassNumber.text = "\(notComeStudentClassNumber[indexPath.row])"
            print("1111")
        }
        
        return cell
    }
}

