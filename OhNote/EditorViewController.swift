//
//  EditorViewController.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit
let normalFontSize: CGFloat = 14.0
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
            .addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        addInfoLabel()
        configInputAccessoryView()
        textView.font = UIFont.systemFontOfSize(16)
        
        if let _ = note.id {
            do {
                try textView.attributedText = NSAttributedString(data: note.contentData, options: [NSDocumentTypeDocumentAttribute: NSRTFDTextDocumentType], documentAttributes: nil)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
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
    
    func keyboardDidShow(aNotification: NSNotification) {
        // 736 = 500 + 236
        let keyboardY = aNotification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.origin.y
        let keyboardH = UIApplication.sharedApplication().keyWindow!.bounds.height - keyboardY!
        tvbottomConstraint.constant = (-keyboardH)
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        tvbottomConstraint.constant = 0
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
        
        let cutLocation = NSString(string: textView.text).rangeOfString("\n").location
        
        if cutLocation < 1000 {
            note.title = textView.text.substringWithRange(NSMakeRange(0, cutLocation))
            let len = min(100, textView.text.length() - cutLocation)
            note.summary = textView.text.substringWithRange(NSMakeRange(cutLocation + 1, len - 1))
        } else {
            note.title = textView.text.substringWithRange(NSMakeRange(0, min(textView.text.length(), 20)))
            note.summary = "无附加文本！"
        }
        do {
            try note.contentData = textView.attributedText.dataFromRange(NSMakeRange(0, textView.attributedText.length), documentAttributes: [NSDocumentTypeDocumentAttribute: NSRTFDTextDocumentType])
        } catch {
        }
        note.save()
    }
    
    func configInputAccessoryView() {
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
    
    func textViewDidChange(textView: UITextView) {
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}

// MARK: - toolbar actions

extension EditorViewController {
    
    @IBAction func clearAction(sender: UIBarButtonItem) {
        let range = textView!.selectedRange
        if range.length > 0 {
            textView!.textStorage.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(normalFontSize), range: range)
        } else {
            let normalString = NSAttributedString(string: "Normal", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(normalFontSize)])
            
            let attrString = NSMutableAttributedString(attributedString: textView!.attributedText)
            attrString.insertAttributedString(normalString, atIndex: range.location)
            textView!.attributedText = attrString
            textView!.selectedRange = NSRange(location: range.location, length: normalString.length)
        }
    }
    
    @IBAction func h1Action(sender: UIBarButtonItem) {
        addHeadingString("Heading One",
            attrName: NSFontAttributeName,
            attrValue: UIFont.boldSystemFontOfSize(normalFontSize * 2.0),
            range: textView!.selectedRange)
    }
    
    @IBAction func h2Action(sender: UIBarButtonItem) {
        addHeadingString("Heading Two",
            attrName: NSFontAttributeName,
            attrValue: UIFont.boldSystemFontOfSize(normalFontSize * 1.7),
            range: textView!.selectedRange)
    }
    
    @IBAction func h3Action(sender: UIBarButtonItem) {
        addHeadingString("Heading Three",
            attrName: NSFontAttributeName,
            attrValue: UIFont.boldSystemFontOfSize(normalFontSize * 1.4),
            range: textView!.selectedRange)
    }
    
    @IBAction func deleteLineAction(sender: AnyObject) {
        addLine("Deleteline", attrName: NSStrikethroughStyleAttributeName, attrValue: 2, range: textView!.selectedRange)
    }
    
    @IBAction func underlineAction(sender: UIBarButtonItem) {
        addLine("Underline", attrName: NSUnderlineStyleAttributeName, attrValue: 1, range: textView!.selectedRange)
    }
    
    @IBAction func italicAction(sender: UIBarButtonItem) {
        addString("Italic", attrName: NSFontAttributeName, attrValue: UIFont.italicSystemFontOfSize(normalFontSize), range: textView!.selectedRange)
    }
    
    @IBAction func boldAction(sender: UIBarButtonItem) {
        addString("Bold", attrName: NSFontAttributeName, attrValue: UIFont.boldSystemFontOfSize(normalFontSize), range: textView!.selectedRange)
    }
    
    @IBAction func linkAction(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func imageAction(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.view.backgroundColor = UIColor.redColor()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func addHeadingString(headingString: String, attrName: String, attrValue: AnyObject, var range: NSRange) {
        if range.length > 0 { // replace
            
            let replaceString = "\n" + textView!.text.substringWithRange(range) + "\n"
            textView!.replaceRange(textView!.selectedTextRange!, withText: replaceString)
            textView!.selectedRange = NSRange(location: range.location + 1, length: range.length)
            
            range = textView!.selectedRange
            
        } else { // insert
            
            let newAttributed = NSAttributedString(string: "\n" + headingString + "\n", attributes: [attrName: attrValue])
            let textViewAttrString = NSMutableAttributedString(attributedString: textView!.attributedText)
            textViewAttrString.insertAttributedString(newAttributed, atIndex: range.location)
            
            textView!.attributedText = textViewAttrString
            textView!.selectedRange = NSRange(location: range.location + 1, length: newAttributed.length - 2)
            range = textView!.selectedRange
        }
        textView!.textStorage.addAttribute(attrName, value: attrValue, range: range)
    }
    
    func addString(newString: String, attrName: String, attrValue: AnyObject, var range: NSRange) {
        if range.length == 0 {
            let newAttributed = NSAttributedString(string: newString, attributes: [attrName: attrValue])
            let textViewAttrString = NSMutableAttributedString(attributedString: textView!.attributedText)
            textViewAttrString.insertAttributedString(newAttributed, atIndex: range.location)
            
            textView!.attributedText = textViewAttrString
            textView!.selectedRange = NSRange(location: range.location, length: newAttributed.length)
            range = textView!.selectedRange
        }
        textView!.textStorage.addAttribute(attrName, value: attrValue, range: range)
    }
    
    func addLine(newString: String, attrName: String, attrValue: AnyObject, var range: NSRange) {
        if range.length == 0 {
            let newAttributed = NSAttributedString(string: newString, attributes: [attrName: attrValue, NSFontAttributeName: UIFont.systemFontOfSize(normalFontSize)])
            let textViewAttrString = NSMutableAttributedString(attributedString: textView!.attributedText)
            textViewAttrString.insertAttributedString(newAttributed, atIndex: range.location)
            
            textView!.attributedText = textViewAttrString
            textView!.selectedRange = NSRange(location: range.location, length: newAttributed.length)
            range = textView!.selectedRange
        }
        textView!.textStorage.addAttribute(attrName, value: attrValue, range: range)
    }
}

// MARK: - image picker delegate

extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, var didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        image = resizedImage(image)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let scale = image.size.height / image.size.width
        let imageW = min(image.size.width, view.bounds.width - 30)
        let imageH = imageW * scale
        
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: imageW, height: imageH)
        
        let attrString = NSAttributedString(attachment: attachment)
        let returnAttrString = NSAttributedString(string: "\n")
        
        let originLocation = textView.selectedRange.location
        
        textView.textStorage.insertAttributedString(returnAttrString, atIndex: textView!.selectedRange.location)
        textView.textStorage.insertAttributedString(attrString, atIndex: textView!.selectedRange.location)
        textView.textStorage.insertAttributedString(returnAttrString, atIndex: textView!.selectedRange.location)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        
        textView.textStorage.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(originLocation, attrString.length + 2))
    }
    
    func resizedImage(image: UIImage) -> UIImage {
        if image.size.width < view.bounds.width {
            return image
        }
        let scale = image.size.height / image.size.width
        let viewWidth = view.bounds.width - 30
        let targetSize = CGSize(width: viewWidth, height: viewWidth * scale)
        UIGraphicsBeginImageContext(targetSize)
        let rect = CGRect(origin: CGPointZero, size: targetSize)
        image.drawInRect(rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

