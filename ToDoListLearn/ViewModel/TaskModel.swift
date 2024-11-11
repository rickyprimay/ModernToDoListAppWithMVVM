//
//  TaskModel.swift
//  ToDoListLearn
//
//  Created by Ricky Primayuda Putra on 11/11/24.
//

import Foundation
import SwiftUI
import Combine

class TaskModel: ObservableObject {
    @Published var newTask: String = ""
    @Published var tasks: [Task] = []
    
    func onAdd(task: String){
        tasks.append(Task(task: task))
        self.newTask = ""
    }
    
    func onDelete(offset: IndexSet){
        tasks.remove(atOffsets: offset)
    }
    
    func onMove(source: IndexSet, destination: Int){
        tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    func onUpdate(index: Int, task: String){
        tasks[index].task = task
    }
}
