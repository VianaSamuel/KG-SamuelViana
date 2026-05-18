//
//  SportSectionHeaderView.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import UIKit

final class SportSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - UI

    private let sportIconLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties

    var onToggle: (() -> Void)?
    private var isExpanded = true

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGesture()
    }

    // MARK: - Setup

    private func setupViews() {
        contentView.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.18, alpha: 1.0)

        contentView.addSubview(containerView)
        containerView.addSubview(sportIconLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(chevronImageView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),

            sportIconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            sportIconLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sportIconLabel.widthAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: sportIconLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),

            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        containerView.addGestureRecognizer(tap)
    }

    // MARK: - Actions

    @objc private func headerTapped() {
        onToggle?()
    }

    // MARK: - Configure

    func configure(sportName: String, sportId: String, isExpanded: Bool) {
        self.isExpanded = isExpanded
        titleLabel.text = sportName
        sportIconLabel.text = iconForSport(sportId)
        chevronImageView.image = UIImage(systemName: isExpanded ? "chevron.up" : "chevron.down")
    }

    private func iconForSport(_ sportId: String) -> String {
        switch sportId {
        case "FOOT": return "⚽"
        case "BASK": return "🏀"
        case "TENN": return "🎾"
        case "TABL": return "🏓"
        case "VOLL": return "🏐"
        case "ESPS": return "🎮"
        case "ICEH": return "🏒"
        case "HAND": return "🤾"
        case "SNOO": return "🎱"
        case "FUTS": return "⚽"
        case "DART": return "🎯"
        default: return "🏅"
        }
    }
}
