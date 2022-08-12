//
//  PhotoScreenConfig.swift
//  FootCoreData
//
//  Created by Max on 27.07.2022.
//

import Foundation
import UIKit

enum PhotoType: Int {
    case legue
    case club
}

class PhotoScreenConfig {
    
    var title: String?
    var arrayImg = [UIImage]()

    static func selectScreen(type: PhotoType ) -> PhotoScreenConfig {
        let photoConfig = PhotoScreenConfig()
        switch type {
        case .legue:
            photoConfig.title = "Leagues Icon"
            
            for i in 1...12 {
                if let img = UIImage(named: "MemojiBackground_\(i)"){
                    photoConfig.arrayImg.append(img)
                }
            }
        case .club:
            photoConfig.title = "Clubs Icon"
            
            for i in 1...9 {
                if let img = UIImage(named: "Club_\(i)"){
                    photoConfig.arrayImg.append(img)
                }
            }
        }
        return photoConfig
    }
}
