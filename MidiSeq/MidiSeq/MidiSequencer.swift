//
//  MidiSequencer.swift
//  MidiSeq
//
//  Created by Steve Connelly on 4/14/19.
//  Copyright © 2019 Eokuwwy Enterprises. All rights reserved.
//

import Foundation
import AudioKit

struct Note {
    var value:MIDIByte
    var velocity:MIDIByte
}

struct DestinationEndpoint {
    var displayName:String
}

class MIDISequencer {
    fileprivate static var sharedInstance:MIDISequencer? = nil
    
    let sequencer:AKSequencer
    let callbackInstrument:AKCallbackInstrument
    let callbackTrack:AKMusicTrack?
    let musicTrack:AKMusicTrack?
    let midi:AKMIDI = AudioKit.midi
    var channel:MIDIChannel = 0
    var lastAddedBeat:Double = 0
    
    var destination:DestinationEndpoint? {
        didSet {
            if let dest = destination {
                if let ref = endpointRefForName(dest.displayName) {
                    musicTrack?.setMIDIOutput(ref)
                }
            }
        }
    }
    
    private init() {
        sequencer = AKSequencer()
        musicTrack = sequencer.newTrack("music")
        musicTrack?.resetToInit()
        callbackTrack = sequencer.newTrack("callback")
        callbackTrack?.resetToInit()
        callbackInstrument = AKCallbackInstrument()
        sequencer.enableLooping()
        sequencer.addTimeSignatureEvent(timeSignature: AKTimeSignature(topValue: 4, bottomValue: .four))
        callbackTrack?.setMIDIOutput(callbackInstrument.midiIn)
        callbackInstrument.callback = sequencerCallback
    }
    
    class func shared() -> MIDISequencer {
        if sharedInstance == nil {
            sharedInstance = MIDISequencer()
        }
        
        return sharedInstance!
    }
    
    func sequencerCallback(_ status: AKMIDIStatus, _ noteNumber: MIDINoteNumber, _ velocity: MIDIVelocity) {
        print("callback invoked")
        
        if status == .noteOn {
            handleMIDINoteOn(noteNumber, velocity)
        } else if status == .noteOff {
            handleMIDINoteOff(noteNumber, velocity)
        }
    }
    
    fileprivate func handleMIDINoteOn(_ noteNumber: MIDINoteNumber, _ velocity: MIDIVelocity) {
        DispatchQueue.main.async {
            print("Received midi note on: \(noteNumber)")
            self.sendModsForValue(noteNumber)
        }
    }
    
    fileprivate func handleMIDINoteOff(_ noteNumber: MIDINoteNumber, _ velocity: MIDIVelocity) {
        print("Received midi note off: \(noteNumber)")
    }
    
    func sendModsForValue(_ noteNumber: MIDINoteNumber) {
        if let dest = destination {
            print("Sending CC mod to destination")
            midi.openOutput(dest.displayName)
            midi.sendControllerMessage(74, value: noteNumber)
        }
    }
    
    func addNote(_ note:Note, atTimestamp:Double, isLast:Bool = false) {
        let noteDuration = 0.25
        let duration = lastAddedBeat + noteDuration
        lastAddedBeat = duration
        
        self.callbackTrack?.add(noteNumber: MIDINoteNumber(note.value), velocity: MIDIVelocity(note.velocity), position: AKDuration(seconds: atTimestamp), duration: AKDuration(beats: noteDuration), channel: self.channel)
        self.musicTrack?.add(midiNoteData: (self.callbackTrack?.getMIDINoteData().last)!)
        
        if isLast {
            self.sequencer.enableLooping(AKDuration(seconds: atTimestamp + noteDuration))
        }
    }
    
    func play() {
        sequencer.play()
    }
    
    func stop() {
        sequencer.stop()
    }
    
    func clear() {
        musicTrack?.clear()
        callbackTrack?.clear()
    }
    
    func endpointRefForName(_ name:String) -> MIDIEndpointRef? {
        for (index, destName) in midi.destinationNames.enumerated() {
            if destName == name {
                return MIDIGetDestination(index)
            }
        }
        
        return nil
    }
    
}
