//
//  EventCell.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import UIKit

final class EventCell: UICollectionViewCell {

    // MARK: - UI

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let countdownBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.20, alpha: 1.0)
        view.layer.cornerRadius = Constants.Layout.smallCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let countdownLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
        return button
    }()

    private let vsLabel: UILabel = {
        let label = UILabel()
        label.text = "vs."
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let firstCompetitorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let secondCompetitorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Properties

    var onFavoriteTapped: (() -> Void)?
    private var viewModel: EventCellViewModel?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        contentView.addSubview(cardView)
        countdownBadge.addSubview(countdownLabel)

        let stackView = UIStackView(arrangedSubviews: [
            countdownBadge, favoriteButton, firstCompetitorLabel, vsLabel, secondCompetitorLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(stackView)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -padding),

            countdownBadge.heightAnchor.constraint(equalToConstant: 28),
            countdownBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),

            countdownLabel.topAnchor.constraint(equalTo: countdownBadge.topAnchor),
            countdownLabel.bottomAnchor.constraint(equalTo: countdownBadge.bottomAnchor),
            countdownLabel.leadingAnchor.constraint(equalTo: countdownBadge.leadingAnchor, constant: 10),
            countdownLabel.trailingAnchor.constraint(equalTo: countdownBadge.trailingAnchor, constant: -10),

            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),

            firstCompetitorLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            firstCompetitorLabel.heightAnchor.constraint(equalToConstant: 30),
            secondCompetitorLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            secondCompetitorLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    // MARK: - Configure

    func configure(with viewModel: EventCellViewModel) {
        self.viewModel = viewModel
        firstCompetitorLabel.text = viewModel.firstCompetitor
        secondCompetitorLabel.text = viewModel.secondCompetitor
        updateCountdown()
        updateFavoriteIcon()
    }

    func updateCountdown() {
        guard let viewModel else { return }
        let text = viewModel.countdownString()
        countdownLabel.text = text
        countdownLabel.textColor = text == Constants.Strings.countdownFinished
            ? UIColor(red: 0.0, green: 0.9, blue: 0.4, alpha: 1.0)
            : UIColor(red: 1.0, green: 0.35, blue: 0.35, alpha: 1.0)
    }

    private func updateFavoriteIcon() {
        guard let viewModel else { return }
        let imageName = viewModel.isFavorite ? "star.fill" : "star"
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        favoriteButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        favoriteButton.tintColor = viewModel.isFavorite
            ? UIColor(red: 1.0, green: 0.82, blue: 0.0, alpha: 1.0)
            : UIColor.white.withAlphaComponent(0.4)
    }

    // MARK: - Actions

    @objc private func favoriteTapped() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.favoriteButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { [weak self] _ in
            UIView.animate(withDuration: 0.1) {
                self?.favoriteButton.transform = .identity
            }
        }
        onFavoriteTapped?()
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        countdownLabel.text = nil
        firstCompetitorLabel.text = nil
        secondCompetitorLabel.text = nil
        onFavoriteTapped = nil
    }
}
