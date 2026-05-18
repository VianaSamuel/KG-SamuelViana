//
//  SportsListViewController.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import UIKit

final class SportsListViewController: UIViewController {

    private let viewModel: SportsListViewModel

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.sectionFooterHeight = 0
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SportTableViewCell.self, forCellReuseIdentifier: Constants.ReuseID.sportCell)
        tv.register(SportSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.ReuseID.sectionHeader)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(red: 0.0, green: 0.82, blue: 0.82, alpha: 1.0)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Init

    init(viewModel: SportsListViewModel = SportsListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = SportsListViewModel()
        super.init(coder: coder)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        bindViewModel()
        viewModel.loadSports()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        title = Constants.Strings.appTitle

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.0, green: 0.55, blue: 0.55, alpha: 1.0)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.18, alpha: 1.0)

        view.addSubview(tableView)
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Binding

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }
            switch state {
            case .loading:
                loadingIndicator.startAnimating()
                tableView.isHidden = true
            case .loaded:
                loadingIndicator.stopAnimating()
                tableView.isHidden = false
                tableView.reloadData()
            case .error(let message):
                loadingIndicator.stopAnimating()
                showError(message)
            }
        }

        viewModel.onSectionsUpdated = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onTimerTick = { [weak self] in
            self?.updateVisibleCountdowns()
        }
    }

    private func updateVisibleCountdowns() {
        for cell in tableView.visibleCells {
            guard let sportCell = cell as? SportTableViewCell else { continue }
            for eventCell in sportCell.collectionView.visibleCells {
                (eventCell as? EventCell)?.updateCountdown()
            }
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: Constants.Strings.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.retryAction, style: .default) { [weak self] _ in
            self?.viewModel.loadSports()
        })
        alert.addAction(UIAlertAction(title: Constants.Strings.cancelAction, style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SportsListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionViewModel(for: section).isExpanded ? 1 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.ReuseID.sportCell,
            for: indexPath
        ) as? SportTableViewCell else { return UITableViewCell() }

        let eventCount = viewModel.numberOfEvents(in: indexPath.section)
        cell.showEmptyState(eventCount == 0)
        cell.configure(dataSource: self, delegate: self, section: indexPath.section)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SportsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.ReuseID.sectionHeader
        ) as? SportSectionHeaderView else { return nil }

        let sectionVM = viewModel.sectionViewModel(for: section)
        header.configure(
            sportName: sectionVM.name,
            sportId: sectionVM.id,
            isExpanded: sectionVM.isExpanded
        )
        header.onToggle = { [weak self] in
            self?.viewModel.toggleSection(section)
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.Layout.sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 0 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
}

// MARK: - UICollectionViewDataSource

extension SportsListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfEvents(in: collectionView.tag)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.ReuseID.eventCell,
            for: indexPath
        ) as? EventCell else { return UICollectionViewCell() }

        if let eventVM = viewModel.eventViewModel(at: indexPath.item, section: collectionView.tag) {
            cell.configure(with: eventVM)
            cell.onFavoriteTapped = { [weak self] in
                self?.viewModel.toggleFavorite(eventId: eventVM.eventId)
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SportsListViewController: UICollectionViewDelegate {}
