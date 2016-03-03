//
//  EditorViewController.swift
//  OhNote
//
//  Created by 吴伟城 on 16/3/1.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    var note: Note!
    @IBOutlet weak var tvBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView! {
        didSet {
            if let _ = note.id {
                do {
                    try textView.attributedText = NSAttributedString(
                        data: note.contentData,
                        options: [
                            NSDocumentTypeDocumentAttribute: NSRTFDTextDocumentType,
                        ],
                        documentAttributes: nil
                    )
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                textView.becomeFirstResponder()
            }
            customMenuController()
        }
    }
    
    @IBAction func moreActions(sender: AnyObject) {
        //
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                selector: "keyboardDidShow:",
                name: UIKeyboardDidShowNotification,
                object: nil
        )
        
        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                selector: "keyboardWillHide:",
                name: UIKeyboardWillHideNotification,
                object: nil
        )
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        saveNote()
    }
    
    func keyboardDidShow(aNotification: NSNotification) {
        let keyboardY = aNotification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.origin.y
        let keyboardH = UIApplication.sharedApplication().keyWindow!.bounds.height - keyboardY!
        tvBottomConstraint.constant = (-keyboardH)
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        tvBottomConstraint.constant = 0
    }
    
    func customMenuController() {
        let menuController = UIMenuController.sharedMenuController()
        menuController.menuItems = [
            UIMenuItem(title: "加粗", action: "toggleBoldface:"),
            UIMenuItem(title: "斜体", action: "toggleItalics:"),
            UIMenuItem(title: "下划线", action: "toggleUnderline:"),
        ]
    }
    
    func saveNote() {
        if textView.hasText() {
            
            let nsText = NSString(string: textView.text)
            let newLineCharacter = NSCharacterSet.newlineCharacterSet()
            let cutterLocation = nsText.rangeOfCharacterFromSet(newLineCharacter).location
            let titleRange = NSRange(location: 0, length: cutterLocation)
            
            if cutterLocation != NSNotFound {
                note.title = nsText.substringWithRange(titleRange)
                let summary = nsText.stringByReplacingCharactersInRange(titleRange, withString: "")
                let spaceCharacter = NSCharacterSet.whitespaceAndNewlineCharacterSet()
                note.summary = summary.stringByTrimmingCharactersInSet(spaceCharacter)
            } else {
                note.title = textView.text
                note.summary = "无附加文本"
            }
            do {
                try note.contentData = textView.attributedText.dataFromRange(
                    NSRange(location: 0, length: textView.attributedText.length),
                    documentAttributes: [
                        NSDocumentTypeDocumentAttribute: NSRTFDTextDocumentType,
                    ]
                )
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
            note.save()
        }
    }
    
}

// MARK: - text view delegate

extension EditorViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        print(__FUNCTION__)
    }
}

// MARK: - menu controller actions

extension EditorViewController {
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        var withRange = (action == "toggleBoldface:")
        withRange = withRange || (action == "toggleItalics:")
        withRange = withRange || (action == "toggleUnderline:")
        
        var without = (action == "select:")
        without = without || (action == "selectAll:")
        without = without || (action == "paste:")
        
        withRange = withRange && (textView.selectedRange.length > 0)
        without = without && (textView.selectedRange.length == 0)
        
        return withRange || without
    }
    
    override func toggleBoldface(sender: AnyObject?) {
        textView.toggleBoldface(sender)
    }
    
    override func toggleItalics(sender: AnyObject?) {
        textView.toggleItalics(sender)
    }
    
    override func toggleUnderline(sender: AnyObject?) {
        textView.toggleUnderline(sender)
    }
    
}
