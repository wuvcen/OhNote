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
        cell?.detailTextLabel?.text = note.time
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
}

// MARK: - table view delegate

extension NotesListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let note = notes[indexPath.row]
        self.performSegueWithIdentifier("toEditorVC", sender: note)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alertController = UIAlertController(title: "Delete this note?", message: "", preferredStyle: .Alert)
            let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                // FIXME: Hide 'Delete' button with animation.
            })
            let actionYes = UIAlertAction(title: "Yes", style: .Destructive, handler: { (action: UIAlertAction) -> Void in
                let note = self.notes[indexPath.row]
                note.remove()
                self.notes.removeAtIndex(indexPath.row)
                tableView.reloadData()
            })
            alertController.addAction(actionCancel)
            alertController.addAction(actionYes)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}