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
    
    private var editor: RichEditorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editor = RichEditorView(frame: view.bounds)
        editor?.setHTML("<p>haha</p>")
        view.addSubview(editor)
        
        let toolbar = RichEditorToolbar(frame: CGRectMake(0, 0, view.bounds.width, 44))
        toolbar.options = RichEditorOptions.all()
        toolbar.editor = editor
    }

}
