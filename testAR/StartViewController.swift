//
//  StartViewController.swift
//  testAR
//
//  Created by 高橋剛 on 2019/02/26.
//  Copyright © 2019年 ymgn. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var showRecordButton: UIButton!
    @IBOutlet weak var rankingButton: UIButton!
    
    let Kororin = OmusubiKororin()
    let titleArray = ["過 去 の ス コ ア","ラ ン キ ン グ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        showRecordButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        rankingButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
    }
    
    @objc func action(sender: UIButton){
        Kororin.kororin(view: sender.imageView!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.performSegue(withIdentifier: String(sender.restorationIdentifier!.prefix(4)), sender: sender.tag)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let SVC = segue.destination as! ShowViewController
            SVC.swichText = titleArray[sender as! Int]
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
