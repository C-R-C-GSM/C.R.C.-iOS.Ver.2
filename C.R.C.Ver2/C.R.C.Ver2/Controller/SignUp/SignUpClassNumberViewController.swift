//
//  SignUpClassNumberViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/28.
//

import UIKit

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
    
    @IBAction func doneButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setting() {
        classNumberTextField.delegate = self
        doneBtn.layer.cornerRadius = 10
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
