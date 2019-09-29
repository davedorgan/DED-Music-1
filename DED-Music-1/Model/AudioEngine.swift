//
//  AudioEngine.swift
//  DED-Music-1
//
//  Created by David Dorgan on 9/28/19.
//  Copyright © 2019 DED Software. All rights reserved.
//

import Foundation
import AudioKitUI
import AudioKit


// Create a class to handle the audio set up
class AudioEngine {

    // Declare your nodes as instance variables
    var player: AKPlayer!
    var delay: AKDelay!
    var reverb: AKReverb!
    var reverb2: AKReverb!
    var file: AKAudioFile!
    var hpFilter: AKHighPassFilter!
    var lpFilter: AKLowPassFilter!
    var pitchShifter: AKPitchShifter!
    var chorus: AKChorus!

    init() {
        // Set up a player to the loop the file's playback
        do {
            file = try AKAudioFile(readFileName: "77_ECHOBEAT_02_C.wav")
        } catch {
            AKLog("File Not Found")
            return
        }
        player = AKPlayer(audioFile: file)
        player.isLooping = true

        // Next we'll connect the audio player to a delay effect
        delay = AKDelay(player)

        // Set the parameters of the delay here
        delay.time = 0.1 // seconds
        delay.feedback = 0.8 // Normalized Value 0 - 1
        delay.dryWetMix = 1 // Normalized Value 0 - 1

        // Continue adding more nodes as you wish, for example, reverb:
        reverb = AKReverb(delay)
        reverb.loadFactoryPreset(.cathedral)

        reverb2 = AKReverb(reverb)
        reverb2.loadFactoryPreset(.cathedral)

        hpFilter = AKHighPassFilter(reverb2)
        hpFilter.cutoffFrequency = 100 // Hz
        hpFilter.resonance = 0.5 // dB
        
        lpFilter = AKLowPassFilter(hpFilter)
        lpFilter.cutoffFrequency = 200 // Hz
        lpFilter.resonance = 0.5 // dB
        
        pitchShifter = AKPitchShifter(lpFilter)
        pitchShifter.shift = 24
        
        chorus = AKChorus(pitchShifter)
//        chorus.frequency = 400
        chorus.depth = 0.1
        chorus.feedback = 0.1
        chorus.dryWetMix = 0.8
        
//        AudioKit.output = player
        AudioKit.output = pitchShifter
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }
}
