//
//  EditorViewController.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    var note: Note!
    var isEditing: Bool! {
        didSet {
            rightBarButtonItem.title = isEditing! ? "Save" : "Edit"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Created at:\n" + note.date + " " + note.time)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11), range: NSMakeRange(0, attributedText.length))
        
        label.textAlignment = .Center
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        
        let titleView = UIView()
        titleView.bounds = label.bounds
        titleView.addSubview(label)
        
        self.navigationItem.titleView = titleView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = note.id {
            isEditing = false
        } else {
            isEditing = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = note.id {
            // do nothing.
        } else {
        }
    }
    
    @IBAction func didClickRightBarButtonItem() {
        if isEditing == true {
            textView.endEditing(true)
            
            let text = textView.text as NSString
            note?.save()
        } else {
            textView.becomeFirstResponder()
        }
    }
}
