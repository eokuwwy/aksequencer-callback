//
//  ViewController.swift
//  MidiSeq
//
//  Created by Steve Connelly on 4/14/19.
//  Copyright © 2019 Eokuwwy Enterprises. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playPressed(_ sender: Any) {
        if !isPlaying {
            var timeStamp = 0.0
            let endpointName = "AudioKit Synth One" // use "Session 1" for network session
            MIDISequencer.shared().destination = DestinationEndpoint(displayName: endpointName)
            MIDISequencer.shared().addNote(Note(value: 50, velocity: 127), atTimestamp: timeStamp)
            timeStamp += 0.5
            MIDISequencer.shared().addNote(Note(value: 60, velocity: 127), atTimestamp: timeStamp)
            timeStamp += 0.5
            MIDISequencer.shared().addNote(Note(value: 70, velocity: 127), atTimestamp: timeStamp)
            timeStamp += 0.5
            MIDISequencer.shared().addNote(Note(value: 80, velocity: 127), atTimestamp: timeStamp, isLast: true)
            MIDISequencer.shared().play()
            isPlaying = true
        } else {
            MIDISequencer.shared().stop()
            isPlaying = false
        }
    }
    
}

