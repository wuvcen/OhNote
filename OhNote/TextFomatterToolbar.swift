//
//  TextFomatterToolbar.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/25.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit

class TextFomatterToolbar: UIToolbar {
    
    weak var textView: UITextView?

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
        
    }
    
    @IBAction func underlineAction(sender: UIBarButtonItem) {
        
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
    
}
