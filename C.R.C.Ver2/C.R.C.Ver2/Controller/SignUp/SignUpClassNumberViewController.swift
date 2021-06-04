//
//  SignUpClassNumberViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/28.
//

import UIKit
import Alamofire

class SignUpClassNumberViewController: UIViewController {
    
    @IBOutlet weak var classNumberTextField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var doneBtnBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil )
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setting() {
        classNumberTextField.delegate = self
        doneBtn.layer.cornerRadius = 10
    }
    
    func failAlert(messages: String) {
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func sucessAlert() {
        let alert = UIAlertController(title: "회원가입 성공", message: "이메일 인증을 해야 로그인이 가능합니다.", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            SignUpManager.removeEmail()
            SignUpManager.removePassword()
            SignUpManager.removeName()
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func postData(email: String, password: String, name: String, student_data: String) {
        
        let URL = "http://10.120.75.224:3000/login"
        let PARAM: Parameters = [
            "email": email,
            "password": password,
            "name": name,
            "student_data": student_data
        ]
        AF.request(URL, method: .post, parameters: PARAM, encoding: JSONEncoding.default).responseJSON { data in
            switch data.result {
            case .success(let value):
                print(value)
                if let dic = value as? NSDictionary {
                    if let code = dic["code"] as? Int {
                        switch code {
                        case 0:
                            self.sucessAlert()
                        case -200:
                            self.failAlert(messages: "이미 가입된 메일입니다.")
                        default:
                            self.failAlert(messages: "오류 발생")
                        }
                    }
                }
            case .failure(let e):
                self.failAlert(messages: "네트워크가 원활하지 않습니다.")
                print("error: \(e.localizedDescription)")
            }
        }
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        postData(email: SignUpManager.getEmail(), password: SignUpManager.getPassword(), name: SignUpManager.getName(), student_data: classNumberTextField.text ?? "")
    }
}

extension SignUpClassNumberViewController: UITextFieldDelegate {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            
            if self.doneBtnBottomConstraint.constant == 30 {
                self.doneBtnBottomConstraint.constant += keyboardHeight - 25
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.doneBtnBottomConstraint.constant != 30 {
            self.doneBtnBottomConstraint.constant = 30
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        classNumberTextField.resignFirstResponder()
        return true
    }
}
