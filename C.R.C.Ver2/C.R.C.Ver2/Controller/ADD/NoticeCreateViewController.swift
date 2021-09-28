//
//  NoticeCreateViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/07.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class NoticeCreateViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)

    @IBOutlet weak var noticeCreateTitle: UITextField!
    @IBOutlet weak var noticeCreateContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        indicatorAutolayout()
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        checkText() ? apiCall(title: noticeCreateTitle.text ?? "", content: noticeCreateContent.text ?? "") : failAlert(messages: "빈칸을 모두 채워주세요.")
    }
    
    func setting() {
        noticeCreateTitle.delegate = self
        noticeCreateContent.delegate = self
    }
    
    func indicatorAutolayout() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    func failAlert(messages: String) {
        indicator.stopAnimating()
        
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func sucessAlert() {
        indicator.stopAnimating()
        
        let alert = UIAlertController(title: "건의 등록 성공", message: "건의 등록 성공!!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func checkText() -> Bool {
        if (noticeCreateTitle.text == "") || (noticeCreateContent.text == "") {
            return false
        }
        return true
    }
    
    func apiCall(title: String, content: String) {
        indicator.startAnimating()
        
        let URL = "http://ec2-3-34-189-53.ap-northeast-2.compute.amazonaws.com:3000/notice/register"
        let token = TokenManager.getToken()
        let PARAM: Parameters = [
            "title": title,
            "content": content
        ]
        AF.request(URL, method: .post, parameters: PARAM, headers: ["Token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let dic = value as? NSDictionary, let code = dic["code"] as? Int else { return }
                switch code {
                case 0:
                    self.sucessAlert()
                default:
                    self.failAlert(messages: "공지사항을 등록할 수 없습니다.")
                }
                print(value)
            case .failure(let error):
                self.failAlert(messages: "네트워크 연결을 확인해주세요.")
                print(error.localizedDescription)
            }
        }
    }
}

extension NoticeCreateViewController: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
