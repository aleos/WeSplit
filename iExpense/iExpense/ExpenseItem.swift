//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Alexander Ostrovsky on 10.08.2022.
//

import Foundation

struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}
