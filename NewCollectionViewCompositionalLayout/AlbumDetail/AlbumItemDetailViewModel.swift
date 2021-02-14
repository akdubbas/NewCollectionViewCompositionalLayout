//
//  AlbumItemDetailViewModel.swift
//  NewCollectionViewCompositionalLayout
//
//  Created by Amith Dubbasi on 2/13/21.
//

import Foundation

class AlbumItemDetailViewModel: Hashable {
    private let identifier = UUID()
    let photoURL: URL
    let thumbnailURL: URL
    let subitems: [AlbumItemDetailViewModel]

    init(photoURL: URL, thumbnailURL: URL, subitems: [AlbumItemDetailViewModel] = []) {
      self.photoURL = photoURL
      self.thumbnailURL = thumbnailURL
      self.subitems = subitems
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: AlbumItemDetailViewModel, rhs: AlbumItemDetailViewModel) -> Bool {
      return lhs.identifier == rhs.identifier
    }
}
