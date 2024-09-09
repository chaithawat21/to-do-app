//
//  ContentView.swift
//  ToDo
//
//  Created by Chaithawat Pinsuwan on 9/9/2567 BE.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // Accesses the SwiftData context for managing data operations like insertion, deletion, and updates.
    @Environment(\.modelContext) private var context
    // Fetches all instances of the ToDo model, reacting automatically to changes.

    @Query var allToDos: [ToDo]
    // Manages the display of the sheet used for adding new tasks.
    @State private var isAddToDoSheetShowing = false
    // Holds the text input for new tasks.
    @State private var textField = ""
    
    
    var body: some View {
        NavigationStack {
            Group {
                if allToDos.isEmpty {
                    ContentUnavailableView("Nothing to do here!", systemImage: "list.bullet.clipboard")
                } else {
                    List {
                        ForEach(allToDos.sorted { $0.isDone && !$1.isDone}) { toDo in ToDoRowView(toDo: toDo)}
                    }
                }
            }
            .navigationTitle("ToDo")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddToDoSheetShowing.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $isAddToDoSheetShowing) {
                VStack {
                    TextField("Write to do", text: $textField)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Button("Save") {
                        persistData(for: ToDo(item: textField, isDone: false))
                        textField = ""
                        isAddToDoSheetShowing.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    func persistData(for toDo: ToDo) {
        context.insert(toDo)
        
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}



// ToDo View
struct ToDoRowView: View {
    @Environment(\.modelContext) private var context
    var toDo: ToDo
    
    var body: some View {
        HStack {
            Image(systemName: toDo.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(toDo.isDone ? .green : .black)
            
            Text(toDo.item)
                .strikethrough(toDo.isDone ? true : false)
                .foregroundStyle(toDo.isDone ? .secondary : .primary)
        }
        .swipeActions {
            Button(toDo.isDone ? "Not Done" : "Done" ) {
                toDo.isDone.toggle()
                // call a function
                persistData(for: toDo)
            }
            .tint(toDo.isDone ? .red : .green)
        }
    }
    
    func persistData(for toDo: ToDo) {
        context.insert(toDo)
        
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
}
