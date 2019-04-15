//
//  Conductor.swift
//  MidiSeq
//
//  Created by Mark Jeschke on 4/14/19.
//  Copyright © 2019 Eokuwwy Enterprises. All rights reserved.
//

import AudioKit

class Conductor {
    
    static let sharedInstance = Conductor()

    init() {

        AKSettings.defaultToSpeaker = true
        AKSettings.playbackWhileMuted = true
        
        do {
            try AKSettings.setSession(category: .playAndRecord, with: [.defaultToSpeaker, .allowBluetooth, .mixWithOthers])
        } catch {
            assert(true, "Could not set session category.")
        }

    }
    
    func startAudioKitEngine() {
        do {
            try AudioKit.start()
            print("Audio engine was started")
        } catch {
            assert(true, "Audio engine could not start!")
        }
    }
    
    func stopAudioKitEngine() {
        do {
            try AudioKit.stop()
            print("Audio engine was stopped")
        } catch {
            assert(true, "Error stopping AudioKit")
        }
    }
}
