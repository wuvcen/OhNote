//
//  NoteCell.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/18.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import Foundation
import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var note: Note! {
        didSet {
            titleLabel.text = note.title
            summaryLabel.text = note.summary
            timeLabel.text = note.time
        }
    }
}
