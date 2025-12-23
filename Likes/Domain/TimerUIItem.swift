//
//  TimerUIItem.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import Foundation

struct TimerUIItem {

    struct Output: Equatable {
        let hours: String
        let minutes: String
        let seconds: String
        let secondLeft: Int
    }

    static func make(from totalSeconds: Int) -> Output {
        let clamped = max(0, totalSeconds)

        let hours = clamped / 3600
        let minutes = (clamped % 3600) / 60
        let seconds = clamped % 60

        return Output(
            hours: Self.twoDigits(hours),
            minutes: Self.twoDigits(minutes),
            seconds: Self.twoDigits(seconds),
            secondLeft: totalSeconds
        )
    }

    // MARK: - Helpers
    private static func twoDigits(_ value: Int) -> String {
        String(format: "%02d", value)
    }
}
