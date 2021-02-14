//
//  FileManagerExtensions.swift
//  NewCollectionViewCompositionalLayout
//
//  Created by Amith Dubbasi on 2/13/21.
//

import Foundation

extension FileManager {
  func albumsAtURL(_ fileURL: URL) throws -> [AlbumItemViewModel] {
    let albumsArray = try self.contentsOfDirectory(
      at: fileURL,
      includingPropertiesForKeys: [.nameKey, .isDirectoryKey],
      options: .skipsHiddenFiles
    ).filter { (url) -> Bool in
      do {
        let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
        return resourceValues.isDirectory! && url.lastPathComponent.first != "_"
      } catch { return false }
    }.sorted(by: { (urlA, urlB) -> Bool in
      do {
        let nameA = try urlA.resourceValues(forKeys:[.nameKey]).name
        let nameB = try urlB.resourceValues(forKeys: [.nameKey]).name
        return nameA! < nameB!
      } catch { return true }
    })

    return albumsArray.map { fileURL -> AlbumItemViewModel in
      do {
        let detailItems = try self.albumDetailItemsAtURL(fileURL)
        return AlbumItemViewModel(albumURL: fileURL, imageItems: detailItems)
      } catch {
        return AlbumItemViewModel(albumURL: fileURL)
      }
    }
  }

  func albumDetailItemsAtURL(_ fileURL: URL) throws -> [AlbumItemDetailViewModel] {
    guard let components = URLComponents(url: fileURL, resolvingAgainstBaseURL: false) else { return [] }

    let photosArray = try self.contentsOfDirectory(
      at: fileURL,
      includingPropertiesForKeys: [.nameKey, .isDirectoryKey],
      options: .skipsHiddenFiles
    ).filter { (url) -> Bool in
      do {
        let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
        return !resourceValues.isDirectory!
      } catch { return false }
    }.sorted(by: { (urlA, urlB) -> Bool in
      do {
        let nameA = try urlA.resourceValues(forKeys:[.nameKey]).name
        let nameB = try urlB.resourceValues(forKeys: [.nameKey]).name
        return nameA! < nameB!
      } catch { return true }
    })

    return photosArray.map { fileURL in AlbumItemDetailViewModel(
      photoURL: fileURL,
      thumbnailURL: URL(fileURLWithPath: "\(components.path)thumbs/\(fileURL.lastPathComponent)")
      )}
  }
}
