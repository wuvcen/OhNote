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
            let html = textView.text
            note?.html = html
            
            let text = textView.text as NSString
            note?.summary = text.substringWithRange(NSRange(location: 0, length: min(text.length, 10))) as String
            note?.save()
        } else {
            textView.becomeFirstResponder()
        }
    }
}
