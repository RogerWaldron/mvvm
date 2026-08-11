//
//  TaskRow.swift
//  test_mvvm
//
//  Created by Roger Waldron on 10/8/2026.
//

import SwiftUI

struct TaskRow: View {
    let task: Task
    @Binding var isDone: Bool
    let onRename: @MainActor () -> Void

    var body: some View {
        Toggle(isOn: $isDone) {
            Text(task.title)
                .foregroundStyle(isDone ? .secondary : .primary)
        }
        .adaptiveTaskToggleStyle()
        .accessibilityValue(isDone ? "Done" : "Todo")
        .accessibilityIdentifier("task_\(task.id)")
        .swipeActions(edge: .leading) {
            Button("Rename", systemImage: "pencil", action: onRename)
                .tint(.blue)
        }
    }
}

private extension View {
    @ViewBuilder
    func adaptiveTaskToggleStyle() -> some View {
        #if os(macOS)
        toggleStyle(.checkbox)
        #else
        toggleStyle(.automatic)
        #endif
    }
}

#Preview {
    List {
        TaskRow(
            task: Task(title: "Buy Milk", isDone: false),
            isDone: .constant(false),
            onRename: {}
        )
    }
}
