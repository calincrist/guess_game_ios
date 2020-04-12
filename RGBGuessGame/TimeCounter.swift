//
//  TimeCounter.swift
//  RGBGuessGame
//
//  Created by Calin Ciubotariu on 11/04/2020.
//  Copyright © 2020 Calin Ciubotariu. All rights reserved.
//

import Foundation
import Combine

class TimeCounter: ObservableObject {
    
    var timer: Timer?
    
    //  Whenever counter changes, it publishes itself to any subscribers.
    @Published var counter = 0
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateCounter),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateCounter() {
        counter += 1
    }
    
    func killTimer() {
        timer?.invalidate()
        timer = nil
    }
}

//  You'll set up TimeCounter to be a publisher, and your ContentView will subscribe to it
/*
 Note: ObservableObject and Published provide a general-purpose Combine publisher that you use when there isn't a more specific Combine publisher for your needs.
 e.g. The Timer class has a Combine publisher `TimerPublisher`.
 */
