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
        
        customMenuController()
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
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
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if selectedRange.length > 0 {
            if action == "toggleBoldface:"
                || action == "toggleItalics:"
                || action == "toggleUnderline:" {
                    return true
            }
            return false
        } else {
            if action == "select:"
                || action == "selectAll:"
                || action == "insertAction:"
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
    
    func insertAction(sender: AnyObject?) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        
        // MARK: 插入标题
        let headingAction = UIAlertAction(title: "标题", style: .Default) { (action: UIAlertAction) -> Void in
            let location = self.selectedRange.location
            let attrString = NSAttributedString(
                string: "\n标题\n",
                attributes: [
                    NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                ]
            )
            let mAttrText = NSMutableAttributedString(attributedString: self.attributedText)
            mAttrText.insertAttributedString(attrString, atIndex: location)
            self.attributedText = mAttrText
            self.selectedRange = NSMakeRange(location + 1, 2)
        }
        
        // MARK: 插入链接
        let linkAction = UIAlertAction(title: "链接", style: .Default) { (action: UIAlertAction) -> Void in
            
            var location = self.selectedRange.location
            let linkAlertController = UIAlertController(title: "链接", message: nil, preferredStyle: .Alert)
            
            linkAlertController.addTextFieldWithConfigurationHandler({ (textField: UITextField) -> Void in
                textField.placeholder = "http://"
                textField.clearButtonMode = .Always
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
            
            let okAction = UIAlertAction(title: "确认", style: .Default, handler: { (action: UIAlertAction) -> Void in
                let link = linkAlertController.textFields?.first?.text
                let attrString = NSAttributedString(
                    string: link!, attributes: [
                        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1),
                        NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                        NSLinkAttributeName: link!,
                    ]
                )
                self.textStorage.insertAttributedString(attrString, atIndex: location)
                
                location += attrString.length
                let attrSpace = NSAttributedString(
                    string: " ",
                    attributes: [
                        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
                    ]
                )
                self.textStorage.insertAttributedString(attrSpace, atIndex: location)
                self.selectedRange.location = location + 1
            })
            
            linkAlertController.addAction(cancelAction)
            linkAlertController.addAction(okAction)
            
            self.controller.presentViewController(linkAlertController, animated: true, completion: nil)
        }
        
        // MARK: 插入图片
        let imageAction = UIAlertAction(title: "图片", style: .Default) { (action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.view.backgroundColor = UIColor.whiteColor()
            picker.delegate = self.controller
            self.controller.showViewController(picker, sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alertController.addAction(headingAction)
        alertController.addAction(linkAction)
        alertController.addAction(imageAction)
        alertController.addAction(cancelAction)
        
        controller.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func customMenuController() {
        let menuController = UIMenuController.sharedMenuController()
        menuController.menuItems = [
            UIMenuItem(title: "加粗", action: "toggleBoldface:"),
            UIMenuItem(title: "斜体", action: "toggleItalics:"),
            UIMenuItem(title: "下划线", action: "toggleUnderline:"),
            UIMenuItem(title: "插入", action: "insertAction:"),
        ]
    }
    
    
}
