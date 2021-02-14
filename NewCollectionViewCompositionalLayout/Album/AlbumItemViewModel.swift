
//  AlbumItemViewModel.swift
//  NewCollectionViewCompositionalLayout
//
//  Created by Amith Dubbasi on 2/13/21.
//

import Foundation

class AlbumItemViewModel: Hashable {
    
    private let uniqueIdentifier = UUID()
    let albumURL: URL
    let albumTitle: String
    let imageItems: [AlbumItemDetailViewModel]

    init(albumURL: URL, imageItems: [AlbumItemDetailViewModel] = []) {
      self.albumURL = albumURL
      self.albumTitle = albumURL.lastPathComponent.displayNicely
      self.imageItems = imageItems
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueIdentifier)
    }
    
    static func == (lhs: AlbumItemViewModel, rhs: AlbumItemViewModel) -> Bool {
        return lhs.uniqueIdentifier == rhs.uniqueIdentifier
    }
}
