void genEncoder(String path, String facing, String reference, String side) { 
  /*
  This is just the basic algorithm I started out with
  This algorithm uses the path argument to collect the source file, but it doesn't use the reference, facing, and side arguments to move and rotate the circuit
  If you can figure out how to apply these arguments, as well as optimize this algorithm for speed, feel free to modify this all you like.
  The algorithm works just like before, calling the typeString function for print it's final results to the game,
  however all instances of println() have been replaced with 'splash = '
  This allows the splash to notify the user of the progress.
  I've also added the progress bar to go along side the splash. In this case, it's just showing how much each for loop has progressed, more details in the 'ProgressBar' tab
  At this point it moves very rigidly, since it's updated once per iteration in the for loops, ideally I'd like it to progress smoothly, but that's not necessary.
  */
  String[] lines = loadStrings(path);
  int widest_line=0;
  for (int i=0; i<lines.length; i++) { //make input lines
    splash = ("placing input line " + (i+1) + " of " + lines.length);
    progress = float(i)/lines.length;
    int x = (i+1)*2;
    int z = lines[i].length()*2-2;
    if (lines[i].length()>widest_line)widest_line=lines[i].length();
    typeString("/fill ~"+x+" ~1 ~-1 ~"+x+" ~1 ~"+z+" minecraft:iron_block");
    typeString("/fill ~"+x+" ~2 ~ ~"+x+" ~2 ~"+z+" minecraft:redstone_wire");
    for (int j=-1; j<z; j+=16) { //place repeaters
      typeString("/setblock ~"+x+" ~2 ~"+j+" minecraft:unpowered_repeater 2");
    }
  }
  for (int i=0; i<widest_line; i++) { //make output lines
    splash = ("placing output line " + (i+1) + " of " + widest_line);
    progress = float(i)/widest_line;
    int x = lines.length*2;
    int z = i*2;
    typeString("/fill ~ ~-1 ~"+z+" ~"+x+" ~-1 ~"+z+" minecraft:iron_block");
    typeString("/fill ~ ~ ~"+z+" ~"+x+" ~ ~"+z+" minecraft:redstone_wire");
    for (int j=0; j<x; j+=16) { //place repeaters
      typeString("/setblock ~"+j+" ~ ~"+z+" minecraft:unpowered_repeater 3");
    }
  }
  for(int i=0;i<lines.length;i++){ //set torches
    splash = ("placing torches for line " + (i+1) + " of " + lines.length);
    progress = float(i)/lines.length;
    String line = lines[i];
    for(int j=0;j<line.length();j++){
      int x = i*2+1;
      int z = j*2;
      if(line.charAt(j)=='1')typeString("/setblock ~"+x+" ~1 ~"+z+" minecraft:redstone_torch 2");
    }
  }
}