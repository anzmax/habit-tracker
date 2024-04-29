//
//  String+Ext.swift
//  Habit-Tracker
//
//  Created by Lika Maksimovic on 29.04.2024.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
