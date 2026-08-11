//
//  TaskRow.swift
//  test_mvvm
//
//  Created by Roger Waldron on 10/8/2026.
//

import SwiftUI

struct TaskRow: View {
    let task: Task
    let onToggle: @MainActor () -> Void
    let onRename: @MainActor () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack {
                Text(task.title)
                    .foregroundStyle(task.isDone ? .secondary : .primary)
                Spacer()
                Image(systemName: task.isDone ? "checkmark.square" : "square")
                    .foregroundStyle(task.isDone ? .green : .secondary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(task.title)
        .accessibilityValue(task.isDone ? "Done" : "Todo")
        .accessibilityHint("Toggles task completion")
        .accessibilityIdentifier("task_\(task.id)")
        .swipeActions(edge: .leading) {
            Button("Rename", systemImage: "pencil", action: onRename)
                .tint(.blue)
        }
    }
}

#Preview {
    List {
        TaskRow(
            task: Task(title: "Buy Milk", isDone: false),
            onToggle: {},
            onRename: {}
        )
    }
}
