//
//  SecondScreen.swift
//  tableViewMusic
//
//  Created by pro2017 on 13/01/2021.
//

import UIKit

class AddScreen: UIViewController {
    
//    var album = SongModel(imageNumber: (UIImage(named: "Nevermind")?.pngData())!, name: "", description: "", userID: "")
    var album: SongModel!
    
    @IBOutlet weak var albumImageBig: UIImageView!
    @IBOutlet weak var albumNameBig: UILabel!
    @IBOutlet weak var albumDescriptionBig: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.albumNameBig.text = album.name
        self.albumImageBig.image = Int.getImage(from: album.imageNumber)
        self.albumDescriptionBig.text = album.description
        
    }

}
