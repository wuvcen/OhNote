//
//  NoteCell.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/18.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import Foundation
import UIKit

private let margin: CGFloat = 5.0

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    
//    @IBOutlet weak var titleLabel: UILabel! {
//        didSet {
//            titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3)
//        }
//    }
//    
//    @IBOutlet weak var summaryLabel: UILabel!{
//        didSet {
//            summaryLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
//        }
//    }
    
//    @IBOutlet weak var timeLabel: UILabel!
    
    var note: Note! {
        didSet {
            let attrTitle = NSAttributedString(
                string: note.title,
                attributes: [
                    NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
                ]
            )
            let attrSummary = NSAttributedString(
                string: note.summary,
                attributes: [
                    NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
                ]
            )
//            let para = 
        }
    }
}
