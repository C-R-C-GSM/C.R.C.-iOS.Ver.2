//
//  MealSuggestionBoardViewController.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/07/03.
//

import UIKit

class MealSuggestionBoardViewController: UIViewController {

    @IBOutlet weak var mealSuggestionBoardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
    }
    
    func setting() {
        mealSuggestionBoardTableView.delegate = self
        mealSuggestionBoardTableView.dataSource = self
        mealSuggestionBoardTableView.tableFooterView = UIView()
    }
}

extension MealSuggestionBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealSuggestionBoardTableViewCell", for: indexPath) as! MealSuggestionBoardTableViewCell
        return cell
    }
    
    
}
