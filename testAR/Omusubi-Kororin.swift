//
//  Omusubi-Kororin.swift
//  testAR
//
//  Created by 高橋剛 on 2019/02/26.
//  Copyright © 2019年 ymgn. All rights reserved.
//

import UIKit
class OmusubiKororin{
    func kororin(view: UIView){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            view.transform = CGAffineTransform(rotationAngle:CGFloat.pi)
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                view.transform = CGAffineTransform(rotationAngle:CGFloat.pi*2)
            }, completion: nil)
        })
    }
}
