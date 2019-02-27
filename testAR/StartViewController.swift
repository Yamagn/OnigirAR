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
    
    @IBOutlet weak var imageView: UIImageView!
    
    let Kororin = OmusubiKororin()
    let titleArray = ["過 去 の ス コ ア","ラ ン キ ン グ"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        showRecordButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        rankingButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        
        self.view.bringSubviewToFront(imageView)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("fjlkfjsalk")
        stop()
    }
    @objc func action(sender: UIButton){
        Kororin.kororin(view: sender.imageView!)
        if sender.restorationIdentifier == "show2"{
            start()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.stop()
            }
        }
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
    var finished = true
    func start() {
        finished = false
        imageView.isHidden = false
        running()
    }
    
    func running() {
        if finished == true {
            imageView.isHidden = true
            return
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.imageView.transform = CGAffineTransform.identity
        }, completion: { completed in
            self.running()
        })
    }
    func stop() {
        finished = true
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
