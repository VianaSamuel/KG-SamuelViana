//
//  EventCellViewModel.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import Foundation

struct EventCellViewModel {

    let eventId: String
    let firstCompetitor: String
    let secondCompetitor: String
    let isFavorite: Bool

    private let eventDate: Date

    init(event: Event, isFavorite: Bool) {
        self.eventId = event.id
        self.firstCompetitor = event.competitors.first
        self.secondCompetitor = event.competitors.second
        self.isFavorite = isFavorite
        self.eventDate = event.date
    }

    /// Returns "LIVE" if the event has already started.
    func countdownString(from now: Date = Date()) -> String {
        let interval = eventDate.timeIntervalSince(now)

        guard interval > 0 else {
            return Constants.Strings.countdownFinished
        }

        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
