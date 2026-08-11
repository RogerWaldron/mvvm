//
//  TheViewModel.swift
//  test_mvvm
//
//  Created by Roger Waldron on 10/8/2026.
//

import Foundation
import Observation

@MainActor
@Observable
class TaskViewModel {
    var tasks: [Task] = [
        Task(title: "Buy Milk", isDone: false),
        Task(title: "Buy Eggs", isDone: false),
        Task(title: "Buy Bread", isDone: false),
        Task(title: "Buy Tea", isDone: false),
        Task(title: "Buy Cheese", isDone: false),
        Task(title: "Buy Dijon Mustard", isDone: false),
        Task(title: "Buy Tofu", isDone: false),
        Task(title: "Buy Carrots", isDone: false),
        Task(title: "Buy Onions", isDone: false)
    ]
    

    var todoTasks: [Task] {
        tasks.filter { !$0.isDone }
    }

    var doneTasks: [Task] {
        tasks.filter(\.isDone)
    }
    
    var doneCount: Int {
        tasks.filter(\.isDone).count
    }
    
    var doneProgress: Double {
        guard !tasks.isEmpty else { return 0 }
        return floor(Double(doneCount) / Double(tasks.count) * 100)
    }

    func addTask(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        tasks.append(Task(title: trimmedTitle, isDone: false))
    }

    func renameTask(_ task: Task, title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        guard let idx = tasks.firstIndex(where: { $0.id == task.id }) else { return }

        tasks[idx].title = trimmedTitle
    }

    func deleteTodoTasks(at offsets: IndexSet) {
        deleteTasks(todoTasks, at: offsets)
    }

    func deleteDoneTasks(at offsets: IndexSet) {
        deleteTasks(doneTasks, at: offsets)
    }

    func toggleTask(_ task: Task) {
        guard let idx = tasks.firstIndex(where: {$0.id == task.id}) else { return }
        tasks[idx].isDone.toggle()
    }

    private func deleteTasks(_ sectionTasks: [Task], at offsets: IndexSet) {
        let idsToDelete = Set(offsets.map { sectionTasks[$0].id })
        tasks.removeAll { idsToDelete.contains($0.id) }
    }
}
