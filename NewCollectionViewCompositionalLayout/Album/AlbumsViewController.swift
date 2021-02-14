
//  AlbumViewController.swift
//  NewCollectionViewCompositionalLayout
//
//  Created by Amith Dubbasi on 2/13/21.
//

import Foundation
import UIKit

class AlbumsViewController: UIViewController {
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    enum Section: String, CaseIterable {
      case featuredAlbums = "Featured Albums"
      case sharedAlbums = "Shared Albums"
      case myAlbums = "My Albums"
    }
    
    var albumsCollectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, AlbumItemViewModel>! = nil
    var baseURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Your Albums"
        configureCollectionView()
        configureDataSource()
    }
    
    convenience init(withAlbumsFromDirectory directory: URL) {
      self.init()
      baseURL = directory
    }
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(MyAlbumItemCell.self, forCellWithReuseIdentifier: MyAlbumItemCell.reuseIdentifer)
        collectionView.register(FeaturedAlbumItemCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedAlbumItemCollectionViewCell.reuseIdentifer)
        collectionView.register(SharedAlbumItemCell.self, forCellWithReuseIdentifier: SharedAlbumItemCell.reuseIdentifer)
        collectionView.register(
          HeaderViewCollectionReusableView.self,
          forSupplementaryViewOfKind: AlbumsViewController.sectionHeaderElementKind,
          withReuseIdentifier: HeaderViewCollectionReusableView.reuseIdentifier)
        albumsCollectionView = collectionView
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AlbumItemViewModel>(collectionView: albumsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, albumItem: AlbumItemViewModel) -> UICollectionViewCell? in
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType {
            case .featuredAlbums:
              guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedAlbumItemCollectionViewCell.reuseIdentifer,
                for: indexPath) as? FeaturedAlbumItemCollectionViewCell else { fatalError("Could not create new cell") }
              cell.featuredPhotoURL = albumItem.imageItems[0].thumbnailURL
              cell.title = albumItem.albumTitle
              cell.totalNumberOfImages = albumItem.imageItems.count
              return cell

            case .sharedAlbums:
              guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SharedAlbumItemCell.reuseIdentifer,
                for: indexPath) as? SharedAlbumItemCell else { fatalError("Could not create new cell") }
              cell.featuredPhotoURL = albumItem.imageItems[0].thumbnailURL
              cell.title = albumItem.albumTitle
              return cell

            case .myAlbums:
              guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyAlbumItemCell.reuseIdentifer,
                for: indexPath) as? MyAlbumItemCell else { fatalError("Could not create new cell") }
              cell.featuredPhotoURL = albumItem.imageItems[0].thumbnailURL
              cell.title = albumItem.albumTitle
              return cell
            }
        }
        
        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
              ofKind: kind,
              withReuseIdentifier: HeaderViewCollectionReusableView.reuseIdentifier,
              for: indexPath) as? HeaderViewCollectionReusableView else { fatalError("Cannot create header view") }

            supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
            return supplementaryView
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func generateLayout() -> UICollectionViewLayout {
      let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500

        let sectionLayoutKind = Section.allCases[sectionIndex]
        switch (sectionLayoutKind) {
        case .featuredAlbums: return self.generateFeaturedAlbumsLayout(isWide: isWideView)
        case .sharedAlbums: return self.generateSharedlbumsLayout()
        case .myAlbums: return self.generateMyAlbumsLayout(isWide: isWideView)
        }
      }
      return layout
    }

    func generateFeaturedAlbumsLayout(isWide: Bool) -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .fractionalWidth(2/3))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      // Show one item plus peek on narrow screens, two items plus peek on wider screens
      let groupFractionalWidth = isWide ? 0.475 : 0.95
      let groupFractionalHeight: Float = isWide ? 1/3 : 2/3
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
        heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitem: item,
        count: 1)
      group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: AlbumsViewController.sectionHeaderElementKind, alignment: .top)

      let section = NSCollectionLayoutSection(group: group)
      section.boundarySupplementaryItems = [sectionHeader]
      section.orthogonalScrollingBehavior = .groupPaging

      return section
    }

    func generateSharedlbumsLayout() -> NSCollectionLayoutSection {
        
        //Full width and height of the group
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1/2),
        heightDimension: .fractionalHeight(1/3))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
      group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

      let headerSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44))
        
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: AlbumsViewController.sectionHeaderElementKind,
        alignment: .top)

      let section = NSCollectionLayoutSection(group: group)
      section.boundarySupplementaryItems = [sectionHeader]
      section.orthogonalScrollingBehavior = .groupPaging

      return section
    }

    func generateMyAlbumsLayout(isWide: Bool) -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

      let groupHeight = NSCollectionLayoutDimension.fractionalWidth(isWide ? 0.25 : 0.5)
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: groupHeight)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: isWide ? 4 : 2)

      let headerSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44))
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: AlbumsViewController.sectionHeaderElementKind,
        alignment: .top)

      let section = NSCollectionLayoutSection(group: group)
      section.boundarySupplementaryItems = [sectionHeader]

      return section
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AlbumItemViewModel> {
      let allAlbums = albumsInBaseDirectory()
      let sharingSuggestions = Array(albumsInBaseDirectory().prefix(3))
      let sharedAlbums = Array(albumsInBaseDirectory().suffix(3))

      var snapshot = NSDiffableDataSourceSnapshot<Section, AlbumItemViewModel>()
      snapshot.appendSections([Section.featuredAlbums])
      snapshot.appendItems(sharingSuggestions)

      snapshot.appendSections([Section.sharedAlbums])
      snapshot.appendItems(sharedAlbums)

      snapshot.appendSections([Section.myAlbums])
      snapshot.appendItems(allAlbums)
      return snapshot
    }

    func albumsInBaseDirectory() -> [AlbumItemViewModel] {
      guard let baseURL = baseURL else { return [] }

      let fileManager = FileManager.default
      do {
        return try fileManager.albumsAtURL(baseURL)
      } catch {
        print(error)
        return []
      }
    }
}

extension AlbumsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//    let albumDetailVC = AlbumDetailViewController(withPhotosFromDirectory: item.albumURL)
//    navigationController?.pushViewController(albumDetailVC, animated: true)
  }
}

