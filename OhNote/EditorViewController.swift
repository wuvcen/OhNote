//
//  EditorViewController.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit
import RichEditorView

class EditorViewController: UIViewController {
    
    @IBOutlet weak var editorView: RichEditorView!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorOptions.all()
        return toolbar
    }()
    var note: Note!
    var isEditing: Bool! {
        didSet {
            rightBarButtonItem.title = (isEditing == true) ? "Save" : "Edit"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configEditorView()
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
            editorView.focus()
        }
    }
    
    func configEditorView() {
        editorView.delegate = self
        editorView.setHTML(note.html)
        editorView.inputAccessoryView = toolbar
        toolbar.delegate = self
        toolbar.editor = editorView
        configEditorToolbarItems()
    }
    
    func configEditorToolbarItems() {
        let options: [RichEditorOptions] = [
            .Clear, .Undo, .Redo, .Bold,.Italic, .Strike,.Underline, .TextColor,
            .TextBackgroundColor,.Header(1), .Header(2),.Header(3), .Indent,
            .Outdent, .OrderedList, .UnorderedList, .Image, .Link
        ]
        toolbar.options.removeAll()
        for option in options {
            toolbar.options.append(option)
        }
        // Add clear button
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar?.editor?.setHTML("")
        }
        toolbar.options.append(item)
    }
    
    @IBAction func didClickRightBarButtonItem() {
        if isEditing == true {
            
            editorView.endEditing(true)
            let html = editorView.getHTML()
            note?.html = html
            
            let text = editorView.getText() as NSString
            note?.summary = text.substringWithRange(NSRange(location: 0, length: min(text.length, 20))) as String
            note?.save()
        } else {
            editorView.focus()
        }
    }
}

// MARK: - editor view delegate

extension EditorViewController: RichEditorDelegate {
    
    func richEditorTookFocus(editor: RichEditorView) {
        isEditing = true
    }
    
    func richEditorLostFocus(editor: RichEditorView) {
        isEditing = false
    }
    
    func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool {
        return true
    }
    
    func richEditor(editor: RichEditorView, handleCustomAction action: String) {
        //
    }
}

// MARK: - tool bar delegate

extension EditorViewController: RichEditorToolbarDelegate {
    
    func richEditorToolbarInsertImage(toolbar: RichEditorToolbar) {
        // toolbar.editor?.insertImage("", alt: "")
    }
    
    func richEditorToolbarInsertLink(toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if let hasSelection = toolbar.editor?.rangeSelectionExists() where hasSelection {
            // toolbar.editor?.insertLink("", title: "")
        }
    }
}
