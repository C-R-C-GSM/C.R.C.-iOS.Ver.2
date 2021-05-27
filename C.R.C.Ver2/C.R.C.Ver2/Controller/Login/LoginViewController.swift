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
        
        signInBtn.layer.cornerRadius = 10
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
    }
    
    
}
