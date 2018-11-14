//
//  PostsTableViewCell.swift
//  SnapchatProject
//
//  Created by Paige Plander on 3/9/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

// this is a static note and will not change
    @IBOutlet weak var MatcherLabel: UILabel!
    
    @IBOutlet weak var MatcherName: UILabel!
    

    @IBOutlet weak var MatcherComment: UILabel!
    
        override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
