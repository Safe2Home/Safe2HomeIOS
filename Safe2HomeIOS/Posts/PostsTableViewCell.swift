//
//  PostsTableViewCell.swift
//  SnapchatProject
//
//  Created by Paige Plander on 3/9/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    /// Displays the name of the user who posted the thread
    @IBOutlet weak var usernameLabel: UILabel!

    /// Image to indicate whether or not the image has been read
    @IBOutlet weak var readImageView: UIImageView!
    
    /// Displays the time elapsed since the user posted the thread
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
