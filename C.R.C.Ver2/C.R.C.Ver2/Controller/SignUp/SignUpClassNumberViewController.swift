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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        
    }
    @IBAction func doneButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setting() {
        doneBtn.layer.cornerRadius = 10
    }

}
