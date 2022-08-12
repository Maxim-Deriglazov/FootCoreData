//
//  FileManager+Foot.swift
//  FootCoreData
//
//  Created by Max on 25.07.2022.
//

import Foundation
import UIKit

extension FileManager {
    
    var imageCacheUrl: URL? {
        
        guard let appURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return nil }
        
        let imagesURL = appURL.appendingPathComponent("Images")
        if !FileManager.default.fileExists(atPath: imagesURL.absoluteString) {
            try? FileManager.default.createDirectory(at: imagesURL, withIntermediateDirectories: false, attributes: nil)
        }
        return imagesURL
    }
    
    func saveImageToCache(img: UIImage) -> String? {
        guard let url = imageCacheUrl else {
            return nil
        }
        let iconName = NSUUID().uuidString + ".png"
        let iconURL = url.appendingPathComponent(iconName)
        try? img.pngData()?.write(to: iconURL)
        return iconName
    }
    
    func loadImageFromCache(name: String) -> UIImage? {
        guard let url = imageCacheUrl else { return nil }
        let urlToImg = url.appendingPathComponent(name)
        return UIImage(contentsOfFile: urlToImg.path)
    }    
}
