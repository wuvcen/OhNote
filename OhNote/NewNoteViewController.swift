//
//  NewNoteViewController.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit
import RichEditorView

class NewNoteViewController: UIViewController {

    @IBOutlet weak var editorView: RichEditorView!
    var note: Note? = Note()
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorOptions.all()
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configEditorView()
        print(note?.date)
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
        addCustomEditorToolbarItems()
    }
    
    func addCustomEditorToolbarItems() {
        // Clear button
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar?.editor?.setHTML("")
        }
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
    }
    
    func randomColor() -> UIColor {
        let colors = [
            UIColor.redColor(),
            UIColor.orangeColor(),
            UIColor.yellowColor(),
            UIColor.greenColor(),
            UIColor.blueColor(),
            UIColor.purpleColor()
        ]
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
}

extension NewNoteViewController: RichEditorDelegate {
    
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

extension NewNoteViewController: RichEditorToolbarDelegate {
    
    func richEditorToolbarChangeTextColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
    
    func richEditorToolbarInsertImage(toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("http://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }
    
    func richEditorToolbarInsertLink(toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if let hasSelection = toolbar.editor?.rangeSelectionExists() where hasSelection {
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
}
