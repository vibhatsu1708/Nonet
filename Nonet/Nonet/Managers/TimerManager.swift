//
//  TimerManager.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation
import Combine

class TimerManager: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isPaused: Bool = false
    
    private var timer: Timer?
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    
    func start() {
        guard timer == nil else { return }
        
        startTime = Date()
        isPaused = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }
    
    func pause() {
        guard !isPaused else { return }
        
        isPaused = true
        
        if let startTime = startTime {
            accumulatedTime += Date().timeIntervalSince(startTime)
        }
        
        timer?.invalidate()
        timer = nil
        startTime = nil
    }
    
    func resume() {
        guard isPaused else { return }
        
        isPaused = false
        startTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        accumulatedTime = 0
        elapsedTime = 0
        isPaused = false
    }
    
    func reset() {
        stop()
    }
    
    private func updateTime() {
        guard let startTime = startTime else { return }
        elapsedTime = accumulatedTime + Date().timeIntervalSince(startTime)
    }
}
