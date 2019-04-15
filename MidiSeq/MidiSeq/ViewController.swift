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
    var midiSequencer = MIDISequencer.shared()
    @IBOutlet weak var playStopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func playPressed(_ sender: Any) {
        if !isPlaying {
            var timeStamp = 0.0
            let endpointName = "AudioKit Synth One" // use "Session 1" for network session
            midiSequencer.destination = DestinationEndpoint(displayName: endpointName)
            midiSequencer.addNote(Note(value: 50, velocity: 127), atTimestamp: timeStamp)
            timeStamp += 0.5
            midiSequencer.addNote(Note(value: 60, velocity: 127), atTimestamp: timeStamp)
            timeStamp += 0.5
            midiSequencer.addNote(Note(value: 70, velocity: 127), atTimestamp: timeStamp)
            timeStamp += 0.5
            midiSequencer.addNote(Note(value: 80, velocity: 127), atTimestamp: timeStamp, isLast: true)
            midiSequencer.play()
        } else {
            midiSequencer.stop()
        }
        playStopButtonState(isPlaying)
        isPlaying = !isPlaying
    }
    
    // MARK: Play/Stop Toggle Button UI states
    
    private func setupUI() {
        playStopButton.layer.cornerRadius = 8.0
        playStopButton.layer.borderColor = playStopButton.tintColor.cgColor
        playStopButton.layer.borderWidth = 1.0
    }
    
    private func playStopButtonState(_ isPlaying:Bool) {
        if !isPlaying {
            playStopButton.setTitle("Stop", for: .normal)
            playStopButton.layer.backgroundColor = playStopButton.tintColor.cgColor
            playStopButton.setTitleColor(.white, for: .normal)
        } else {
            playStopButton.setTitle("Play", for: .normal)
            playStopButton.layer.borderColor = playStopButton.tintColor.cgColor
            playStopButton.layer.backgroundColor = UIColor.clear.cgColor
            playStopButton.setTitleColor(playStopButton.tintColor, for: .normal)
        }
    }
    
}

