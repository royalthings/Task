//
//  Task.swift
//  TaskList
//
//  Created by Дмитрий Ага on 7/6/19.
//  Copyright © 2019 Дмитрий Ага. All rights reserved.
//

import Foundation
import Firebase

class Task {
    private var _task: String
    private var _userId: String
    private var _completed: Bool
    let ref: DatabaseReference?
    
    var task: String {
        return _task
    }
    var userId: String {
        return _userId
    }
    
    var completed: Bool {
        return _completed
    }
    
    init(task: String, userId: String, completed: Bool) {
        _task = task
        _userId = userId
        _completed = completed
        ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        _task = snapshotValue["task"] as! String
        _userId = snapshotValue["userId"] as! String
        _completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
}
