//
//  ToDoApp.swift
//  ToDo
//
//  Created by Chaithawat Pinsuwan on 9/9/2567 BE.
//

import SwiftUI
import SwiftData


// Model
@Model class ToDo {
    var item: String
    var isDone: Bool
    
    init(item: String, isDone: Bool) {
        self.item = item
        self.isDone = isDone
    }
}

@main
struct ToDoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ToDo.self])
        }
    }
}

