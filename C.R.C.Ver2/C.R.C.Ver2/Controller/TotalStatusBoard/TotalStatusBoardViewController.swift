//
//  TotalStatusBoardViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/06/11.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class TotalStatusBoardViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    var model: TotalStudentModel?
    
    @IBOutlet weak var comeStudentCount: UILabel!
    @IBOutlet weak var notComeStudentCount: UILabel!
    
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var totalStudentView: UIView!
    @IBOutlet weak var comeStudentView: UIView!
    @IBOutlet weak var notComeStudentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorAutolayout()
        setting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    @IBAction func refreshButton(_ sender: UIButton) {
        apiCall()
    }
    
    func setting() {
        
        noticeView.layer.cornerRadius = 15
        
        totalStudentView.layer.cornerRadius = 5
        totalStudentView.layer.borderWidth = 0.1
        totalStudentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        totalStudentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        totalStudentView.layer.shadowRadius = 10.0
        totalStudentView.layer.shadowOpacity = 1.0
        totalStudentView.layer.shadowOffset = CGSize(width: 10.0, height: 4.0)
        totalStudentView.layer.masksToBounds = false
        
        
        comeStudentView.layer.cornerRadius = 5
        comeStudentView.layer.borderWidth = 0.1
        comeStudentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        comeStudentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        comeStudentView.layer.shadowRadius = 10
        comeStudentView.layer.shadowOpacity = 1
        comeStudentView.layer.shadowOffset = CGSize(width: 10.0, height: 4.0)
        comeStudentView.layer.masksToBounds = false
        
        
        notComeStudentView.layer.cornerRadius = 5
        notComeStudentView.layer.borderWidth = 0.1
        notComeStudentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        notComeStudentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        notComeStudentView.layer.shadowRadius = 10
        notComeStudentView.layer.shadowOpacity = 1
        notComeStudentView.layer.shadowOffset = CGSize(width: 10.0, height: 4.0)
        notComeStudentView.layer.masksToBounds = false
    }
    
    func indicatorAutolayout() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    func textSetting() {
        indicator.stopAnimating()
        
        comeStudentCount.text = "\(model?.total_num ?? 0)"
        notComeStudentCount.text = "\(230 - (model?.total_num ?? 0))"
    }
    
    func failAlert(messages: String) {
        indicator.stopAnimating()
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func apiCall() {
        indicator.startAnimating()
        
        let URL = "http://ec2-3-35-81-230.ap-northeast-2.compute.amazonaws.com:3000/check/total"
        let token = TokenManager.getToken()
        AF.request(URL, method: .get, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    guard let data = response.data else { return }
                    self.model = try JSONDecoder().decode(TotalStudentModel.self, from: data)
                } catch(let error) {
                    self.failAlert(messages: error.localizedDescription)
                    print(error.localizedDescription)
                }
                self.textSetting()
                print(value)
            case .failure(let error):
                self.failAlert(messages: "네트워크 연결을 확인해주세요.")
                print(error.localizedDescription)
            }
        }
    }
}
