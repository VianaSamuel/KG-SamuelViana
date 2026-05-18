//
//  Constants.swift
//  KaizenGaming-SamuelViana
//
//  Created by Samuel Viana on 17/05/26.
//

import Foundation

enum Constants {

    enum API {
        static let sportsURL = "https://ios-kaizen.github.io/MockSports/sports.json"
    }

    enum Strings {
        static let appTitle = NSLocalizedString("app_title", value: "Kaizen Gaming", comment: "")
        static let errorTitle = NSLocalizedString("error_title", value: "Error:", comment: "")
        static let errorMessage = NSLocalizedString("error_message", value: "Unable to load sports data.", comment: "")
        static let retryAction = NSLocalizedString("retry_action", value: "Retry", comment: "")
        static let cancelAction = NSLocalizedString("cancel_action", value: "Cancel", comment: "")
        static let noEvents = NSLocalizedString("no_events", value: "No events available", comment: "")
        static let countdownFinished = NSLocalizedString("countdown_finished", value: "LIVE", comment: "")
    }

    enum Layout {
        static let eventCellWidth: CGFloat = 160
        static let eventCellHeight: CGFloat = 170
        static let sectionHeaderHeight: CGFloat = 50
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 8
        static let cornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 8
        static let collectionViewHeight: CGFloat = 186
    }

    enum ReuseID {
        static let sportCell = "SportTableViewCell"
        static let eventCell = "EventCollectionViewCell"
        static let sectionHeader = "SportSectionHeaderView"
    }
}
