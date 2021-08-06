//
//  AddViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/07.
//

import UIKit

class AddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        logOutAlert()
    }
    
    func logOutAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "로그아웃", style: .destructive) { (_) in
            self.goLoginPage()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func goLoginPage(){
        guard let goMain = self.storyboard?.instantiateViewController(identifier: "LoginNav") else { return }
        goMain.modalPresentationStyle = .fullScreen
        self.present(goMain, animated: true)
    }
}
