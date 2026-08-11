//
//  ContentView.swift
//  test_mvvm
//
//  Created by Roger Waldron on 10/8/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = TaskViewModel()
    @State private var taskTitle = ""
    @State private var taskEditorMode: TaskEditorMode?

    var body: some View {
        NavigationStack {
            List {
                Section("Todo") {
                    ForEach(viewModel.todoTasks) { task in
                        TaskRow(
                            task: task,
                            isDone: isDoneBinding(for: task),
                            onRename: {
                                startRenaming(task)
                            }
                        )
                    }
                    .onDelete { offsets in
                        viewModel.deleteTodoTasks(at: offsets)
                    }
                }

                Section("Done (\(viewModel.doneProgress, specifier: "%.0f") %)") {
                    ForEach(viewModel.doneTasks) { task in
                        TaskRow(
                            task: task,
                            isDone: isDoneBinding(for: task),
                            onRename: {
                                startRenaming(task)
                            }
                        )
                    }
                    .onDelete { offsets in
                        viewModel.deleteDoneTasks(at: offsets)
                    }
                }

                Section {
                    VStack(alignment: .leading) {
                        Text("Use checkbox to toggle completion")
                        Text("Swipe Left to delete task")
                        Text("Swipe Right to rename task")
                    }
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color(.systemBackground))
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                Button("Add Task", systemImage: "plus") {
                    startAddingTask()
                }
            }
            .alert(taskEditorTitle, isPresented: isShowingTaskEditor) {
                TextField("Task title", text: $taskTitle)
                Button(taskEditorActionTitle) {
                    saveTaskEditor()
                }
                Button("Cancel", role: .cancel) {
                    resetTaskEditor()
                }
            }
        }
    }

    private var isShowingTaskEditor: Binding<Bool> {
        Binding {
            taskEditorMode != nil
        } set: { isShowing in
            if !isShowing {
                resetTaskEditor()
            }
        }
    }

    private var taskEditorTitle: String {
        switch taskEditorMode {
        case .add, .none:
            "Add Task"
        case .rename:
            "Rename Task"
        }
    }

    private var taskEditorActionTitle: String {
        switch taskEditorMode {
        case .add, .none:
            "Add"
        case .rename:
            "Save"
        }
    }

    private func startAddingTask() {
        taskTitle = ""
        taskEditorMode = .add
    }

    private func startRenaming(_ task: Task) {
        taskTitle = task.title
        taskEditorMode = .rename(task)
    }

    private func saveTaskEditor() {
        switch taskEditorMode {
        case .add:
            viewModel.addTask(title: taskTitle)
        case .rename(let task):
            viewModel.renameTask(task, title: taskTitle)
        case .none:
            break
        }

        resetTaskEditor()
    }

    private func resetTaskEditor() {
        taskTitle = ""
        taskEditorMode = nil
    }

    private func isDoneBinding(for task: Task) -> Binding<Bool> {
        Binding {
            viewModel.isTaskDone(task)
        } set: { isDone in
            viewModel.setTask(task, isDone: isDone)
        }
    }

    private enum TaskEditorMode {
        case add
        case rename(Task)
    }
}

#Preview {
    ContentView()
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
