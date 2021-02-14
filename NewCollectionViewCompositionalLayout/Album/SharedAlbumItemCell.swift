//  SharedAlbumItemCell.swift
//  NewCollectionViewCompositionalLayout
//
//  Created by Amith Dubbasi on 2/13/21.
//

import Foundation
import UIKit

class SharedAlbumItemCell: UICollectionViewCell {
  static let reuseIdentifer = "shared-album-item-cell-reuse-identifier"
  let titleLabel = UILabel()
  let ownerLabel = UILabel()
  let featuredPhotoView = UIImageView()
  let ownerthumbNail = UIImageView()
  let contentContainer = UIView()

  let owner: Owner;

  enum Owner: Int, CaseIterable {
    case amith
    
    func avatar() -> UIImage {
        return #imageLiteral(resourceName: "amith_profile")
    }

    func name() -> String {
        return "amith"
    }
  }

  var title: String? {
    didSet {
      configure()
    }
  }

  var featuredPhotoURL: URL? {
    didSet {
      configure()
    }
  }

  override init(frame: CGRect) {
    self.owner = Owner.allCases.randomElement()!
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension SharedAlbumItemCell {
  func configure() {
    contentContainer.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(featuredPhotoView)
    contentView.addSubview(contentContainer)

    featuredPhotoView.translatesAutoresizingMaskIntoConstraints = false
    if let featuredPhotoURL = featuredPhotoURL {
      featuredPhotoView.image = UIImage(contentsOfFile: featuredPhotoURL.path)
    }
    featuredPhotoView.layer.cornerRadius = 4
    featuredPhotoView.clipsToBounds = true
    contentContainer.addSubview(featuredPhotoView)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    titleLabel.adjustsFontForContentSizeCategory = true
    contentContainer.addSubview(titleLabel)

    ownerLabel.translatesAutoresizingMaskIntoConstraints = false
    ownerLabel.text = "From \(owner.name())"
    ownerLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    ownerLabel.adjustsFontForContentSizeCategory = true
    ownerLabel.textColor = .placeholderText
    contentContainer.addSubview(ownerLabel)

    ownerthumbNail.translatesAutoresizingMaskIntoConstraints = false
    ownerthumbNail.image = owner.avatar()
    ownerthumbNail.layer.cornerRadius = 15
    ownerthumbNail.layer.borderColor = UIColor.systemBackground.cgColor
    ownerthumbNail.layer.borderWidth = 1
    ownerthumbNail.clipsToBounds = true
    ownerthumbNail.contentMode = .scaleAspectFit
    contentContainer.addSubview(ownerthumbNail)

    let spacing = CGFloat(10)
    NSLayoutConstraint.activate([
      contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
      contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      featuredPhotoView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
      featuredPhotoView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
      featuredPhotoView.topAnchor.constraint(equalTo: contentContainer.topAnchor),

      titleLabel.topAnchor.constraint(equalTo: featuredPhotoView.bottomAnchor, constant: spacing),
      titleLabel.leadingAnchor.constraint(equalTo: featuredPhotoView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: featuredPhotoView.trailingAnchor),

      ownerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      ownerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      ownerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      ownerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      ownerthumbNail.heightAnchor.constraint(equalToConstant: 30),
      ownerthumbNail.widthAnchor.constraint(equalToConstant: 30),
      ownerthumbNail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
      ownerthumbNail.bottomAnchor.constraint(equalTo: featuredPhotoView.bottomAnchor, constant: -spacing),
    ])
  }
}
