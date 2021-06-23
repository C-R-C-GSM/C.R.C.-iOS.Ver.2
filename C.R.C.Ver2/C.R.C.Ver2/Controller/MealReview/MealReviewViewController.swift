//
//  MealReviewViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/06/13.
//

import UIKit

class MealReviewViewController: UIViewController {

    @IBOutlet weak var mealReviewTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
    }
    
    func setting() {
        mealReviewTableView.delegate = self
        mealReviewTableView.dataSource = self
    }

}

extension MealReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealReviewTableViewCell", for: indexPath) as! MealReviewTableViewCell
        
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    
    
    
}
