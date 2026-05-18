//
//  SportTableViewCell.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import UIKit

final class SportTableViewCell: UITableViewCell {

    // MARK: - UI Elements

    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: Constants.Layout.eventCellWidth,
            height: Constants.Layout.eventCellHeight
        )
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: Constants.Layout.horizontalPadding,
            bottom: 0,
            right: Constants.Layout.horizontalPadding
        )

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(EventCell.self, forCellWithReuseIdentifier: Constants.ReuseID.eventCell)
        return cv
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.noEvents
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.18, alpha: 1.0)
        selectionStyle = .none

        contentView.addSubview(collectionView)
        contentView.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            collectionView.heightAnchor.constraint(equalToConstant: Constants.Layout.collectionViewHeight),

            emptyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    // MARK: - Configure

    func configure(
        dataSource: UICollectionViewDataSource,
        delegate: UICollectionViewDelegate,
        section: Int
    ) {
        collectionView.tag = section
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
    }

    func showEmptyState(_ show: Bool) {
        emptyLabel.isHidden = !show
        collectionView.isHidden = show
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.dataSource = nil
        collectionView.delegate = nil
        emptyLabel.isHidden = true
        collectionView.isHidden = false
    }
}
