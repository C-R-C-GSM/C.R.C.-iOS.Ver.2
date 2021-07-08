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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorAutolayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        apiCall()
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
        
        let URL = "http://ec2-3-142-201-241.us-east-2.compute.amazonaws.com:3000/check/total"
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
