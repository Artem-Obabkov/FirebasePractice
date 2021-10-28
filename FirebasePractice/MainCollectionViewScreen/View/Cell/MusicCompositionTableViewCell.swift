//
//  MusicCompositionTableViewCell.swift
//  tableViewMusic
//
//  Created by pro2017 on 12/01/2021.
//

import UIKit

class MusicCompositionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
