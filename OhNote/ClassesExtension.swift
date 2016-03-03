//
//  StringExtension.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/25.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import Foundation
import UIKit

// MARK: - String extension.

extension String {
    
    func length() -> Int {
        return NSString(string: self).length
    }
    
    func substringWithRange(range: NSRange) -> String {
        return NSString(string: self).substringWithRange(range)
    }
}

// MARK: - UIImage extension.

extension UIImage {
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
        if size.width < newWidth {
            return self
        }
        let scale = size.height / size.width
        let targetSize = CGSize(width: newWidth, height: newWidth * scale)
        UIGraphicsBeginImageContext(targetSize)
        let rect = CGRect(origin: CGPointZero, size: targetSize)
        self.drawInRect(rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}