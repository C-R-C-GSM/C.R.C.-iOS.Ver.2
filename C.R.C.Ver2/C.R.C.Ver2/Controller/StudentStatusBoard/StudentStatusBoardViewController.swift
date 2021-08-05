//
//  StudentStatusBoardViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/26.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class StudentStatusBoardViewController: UIViewController {
    
    enum StudentGrade: String {
        case One = "one"
        case Two = "two"
        case Three = "three"
    }
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    var model: StudentStatusBoardModel?
    
    var studentGrade: StudentGrade = .One
    
    var comeStudentName = [String]()
    var comeStudentClassNumber = [Int]()
    
    var notComeStudentName = [String]()
    var notComeStudentClassNumber = [Int]()
    
    @IBOutlet weak var comeStudentTableView: UITableView!
    @IBOutlet weak var notComeStudentTableView: UITableView!
    
    @IBOutlet weak var comeStudentTotalCountLabel: UILabel!
    @IBOutlet weak var notComeStudentTotalCountLabel: UILabel!
    
    @IBOutlet weak var studentGradeSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        indicatorAutolayout()
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
    @IBAction func refreshButton(_ sender: UIButton) {
        apiCall(grade: studentGrade.rawValue)
    }
    
    func setting() {
        comeStudentTableView.delegate = self
        comeStudentTableView.dataSource = self
        comeStudentTableView.tag = 1
        comeStudentTableView.tableFooterView = UIView()
        comeStudentTableView.layer.cornerRadius = 10
        comeStudentTableView.layer.borderWidth = 0.5
        comeStudentTableView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        
        notComeStudentTableView.delegate = self
        notComeStudentTableView.dataSource = self
        notComeStudentTableView.tag = 2
        notComeStudentTableView.tableFooterView = UIView()
        notComeStudentTableView.layer.cornerRadius = 10
        notComeStudentTableView.layer.borderWidth = 0.5
        notComeStudentTableView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        
        studentGradeSegmentedControl.backgroundColor = .white
        studentGradeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.267, green: 0.267, blue: 0.267, alpha: 0.2)], for: .normal)
        studentGradeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        studentGradeSegmentedControl.clearBG()
        
        studentGradeSegmentedControl.layer.borderWidth = 0.3
        studentGradeSegmentedControl.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        
        studentGradeSegmentedControl.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03).cgColor
        studentGradeSegmentedControl.layer.shadowOpacity = 1
        studentGradeSegmentedControl.layer.shadowRadius = 10
        studentGradeSegmentedControl.layer.shadowOffset = CGSize(width: 2, height: 1)
        studentGradeSegmentedControl.clipsToBounds = false
    }
    
    func indicatorAutolayout() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
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
        
        indicator.stopAnimating()
        
        comeStudentTableView.reloadData()
        notComeStudentTableView.reloadData()
        
        comeStudentTotalCountLabel.text = "\(comeStudentName.count)"
        notComeStudentTotalCountLabel.text = "\(notComeStudentName.count)"
    }
    
    func failAlert(messages: String) {
        indicator.stopAnimating()
        
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func apiCall(grade: String) {
        indicator.startAnimating()
        
        let URL = "http://ec2-3-35-81-230.ap-northeast-2.compute.amazonaws.com:3000/check/\(grade)"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    guard let data = response.data else { return }
                    self.model = try JSONDecoder().decode(StudentStatusBoardModel.self, from: data)
                } catch(let error) {
                    self.failAlert(messages: error.localizedDescription)
                    print(error.localizedDescription)
                }
                self.studentFilter()
                print(value)
            case .failure(let error):
                self.failAlert(messages: "네트워크 연결을 확인해주세요.")
                print(error.localizedDescription)
            }
        }
    }
}

extension StudentStatusBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView.tag == 1 ? comeStudentName.count : notComeStudentName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentStatusBoardTableViewCell", for: indexPath) as! StudentStatusBoardTableViewCell
        
        if tableView.tag == 1 {
            cell.studentName.text = comeStudentName[indexPath.row]
            cell.studentClassNumber.text = "\(comeStudentClassNumber[indexPath.row])"
        } else if tableView.tag == 2 {
            cell.studentName.text = notComeStudentName[indexPath.row]
            cell.studentClassNumber.text = "\(notComeStudentClassNumber[indexPath.row])"
        }
        
        return cell
    }
}
