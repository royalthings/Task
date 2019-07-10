//
//  TaskCell.swift
//  TaskList
//
//  Created by Дмитрий Ага on 7/6/19.
//  Copyright © 2019 Дмитрий Ага. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    
    @IBOutlet weak var taskLbl: UILabel!
    
    func configureCell(task: String) {
        taskLbl.text = task
    }
}
