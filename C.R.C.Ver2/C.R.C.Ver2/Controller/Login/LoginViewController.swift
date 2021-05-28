//
//  LoginViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/05/27.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }

    func setting() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        passwordTextField.delegate = self
        
        signInBtn.layer.cornerRadius = 10
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
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
