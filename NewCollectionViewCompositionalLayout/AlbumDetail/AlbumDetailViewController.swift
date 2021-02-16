//
//  AlbumDetailViewController.swift
//  NewCollectionViewCompositionalLayout
//
//  Created by Amith Dubbasi on 2/15/21.
//

import Foundation
import UIKit

import UIKit

class AlbumDetailViewController: UIViewController {
  enum Section {
    case albumBody
  }

  var dataSource: UICollectionViewDiffableDataSource<Section, AlbumItemDetailViewModel>! = nil
  var albumDetailCollectionView: UICollectionView! = nil

  var albumURL: URL?

  convenience init(withPhotosFromDirectory directory: URL) {
    self.init()
    albumURL = directory
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = albumURL?.lastPathComponent.displayNicely
    configureCollectionView()
    configureDataSource()
  }
}

extension AlbumDetailViewController {
  func configureCollectionView() {
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
    view.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self
    collectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: PhotoItemCell.reuseIdentifer)
    albumDetailCollectionView = collectionView
  }

  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource
      <Section, AlbumItemDetailViewModel>(collectionView: albumDetailCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, detailItem: AlbumItemDetailViewModel) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PhotoItemCell.reuseIdentifer,
          for: indexPath) as? PhotoItemCell else { fatalError("Could not create new cell") }
        cell.photoURL = detailItem.thumbnailURL
        return cell
    }

    // load our initial data
    let snapshot = snapshotForCurrentState()
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  func generateLayout() -> UICollectionViewLayout {
    let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/2)),
        subitem: item,
        count: 2
    )
    
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }

  func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AlbumItemDetailViewModel> {
    var snapshot = NSDiffableDataSourceSnapshot<Section, AlbumItemDetailViewModel>()
    snapshot.appendSections([Section.albumBody])
    let items = itemsForAlbum()
    snapshot.appendItems(items)
    return snapshot
  }

  func itemsForAlbum() -> [AlbumItemDetailViewModel] {
    guard let albumURL = albumURL else { return [] }
    let fileManager = FileManager.default
    do {
      return try fileManager.albumDetailItemsAtURL(albumURL)
    } catch {
      print(error)
      return []
    }
  }
}

extension AlbumDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
  }
}
