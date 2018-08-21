//
//  UIImage.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 8/21/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

import UIKit

extension UIImage {
    
    var documentsDirectory: String {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
    }
    
    
    func saveImage(withPrefix prefix: String) -> String? {
        let fileManager = FileManager.default
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let documentsPath = documentsURL.path
        let filePath = documentsURL.appendingPathComponent("\(String(prefix)).png", isDirectory: false)
        
        var path: String? = nil
        
        // Check for existing image data
        do {
            // Look through array of files in documentDirectory
            let files = try FileManager.default.contentsOfDirectory(atPath: documentsPath)
            
            for file in files {
                // If we find existing image delete it to make room for the new once
                if "\(documentsPath)/\(file)" == filePath.path {
                    try fileManager.removeItem(atPath: filePath.path)
                }
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        
        
        do {
            if let pngImageData = self.pngData() {
                try pngImageData.write(to: filePath, options: .atomic)
                path = filePath.path
            }
        } catch {
            print("Could not write image data: \(error)")
        }
        return path
    }
    
    func store( name: String) -> String? {
        var name = name
        name = documentsDirectory.appending(name.lowercased().appending(".png"))
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(name)
            
            if let imageData = self.pngData() {
                try imageData.write(to: fileURL)
                return fileURL.path
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func trim(trimRect :CGRect) -> UIImage {
        if CGRect(origin: CGPoint.zero, size: self.size).contains(trimRect) {
            if let imageRef = self.cgImage?.cropping(to: trimRect) {
                return UIImage(cgImage: imageRef)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.draw(in: CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = trimmedImage else { return self }
        
        return image
    }
    
}
