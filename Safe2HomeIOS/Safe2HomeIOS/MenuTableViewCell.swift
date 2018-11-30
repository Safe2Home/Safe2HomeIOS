//
//  MenuTableViewCell.swift
//  Safe2HomeIOS
//
//  Created by Yafei Liang on 11/24/18.
//  Copyright © 2018 Safe2Home. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var detailVC: UILabel!
    
    @IBOutlet weak var menuImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
