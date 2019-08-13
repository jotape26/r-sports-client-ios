//
//  FilesManager.swift
//  R Sports
//
//  Created by João Pedro Leite on 12/08/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import UIKit

class FilesManager {
    static func saveImageToDisk(image: UIImage) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("profilePic.png")
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch { }
    }
    
    static func getProfilePicFromDisk() -> UIImage {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("profilePic.png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath) ?? UIImage(named: "genericProfile")!
        }
        return UIImage(named: "genericProfile")!
    }
}
