//
//  SignUpNameViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/28.
//

import UIKit

class SignUpNameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
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
        checkTextField() ? nextController() : failAlert(messages: "빈칸을 채우세요.")
    }
    
    func setting() {
        self.navigationItem.backBarButtonItem?.tintColor = .init(named: "Primary Color")
        
        nameTextField.delegate = self
        
        continueBtn.layer.cornerRadius = 10
    }
    
    func failAlert(messages: String) {
        let alert = UIAlertController(title: messages, message: nil, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func nextController() {
        SignUpManager.saveName(name: nameTextField.text ?? "")
        
        let nextController = storyboard?.instantiateViewController(withIdentifier: "SignUpClassNumberViewController") as! SignUpClassNumberViewController
        navigationController?.pushViewController(nextController, animated: true)
    }
    
    func checkTextField() -> Bool {
        if (nameTextField.text == "") {
            return false
        }
        return true
    }
}

extension SignUpNameViewController: UITextFieldDelegate {
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
        nameTextField.resignFirstResponder()
        return true
    }
}
