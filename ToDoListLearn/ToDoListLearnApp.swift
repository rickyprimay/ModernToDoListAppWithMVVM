//
//  ToDoListLearnApp.swift
//  ToDoListLearn
//
//  Created by Ricky Primayuda Putra on 11/11/24.
//

import SwiftUI

@main
struct ToDoListLearnApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(TaskModel())
        }
    }
}
