  void keyPressed() {
  if(key == CODED) {
  
    switch (keyCode) {
      case LEFT:
      case DOWN:
        prevBubble();
        break;
      case RIGHT:
      case UP:
          
        nextBubble();
        break;
    }
    } else {
    if (key == 'r' || key == 'R' ) {
      recordVideo = !recordVideo;
      println("recording");
    }
  }
}

void fileSelected(File selection) {
  if (selection == null || !selection.getAbsolutePath().endsWith(".csv")) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
        
    String[] lines = loadStrings(selection.getAbsolutePath());
    String csv = "";
    for (int i = 0; i < lines.length; i++) csv += lines[i]+"\n";
    lines = split(csv, "§");
    //String[] line = new String[10];
    println("there are " + lines.length + " lines");
    for (int i = 1; i < lines.length; i++) { //=line.length) {
      //for (int c=0; c<line.length; c++) line[c] = lines[i+c];
      String[] line = lines[i].split(";");
      String test = line[4].toLowerCase();
      println(test + (test.indexOf("jpg") > -1 || test.indexOf("jpeg") > -1));
      if (line.length > 5 && test.indexOf("jpg") > -1 && test.indexOf("jpeg") > -1) bubbles.add(new Bubble(line));
      //println(lines[i]);
    }
    bubblesInitialized = true;
  }
}

void nextBubble() {
    timestamp = theFrames;
    if(bubbles.size() > 0) {
      
      index++;
      if(index >= bubbles.size()-1) {
        finished = true;
        println("bubbles finished");
        exit();
      }
      //index %= bubbles.size();
      //println("next=" + index);
    }
}

void prevBubble() {
    timestamp = theFrames;
    if(bubbles.size() > 0) {
      index--;
      index = index < 0 ? index + bubbles.size() : index;
    }
}

int getBubbleIndex(int id) {
  int ret = -1;
  if(bubbles.size() > 0) {
    for(int i = 0; i<bubbles.size(); i++) {
      if(bubbles.get(i).getID() == id) return i;
    } 
  }
  return ret;
}

int parseDisplay(String s) {
  String[] splitter = split(s, ";");

  return  Integer.parseInt(splitter[0]);
}
