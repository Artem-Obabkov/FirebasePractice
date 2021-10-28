//
//  IntExtension.swift
//  tableViewMusic
//
//  Created by pro2017 on 18/10/2021.
//

import Foundation
import UIKit
//Nevermind
//The Beatles
//The Dark Side of the Moon
//What’s Going On
//My Beautiful Dark Twisted Fantasy
//Let It Bleed
//Led Zeppelin IV

enum ImageNames: String {
    
    case nevermind = "Nevermind"
    case theBeatles = "The Beatles"
    case theDarkSideoftheMoon = "The Dark Side of the Moon"
    case whatsGoingOn = "What’s Going On"
    case myBeautifulDarkTwistedFantasy = "My Beautiful Dark Twisted Fantasy"
    case letItBleed = "Let It Bleed"
    case ledZeppelinIV = "Led Zeppelin IV"
}

extension Int {
    
    static func getImage(from number: Int) -> UIImage? {
        
        var imageName = ""
        
        switch number {
        case 0:
            imageName = ImageNames.nevermind.rawValue
        case 1:
            imageName = ImageNames.theBeatles.rawValue
        case 2:
            imageName = ImageNames.theDarkSideoftheMoon.rawValue
        case 3:
            imageName = ImageNames.whatsGoingOn.rawValue
        case 4:
            imageName = ImageNames.myBeautifulDarkTwistedFantasy.rawValue
        case 5:
            imageName = ImageNames.letItBleed.rawValue
        case 6:
            imageName = ImageNames.ledZeppelinIV.rawValue
        default:
            return nil
        }
        
        guard let image = UIImage(named: imageName) else { return nil }
        
        return image
    }
}
