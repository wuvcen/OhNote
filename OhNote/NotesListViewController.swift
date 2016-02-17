//
//  NotesListViewController.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit


class NotesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notes = [Note]()
    private let identifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        notes = Note.all()
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! EditorViewController
        destVC.note = sender as? Note
    }
    
    @IBAction func newNote() {
        self.performSegueWithIdentifier("toEditorVC", sender: Note())
    }

}

// MARK: - table view data source

extension NotesListViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        cell?.textLabel?.text = note.title
        return cell!
    }
    
}

// MARK: - table view delegate

extension NotesListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let note = notes[indexPath.row]
        note.loadHtml()
        self.performSegueWithIdentifier("toEditorVC", sender: note)
    }
}