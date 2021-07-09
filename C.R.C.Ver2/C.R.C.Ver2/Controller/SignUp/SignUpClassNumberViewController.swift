//
//  SignUpClassNumberViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/28.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SignUpClassNumberViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)
    
    @IBOutlet weak var classNumberTextField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var doneBtnBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        indicatorAutolayout()
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
    
    @IBAction func doneButton(_ sender: UIButton) {
        checkTextField() ? postData(email: SignUpManager.getEmail(), password: SignUpManager.getPassword(), name: SignUpManager.getName(), student_data: classNumberTextField.text ?? "") : failAlert(messages: "빈칸을 모두 채워주세요.")
    }
    
    func setting() {
        classNumberTextField.delegate = self
        classNumberTextField.keyboardType = .numberPad
        
        doneBtn.layer.cornerRadius = 10
    }
    
    func indicatorAutolayout() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    func checkTextField() -> Bool {
        if (classNumberTextField.text == "") {
            return false
        }
        return true
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
        indicator.startAnimating()
        
        let URL = "http://ec2-52-14-165-111.us-east-2.compute.amazonaws.com:3000/register"
        let PARAM: Parameters = [
            "email": email,
            "password": password,
            "name": name,
            "student_data": student_data
        ]
        AF.request(URL, method: .post, parameters: PARAM).responseJSON { data in
            switch data.result {
            case .success(let value):
                print(value)
                if let dic = value as? NSDictionary,
                   let code = dic["code"] as? Int {
                    switch code {
                    case 0:
                        self.sucessAlert()
                    case -200:
                        self.failAlert(messages: "이미 가입된 메일입니다.")
                    default:
                        self.failAlert(messages: "오류 발생")
                    }
                }
            case .failure(let e):
                self.failAlert(messages: "네트워크가 원활하지 않습니다.")
                print("error: \(e.localizedDescription)")
            }
        }
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
