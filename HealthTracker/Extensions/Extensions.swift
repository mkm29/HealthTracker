//
//  Extensions.swift
//  HealthTracker
//
//  Created by Mitchell Murphy on 7/14/18.
//  Copyright © 2018 Mitchell Murphy. All rights reserved.
//

extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}


extension String {
    
    func date(withFormat format: String = Constants.DateFormat.Long) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func dateFromTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.Time
        return formatter.date(from: self)
    }
    
    func convertDate(f_ format1: String = "MM-dd-yyyy", _ format2: String = "EEEE MMM d") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format1
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = format2
        return dateFormatter.string(from: date!)
    }
    
}

extension Date {
    
    func toFormat(_ format: String) -> Date? {
        // 1. get date string from self
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let dateString = formatter.string(from: self)
        // 2.
        return formatter.date(from: dateString)
    }
    
    func string(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}

extension UITextField {
    
    enum BorderType {
        case Left
        case Top
        case Bottom
        case Right
    }
    
    func addBorder(type: BorderType, color: UIColor, withWidth: Double) {
        let border = CALayer()
        border.borderColor = color.cgColor
        let width = CGFloat(withWidth)
        border.borderWidth = width
        self.borderStyle = .none
        
        var borderFrame: CGRect!
        
        switch type {
        case .Bottom:
            borderFrame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        case .Top:
            borderFrame = CGRect(x: 0, y: 0 + width, width: self.frame.size.width, height: width)
        case .Left:
            borderFrame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            borderFrame = CGRect(x: self.frame.size.width, y: 0, width: width, height: self.frame.size.height)
        }
        border.frame = borderFrame
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}

extension UIButton {
    
//    func roundBottomCorners() {
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = self.frame
//        rectShape.position = self.center
//        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
//
//        self.layer.backgroundColor = UIColor.green.cgColor
//        //Here I'm masking the textView's layer with rectShape layer
//        self.layer.mask = rectShape
//    }
    
//    func roundBottom(cornerRadius: Int = 10) {
//        self.clipsToBounds = true
//        self.layer.cornerRadius = CGFloat(cornerRadius) // 10
//        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        let tes = [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMinYCorner]
//        self.layer.maskedCorners = tes
//    }
    func round(radius: CGFloat, corners: CACornerMask) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func roundTop(withRadius radius: CGFloat = Constants.Design.cornerRadius) {
        self.round(radius: radius, corners: [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMinYCorner])
    }
    
    func roundBottom(withRadius radius: CGFloat = Constants.Design.cornerRadius) {
        self.round(radius: radius, corners: [CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMaxXMaxYCorner])
    }
    
    func roundRight(withRadius radius: CGFloat = Constants.Design.cornerRadius) {
        self.round(radius: radius, corners: [CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMaxXMaxYCorner])
    }
}

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
    
}

extension UIImageView {
    
    func downloadAndSetImage(fromURL url: URL, completion: @escaping (_ error: Error?) -> Void) {
        let getImage = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(error)
                return
            }
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                    completion(nil)
                }
            }
        }
        getImage.resume()
    }
    
    
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
