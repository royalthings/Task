//
//  DataService.swift
//  TaskList
//
//  Created by Дмитрий Ага on 7/5/19.
//  Copyright © 2019 Дмитрий Ага. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_TASKS = DB_BASE.child("tasks")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_TASKS: DatabaseReference {
        return _REF_TASKS
    }

    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadTask(withMessage message: String, forUID uid: String, completed: Bool, addComplete: @escaping (_ status: Bool) -> ()) {
        REF_TASKS.childByAutoId().updateChildValues(["task": message, "userId": uid, "completed": completed])
        addComplete(true)
    }
    
    func getTasks(handler: @escaping (_ returnedTasks: [Task]) -> ()) {
        var taskArray = [Task]()
        REF_TASKS.observeSingleEvent(of: .value) { (taskSnapshot) in
            guard let taskSnapshot = taskSnapshot.children.allObjects as? [DataSnapshot] else { return }
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            for task in taskSnapshot {
                let content = task.childSnapshot(forPath: "task").value as! String
                let userId = task.childSnapshot(forPath: "userId").value as! String
                let completed = task.childSnapshot(forPath: "completed").value as! Bool
                if currentUser == userId {
                    let task = Task(task: content, userId: userId, completed: completed)
                    taskArray.append(task)
                }
            }
            handler(taskArray)
        }
        
    }
    
}
