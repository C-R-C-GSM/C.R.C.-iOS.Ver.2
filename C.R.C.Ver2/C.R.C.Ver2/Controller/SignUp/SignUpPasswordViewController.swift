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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
    }
    

    func setting() {
        self.navigationItem.backBarButtonItem?.tintColor = .init(named: "Primary Color")
        continueBtn.layer.cornerRadius = 10
    }

}
