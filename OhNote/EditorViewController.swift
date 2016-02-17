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
    var note: Note!
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorOptions.all()
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configEditorView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        editorView.focus()
    }
    
    func configEditorView() {
        editorView.delegate = self
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
    
    @IBAction func saveNote() {
        let html = editorView.getHTML()
        note?.html = html
        
        let text = editorView.getText() as NSString
        note!.title = text.substringWithRange(NSRange(location: 0, length: min(text.length, 20))) as String
        note?.summary = text.substringWithRange(NSRange(location: 0, length: min(text.length, 50))) as String
        note?.save()
    }
}

extension EditorViewController: RichEditorDelegate {
    
    func richEditor(editor: RichEditorView, heightDidChange height: Int) {
        //
    }
    
    func richEditor(editor: RichEditorView, contentDidChange content: String) {
        //
    }
    
    func richEditorTookFocus(editor: RichEditorView) {
        //
    }
    
    func richEditorLostFocus(editor: RichEditorView) {
        //
    }
    
    func richEditorDidLoad(editor: RichEditorView) {
        //
    }
    
    func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool {
        return true
    }
    
    func richEditor(editor: RichEditorView, handleCustomAction action: String) {
        //
    }
}

extension EditorViewController: RichEditorToolbarDelegate {
    
    func richEditorToolbarChangeTextColor(toolbar: RichEditorToolbar) {
        // toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(toolbar: RichEditorToolbar) {
        // toolbar.editor?.setTextBackgroundColor(color)
    }
    
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
