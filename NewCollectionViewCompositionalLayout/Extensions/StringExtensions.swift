//
//  StringExtensions.swift
//  NewCollectionViewCompositionalLayout
//
//  Created by Amith Dubbasi on 2/13/21.
//

import Foundation
import Foundation

extension StringProtocol {
  var firstUppercased: String {
    return prefix(1).uppercased() + dropFirst()
  }

  var displayNicely: String {
    return firstUppercased.replacingOccurrences(of: "_", with: " ")
  }
}
