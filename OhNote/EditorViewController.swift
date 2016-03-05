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
            
            if let noteTitle = firstParagraph(nsText) {
                note.title = noteTitle as String
                let otherText = nsText.stringByReplacingCharactersInRange(NSMakeRange(0, noteTitle.length + 1), withString: "")
                
                if let noteSummary = firstParagraph(otherText) {
                    note.summary = noteSummary as String
                } else {
                    note.summary = otherText
                }
                
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
    
    func firstParagraph(var text: NSString) -> NSString? {
        let newLineCharacter = NSCharacterSet.newlineCharacterSet()
        text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let cuttingLocation = text.rangeOfCharacterFromSet(newLineCharacter).location
        if cuttingLocation != NSNotFound {
            let cuttingRange = NSRange(location: 0, length: cuttingLocation)
            return text.substringWithRange(cuttingRange)
        }
        return nil
    }
    
}

// MARK: - text view delegate

extension EditorViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        print(__FUNCTION__)
    }
}
