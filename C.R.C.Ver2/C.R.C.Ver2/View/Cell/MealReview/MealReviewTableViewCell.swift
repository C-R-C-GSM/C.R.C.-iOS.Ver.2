//
//  MealReviewTableViewCell.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/06/14.
//

import UIKit

class MealReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealReviewNicname: UILabel!
    @IBOutlet weak var mealReviewContent: UILabel!
    @IBOutlet weak var mealReviewDate: UILabel!
    @IBOutlet weak var mealReviewTime: UILabel!
    @IBOutlet weak var mealReviewAnswer: UILabel!
    
    @IBOutlet weak var mealReviewStar1: UIImageView!
    @IBOutlet weak var mealReviewStar2: UIImageView!
    @IBOutlet weak var mealReviewStar3: UIImageView!
    @IBOutlet weak var mealReviewStar4: UIImageView!
    @IBOutlet weak var mealReviewStar5: UIImageView!
}
