//
//  CountdownTimer.swift
//  Serenity
//
//  Created by Tammy Nguyen on 5/27/24.
//

import Foundation

class CountdownTimer: NSObject {
    private var timer: Timer?
    private var totalTime: Int
    private var currentTime: Int

    var timerDidUpdate: ((Int) -> Void)?
    var timerDidFinish: (() -> Void)?

    init(totalTime: Int) {
        self.totalTime = totalTime
        self.currentTime = totalTime
        super.init()
    }

    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func pause() {
        timer?.invalidate()
    }

    func reset() {
        timer?.invalidate()
        currentTime = totalTime
        timerDidUpdate?(currentTime)
    }

    @objc private func updateTimer() {
        if currentTime > 0 {
            currentTime -= 1
            timerDidUpdate?(currentTime)
        } else {
            timer?.invalidate()
            timerDidFinish?()
        }
    }
}
