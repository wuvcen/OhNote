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
    
    @IBOutlet var toolbar: UIToolbar!
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
        addInfoLabel()
        configInputAccessoryView()
        textView.font = UIFont.systemFontOfSize(16)
        do {
            try textView.attributedText = NSAttributedString(data: note.contentData, options: [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType], documentAttributes: nil)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
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
        do {
            try note.contentData = textView.attributedText.dataFromRange(NSMakeRange(0, textView.attributedText.length), documentAttributes: [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType])
        } catch {
        }
        note?.save()
    }
    
    func configInputAccessoryView() {
        let tb = toolbar as! TextFomatterToolbar
        tb.textView = textView
        let scrollView = UIScrollView(frame: CGRectMake(0, 0, view.bounds.width, 44))
        scrollView.contentSize = toolbar.bounds.size
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.addSubview(toolbar)
        let perfectWidth = max(toolbar.bounds.width, view.bounds.width)
        toolbar.frame = CGRect(x: 0, y: 0, width: perfectWidth, height: 44)
        textView.inputAccessoryView = scrollView
    }
}

// MARK: - text view delegate.

extension EditorViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        //
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
