//
//  ScoreTableViewCell.swift
//  testAR
//
//  Created by 高橋剛 on 2019/02/26.
//  Copyright © 2019年 ymgn. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
