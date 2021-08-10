//
//  UISegmentedControl.swift
//  C.R.C.Ver2
//
//  Created by 조주혁 on 2021/08/05.
//

import UIKit

extension UISegmentedControl {
    func clearBG() {
        setBackgroundImage(imageWithColor(color: UIColor.white), for: .normal, barMetrics: .default)
        setDividerImage(imageWithColor(color: .white), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
