//
//  EditorViewController.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    var note: Note!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tvbottomConstraint: NSLayoutConstraint!
    @IBAction func moreActions() {
        let alertController = UIAlertController(title: "title", message: "message", preferredStyle: .ActionSheet)
        let action1 = UIAlertAction(title: "One", style: .Default, handler: nil)
        let action2 = UIAlertAction(title: "Two", style: .Destructive, handler: nil)
        let action3 = UIAlertAction(title: "Three", style: .Cancel, handler: nil)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: "keyboardDidChangeHeight:", name: UIKeyboardDidChangeFrameNotification, object: nil)
        self.addInfoLabel()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = note.id {
            // do nothing.
        } else {
            self.textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // save note automatically
        NSNotificationCenter.defaultCenter().removeObserver(self)
        let trimCharacter = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        if textView.text.stringByTrimmingCharactersInSet(trimCharacter) != "" {
            saveNote()
        }
    }
    
    func keyboardDidChangeHeight(aNotification: NSNotification) {
        // 736 = 500 + 236
        let keyboardY = aNotification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.origin.y
        let keyboardH = UIApplication.sharedApplication().keyWindow!.bounds.height - keyboardY!
        tvbottomConstraint.constant = (-keyboardH)
    }
    
    func addInfoLabel() {
        let label = UILabel()
        label.text = "创建于: \(note.date) \(note.time)"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.lightGrayColor()
        label.sizeToFit()
        label.center = CGPointMake(view.center.x, -label.bounds.height / 2 - 5)
        textView.addSubview(label)
    }
    
    func saveNote() {
        textView.endEditing(true)
        note.title = textView.text
        note.summary = textView.text
        note?.save()
    }
}

// MARK: - text view delegate.

extension EditorViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        print(textView.text)
    }
}
