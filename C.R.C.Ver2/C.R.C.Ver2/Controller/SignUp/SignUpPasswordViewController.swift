//
//  SignUpPasswordViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/28.
//

import UIKit

class SignUpPasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var continueBtnBottomConstraint: NSLayoutConstraint!
    
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
    
    @IBAction func continueButton(_ sender: UIButton) {
        checkTextField()
    }

    func setting() {
        self.navigationItem.backBarButtonItem?.tintColor = .init(named: "Primary Color")
        
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        
        continueBtn.layer.cornerRadius = 10
    }

    func failAlert(messages: String) {
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func nextController() {
        SignUpManager.savePassword(password:passwordTextField.text ?? "")
        
        let nextController = storyboard?.instantiateViewController(withIdentifier: "SignUpNameViewController") as! SignUpNameViewController
        navigationController?.pushViewController(nextController, animated: true)
    }
    
    func checkTextField() {
        if (passwordTextField.text == "") || (passwordCheckTextField.text == "") {
            failAlert(messages: "빈칸을 모두 채우세요.")
        } else if passwordTextField.text != passwordCheckTextField.text {
            failAlert(messages: "패스워드가 일치하지 않습니다.")
        } else {
            nextController()
        }
        
    }
}

extension SignUpPasswordViewController: UITextFieldDelegate {
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
            
            if self.continueBtnBottomConstraint.constant == 30 {
                self.continueBtnBottomConstraint.constant += keyboardHeight - 25
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.continueBtnBottomConstraint.constant != 30 {
            self.continueBtnBottomConstraint.constant = 30
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        passwordCheckTextField.resignFirstResponder()
        return true
    }
}
