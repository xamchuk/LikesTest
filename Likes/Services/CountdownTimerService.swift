//
//  CountdownTimerService.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import Foundation
import Combine
import UIKit

final class CountdownTimerService {

    // MARK: - Output
    var output = PassthroughSubject<TimerUIItem.Output, Never>()

    // MARK: - State
    private var timer: Timer?
    private(set) var remainingSeconds: Int = 0
    private(set) var isRunning: Bool = false

    private var endDate: Date?
    private var cancellable = Set<AnyCancellable>()

    // MARK: - Init
    init(seconds: Int = 0) {
        self.remainingSeconds = max(0, seconds)

        // Re-sync when app returns
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in self?.syncFromEndDateAndNotify() }
            .store(in: &cancellable)

        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in self?.syncFromEndDateAndNotify() }
            .store(in: &cancellable)
    }

    deinit { stop() }

    // MARK: - Private
    private func startTimerIfNeeded() {
        timer?.invalidate()
        guard isRunning else { return }

        let t = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func tick() {
        syncFromEndDateAndNotify()
        if remainingSeconds == 0 {
            stop()
        }
    }

    private func syncFromEndDateAndNotify() {
        guard let endDate else {
            notifyTick()
            return
        }

        let secondsLeft = Int(ceil(endDate.timeIntervalSinceNow))
        remainingSeconds = max(0, secondsLeft)

        notifyTick()

        // If we came back and it's already finished, stop.
        if remainingSeconds == 0 {
            stop()
        } else if isRunning, timer == nil {
            // After returning from background, re-create Timer
            startTimerIfNeeded()
        }
    }

    private func notifyTick() {
        output.send(TimerUIItem.make(from: remainingSeconds))
    }

    // MARK: - Public
    func set(seconds: Int) {
        remainingSeconds = max(0, seconds)
        if isRunning {
            endDate = Date().addingTimeInterval(TimeInterval(remainingSeconds))
        }
        notifyTick()
    }

    func start() {
        guard !isRunning else { return }
        guard remainingSeconds > 0 else {
            notifyTick()
            return
        }

        isRunning = true
        endDate = Date().addingTimeInterval(TimeInterval(remainingSeconds))

        startTimerIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self = self else { return  }
            notifyTick()
        }
       
    }

    func stop() {
        isRunning = false
        endDate = nil
        timer?.invalidate()
        timer = nil
    }

    func reset(to seconds: Int) {
        stop()
        remainingSeconds = max(0, seconds)
        notifyTick()
    }
}
