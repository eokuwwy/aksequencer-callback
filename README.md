Install AudioKit first by running pod install from the root dir.

Set the name of the MIDI endpoint in the ViewController class. "Session 1", for example for Network Session 1. The default is "AudioKit Synth One".

Press the "Play" button.

Put the app into background mode and then open AudioKit Synth One (or whatever you set for the destination). You will hear the sequence being played. However, as you can see in the debug output, the callback is not invoked. Bring the app into the foreground again. You will see the callback being invoked in the debug output.

**UPDATE**
The above "problem" only exists when running in the simulator. Run it on a device and it works perfectly!
