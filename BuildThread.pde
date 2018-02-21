void buildThread()
{
    /*
       This thread controls the flow of the functional algorithms and is only called when the 'Build Circuit' button is pressed.
       I chose to run this on it's own thread so the algorithm can take as much time as it needs without holding up the GUI. It also makes timing everything a little easier. 
       This thread does 4 things, first, it preserves the button selections so we have a constant, non-changing copy of the values to work off of. 
       Since the GUI is still updatable whilst running, it's important to do this.
       Second, it creates a countdown in the slpash and the progress bar, letting the user know the thread is running and they have 5 seconds to tab into minecraft.
       Third, it calls either the encoder generating algorithm or the decoder generating algorithm depending on what was selected at the time of sampling.
       The rest of the sampled parameters are passed into the algorithms to adjust thneir output accordingly.
       Fourth, The splash is updated to notify user that the thread is complete before restoring it's default state and terminating.
     */

    //preserve the selections just in case they change during operation
    String facing = playerFacing.Value();
    String reference = playerReference.Value();
    String side = IOSide.Value();
    String circuit = circuitType.Value();
    String path = sourcePath.Value();

    // Countdown
    for(int seconds = 0; seconds < 5; seconds++)
    {
        splash = "Building Circuit in " + (5 - seconds);
        progress = seconds / 4.;
        delay(1000);
    }

    if(circuit == "Decoder") //are we building an encoder or a decoder?
    {
        //we're passing the parameters into the functions since we want to use the local version, not the global versions
        //reason for this - the global ones are subject to change, the local ones are at least stable and won't change until completion
        genDecoder(path, facing, reference, side); 
    } else {
        genEncoder(path, facing, reference, side);
    }
    //build done, splash a success sign then revert to start state before closing the thread
    splash = "Build Complete!";
    progress = 1;
    delay(5000);
    splash = "Please Select a Source File Before Building";
    progress = 0;
    buildingCircuit = false;
}
