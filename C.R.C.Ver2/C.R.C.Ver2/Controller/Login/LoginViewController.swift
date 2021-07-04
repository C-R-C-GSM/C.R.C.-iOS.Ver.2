//
//  LoginViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/27.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 182, y: 423, width: 50, height: 50), type: .ballPulse, color: UIColor.init(named: "Primary Color"), padding: 0)

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        indicatorAutolayout()
    }

    func setting() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationItem.backBarButtonItem?.tintColor = .init(named: "Primary Color")
        
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        passwordTextField.delegate = self
        
        signInBtn.layer.cornerRadius = 10
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
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func sucessAlert() {
        let alert = UIAlertController(title: "로그인 성공", message: "로그인 성공!!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.goMainPage()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func checkTextField() -> Bool {
        if (emailTextField.text == "") || (passwordTextField.text == "") {
            return false
        }
        return true
    }
    
    func goMainPage(){
        guard let goMain = self.storyboard?.instantiateViewController(identifier: "MainTabBar") else { return }
        goMain.modalPresentationStyle = .fullScreen
        self.present(goMain, animated: true)
    }
    
    func loginApi(email: String, password: String) {
        indicator.startAnimating()
        let URL = "http://192.168.43.203:3000/login"
        let PARAM: Parameters = [
            "email": email,
            "password": password
        ]
        AF.request(URL, method: .post, parameters: PARAM).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let dic = value as? NSDictionary, let code = dic["code"] as? Int else { return }
                switch code {
                case 0:
                    guard let dic = value as? NSDictionary, let token = dic["Token"] as? String else { return }
                    TokenManager.saveToken(token: token)
                    self.sucessAlert()
                    self.indicator.stopAnimating()
                case -100:
                    self.failAlert(messages: "Server Error")
                    self.indicator.stopAnimating()
                case -202:
                    self.failAlert(messages: "가입되지 않은 이메일입니다.")
                    self.indicator.stopAnimating()
                case -300:
                    self.failAlert(messages: "패스워드가 올바르지 않습니다.")
                    self.indicator.stopAnimating()
                case -400:
                    self.failAlert(messages: "Server Error")
                    self.indicator.stopAnimating()
                default:
                    self.failAlert(messages: "알 수 없는 오류")
                    self.indicator.stopAnimating()
                }
                print(value)
            case .failure(let error):
                self.indicator.stopAnimating()
                self.failAlert(messages: "네트워크가 원활하지 않습니다.")
                print(error)
            }
        }
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        checkTextField() ? loginApi(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") : failAlert(messages: "빈칸을 모두 채우세요.")
    }
}

extension LoginViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
