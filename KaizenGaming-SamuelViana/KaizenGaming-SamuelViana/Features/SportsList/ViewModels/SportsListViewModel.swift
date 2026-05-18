//
//  SportsListViewModel.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import Foundation
import UIKit

// MARK: - ViewState

enum ViewState {
    case loading
    case loaded
    case error(String)
}

// MARK: - SportSection

struct SportSection {
    let sport: Sport
    var isExpanded: Bool
    var eventViewModels: [EventCellViewModel]
}

// MARK: - SportsListViewModel

final class SportsListViewModel {

    // MARK: - Properties

    private let networkService: NetworkServiceProtocol
    private var sports: [Sport] = []
    private(set) var favoriteEventIds: Set<String> = []
    private(set) var sections: [SportSection] = []
    private(set) var collapsedSportIds: Set<String> = []

    // MARK: - Callbacks

    var onStateChanged: ((ViewState) -> Void)?
    var onSectionsUpdated: (() -> Void)?
    var onTimerTick: (() -> Void)?

    // MARK: - Timer

    private var timer: Timer?

    // MARK: - Init

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    deinit {
        stopTimer()
    }

    // MARK: - Data Loading

    func loadSports() {
        onStateChanged?(.loading)

        Task { [weak self] in
            do {
                let fetchedSports = try await self?.networkService.fetchSports() ?? []
                await MainActor.run {
                    self?.sports = fetchedSports
                    self?.buildSections()
                    self?.onStateChanged?(.loaded)
                    self?.startTimer()
                }
            } catch {
                await MainActor.run {
                    let message = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                    self?.onStateChanged?(.error(message))
                }
            }
        }
    }

    // MARK: - Sections

    private func buildSections() {
        sections = sports.map { sport in
            let isExpanded = !collapsedSportIds.contains(sport.id)
            return SportSection(sport: sport, isExpanded: isExpanded, eventViewModels: sortedEventViewModels(for: sport))
        }
        onSectionsUpdated?()
    }

    private func sortedEventViewModels(for sport: Sport) -> [EventCellViewModel] {
        let sorted = sport.events.sorted { lhs, rhs in
            let lhsFav = favoriteEventIds.contains(lhs.id)
            let rhsFav = favoriteEventIds.contains(rhs.id)
            if lhsFav != rhsFav { return lhsFav }
            return lhs.timestamp < rhs.timestamp
        }
        return sorted.map { EventCellViewModel(event: $0, isFavorite: favoriteEventIds.contains($0.id)) }
    }

    func toggleSection(_ section: Int) {
        guard section < sections.count else { return }
        let sportId = sections[section].sport.id
        if collapsedSportIds.contains(sportId) {
            collapsedSportIds.remove(sportId)
        } else {
            collapsedSportIds.insert(sportId)
        }
        sections[section].isExpanded = !collapsedSportIds.contains(sportId)
        onSectionsUpdated?()
    }

    // MARK: - Favorites

    func toggleFavorite(eventId: String) {
        if favoriteEventIds.contains(eventId) {
            favoriteEventIds.remove(eventId)
        } else {
            favoriteEventIds.insert(eventId)
        }
        buildSections()
    }

    func isFavorite(eventId: String) -> Bool {
        favoriteEventIds.contains(eventId)
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.onTimerTick?()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Accessors

    var numberOfSections: Int { sections.count }

    func sectionViewModel(for section: Int) -> SportSectionModel {
        guard section < sections.count else {
            return SportSectionModel(id: "", name: "", isExpanded: false)
        }
        let s = sections[section]
        let name = s.sport.name == "SOCCER" ? "FOOTBALL" : s.sport.name
        return SportSectionModel(id: s.sport.id, name: name, isExpanded: s.isExpanded)
    }

    func numberOfEvents(in section: Int) -> Int {
        guard section < sections.count, sections[section].isExpanded else { return 0 }
        return sections[section].eventViewModels.count
    }

    func eventViewModel(at item: Int, section: Int) -> EventCellViewModel? {
        guard section < sections.count else { return nil }
        let s = sections[section]
        guard item < s.eventViewModels.count else { return nil }
        return s.eventViewModels[item]
    }
}
