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
    
    @IBOutlet weak var textView: EditorTextView! {
        didSet {
            textView.controller = self
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
