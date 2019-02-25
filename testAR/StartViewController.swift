//
//  StartViewController.swift
//  testAR
//
//  Created by ymgn on 2019/02/25.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func gameStart(_ sender: Any) {
        performSegue(withIdentifier: "gameStart", sender: nil)
    }
    
    @IBAction func showScore(_ sender: Any) {
        return
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
