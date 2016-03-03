//
//  EditorTextView.swift
//  OhNote
//
//  Created by 吴伟城 on 16/3/3.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit

class EditorTextView: UITextView {
    
    weak var controller: EditorViewController!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if let _ = controller.note.id {
            do {
                try attributedText = NSAttributedString(
                    data: controller.note.contentData,
                    options: [
                        NSDocumentTypeDocumentAttribute: NSRTFDTextDocumentType,
                    ],
                    documentAttributes: nil
                )
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            becomeFirstResponder()
            font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
        customMenuController()
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if selectedRange.length > 0 {
            print(100)
            if action == "toggleBoldface:"
                || action == "toggleItalics:"
                || action == "toggleUnderline:" {
                    return true
            }
            return false
        } else {
            print(200)
            if action == "select:"
                || action == "selectAll:"
                || action == "paste:" {
                    return true
            }
            return false
        }
    }
    
    override func toggleBoldface(sender: AnyObject?) {
        toggleBoldface(sender)
    }
    
    override func toggleItalics(sender: AnyObject?) {
        toggleItalics(sender)
    }
    
    override func toggleUnderline(sender: AnyObject?) {
        toggleUnderline(sender)
    }
    
    func customMenuController() {
        let menuController = UIMenuController.sharedMenuController()
        menuController.menuItems = [
            UIMenuItem(title: "加粗", action: "toggleBoldface:"),
            UIMenuItem(title: "斜体", action: "toggleItalics:"),
            UIMenuItem(title: "下划线", action: "toggleUnderline:"),
        ]
    }
    
    
}
