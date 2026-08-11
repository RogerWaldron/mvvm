//
//  Model.swift
//  test_mvvm
//
//  Created by Roger Waldron on 10/8/2026.
//
import Foundation

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isDone: Bool
}
