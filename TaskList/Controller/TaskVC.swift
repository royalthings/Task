//
//  ViewController.swift
//  TaskList
//
//  Created by Дмитрий Ага on 7/5/19.
//  Copyright © 2019 Дмитрий Ага. All rights reserved.
//

import UIKit
import Firebase

class TaskVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - var
    var taskArray = [Task]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "tasks")
        
        //MARK: - get tasks
        DataService.instance.getTasks { [weak self] (returnedTasksArray) in
            self?.taskArray = returnedTasksArray
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        ref.observe(.value) { [weak self] (snapshot) in
            var _tasks = [Task]()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                guard let currentUser = Auth.auth().currentUser?.uid else { return }
                if currentUser == task.userId {
                    _tasks.append(task)
                }
            }
            self?.taskArray = _tasks
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    

    @IBAction func addBtnWasPressed(_ sender: Any) {
        
        //MARK: - create alertCantroller
        let alertController = UIAlertController(title: "New Task", message: "Add new task!", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            guard let userId = Auth.auth().currentUser?.uid else { return }
            guard let massage = textField.text else { return }
            print(userId)
            //MARK: - create task
            DataService.instance.uploadTask(withMessage: massage, forUID: userId, completed: false, addComplete: { (isComplete) in
                if isComplete {
                    print("OK")
                } else {
                    print("Error")
                }
            })
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        
        //MARK: - exit from profile
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { [weak self](buttonTapped) in
            do {
                try Auth.auth().signOut()
                guard let authVC = self?.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC else { return }
                self?.present(authVC, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    //MARK: - add checkmark
    func toggleCompletion(_ cell: UITableViewCell, iscompeted: Bool) {
        cell.accessoryType = iscompeted ? .checkmark : .none
    }
    
}
//MARK: - extension UITableViewDelegate, UITableViewDataSource
extension TaskVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskCell else { return UITableViewCell() }
        let task = taskArray[indexPath.row]
        cell.configureCell(task: task.task)
        
        let isCompleted = task.completed
        toggleCompletion(cell, iscompeted: isCompleted)

        return cell
    }
    
    //MARK: - add delete button to cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskArray[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    //add checkmark
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = taskArray[indexPath.row]
       
        let isCompleted = !task.completed
        toggleCompletion(cell, iscompeted: isCompleted)
        
        task.ref?.updateChildValues(["completed": isCompleted])
    } 
}

