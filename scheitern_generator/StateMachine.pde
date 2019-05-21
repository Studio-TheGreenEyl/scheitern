static final int INPUT = 0;
static final int PARSE = 1;
static final int BUBBLES = 2;
static final int ANIMATE = 3;

void stateMachine() {
  
   switch(state) {
    case INPUT:
      if(!stateFinished) println("[###] STATE: INPUT");
      if(!stateFinished) {
        //if(bla bla) stateFinished = true;
        println("> loading data");
        input = loadStrings("data/data__full.tsv");
        //input = loadStrings("data/data.tsv");
        println("> "+ input.length + " lines");
        if(input.length > 0) stateFinished = true;
      } else {
        state = PARSE;
        stateFinished = false;
      }
    break;
    
    case PARSE:
      if(!stateFinished) println("[###] STATE: PARSE");
      // struktur:
      //  Bereich;  Datum;  Autor*in;  Beschreibung;  Kurztext;  Langtext; ; Bildmaterial; Quelle; ;
      int start = 0;
      int id = 0;
      // „“
      //for(int i = start; i<start+3; i++) {
      for(int i = start; i<input.length; i++) {
        String[] splitter = split(input[i], "\t");
        // 4 = shorText, 5 = longText
        String[] splitter2 = split(splitter[4], "    ");
        if(splitter2.length == 1) {
          //if (!splitter[4].toLowerCase().contains(".jpg") && !splitter[4].toLowerCase().contains(".jpeg") && !splitter[4].toLowerCase().contains(".tif"))
          if (splitter[4].toLowerCase().contains(".jpg") || splitter[4].toLowerCase().contains(".jpeg") || splitter[4].toLowerCase().contains(".tif")) {
            bubbles.add(new Bubble(id, splitter[0], splitter[1], splitter[2], splitter[3], splitter[4], splitter[5], splitter[4], splitter[9] ));
          } else bubbles.add(new Bubble(id, splitter[0], splitter[1], splitter[2], splitter[3], splitter[4], splitter[5], "", splitter[9] ));
          id++;
          
        } else {
          for(int j = 0; j<splitter2.length; j++) {
            // longText noch nicht geparst
            //if (!splitter2[j].toLowerCase().contains(".jpg") && !splitter2[j].toLowerCase().contains(".jpeg") && !splitter2[j].toLowerCase().contains(".tif"))
            if (splitter2[j].toLowerCase().contains(".jpg") || splitter2[j].toLowerCase().contains(".jpeg") || splitter2[j].toLowerCase().contains(".tif")) {
              bubbles.add(new Bubble(id, splitter[0], splitter[1], splitter[2], splitter[3], splitter2[j], splitter[5], splitter2[j], splitter[9] ));
            } else bubbles.add(new Bubble(id, splitter[0], splitter[1], splitter[2], splitter[3], splitter2[j], splitter[5], "", splitter[9] ));
           id++;
          }
        }
        state = BUBBLES;
      }
    break;
    
    case BUBBLES:
      if(!stateFinished) println("[###] STATE: INIT BUBBLES");
      for (Bubble bubble : bubbles) {
        bubble.y = height;
      }
      timestamp = theFrames;
      state = ANIMATE;
      doNext = true;
      interval = 0;
      println("[###] STATE: ANIMATE");
    break;
    
    case ANIMATE:
      Bubble tempBubble;
      // checken ob bubbles den frame verlassen oder nah am rand sind
      if(onDisplay.size() > 0) {
        for(int i = 0; i<onDisplay.size(); i++) {
          tempBubble = bubbles.get( onDisplay.get(i) );
          if(tempBubble.leavingFrame()) {
            tempBubble.moveBox(tempBubble.getBoxHeight());
            leaving.append(onDisplay.get(i));
            onDisplay.remove(i);
          }
        }
        // throws error. why?
        // needs max height?
        if (bubbles.get(onDisplay.get(onDisplay.size()-1)).isThere() && !doNext) {
          doNext = true;
          interval = bubbles.get(index).getWPM()*bubbleInterval;
          countInterval = 0;
        }
      }
      
      if(leaving.size() > 0) {
        if (bubbles.get(leaving.get(leaving.size()-1)).isThere()) leaving.remove(leaving.size()-1);
      }
      
      if(doNext && countInterval > interval) {
        if(bubbles.size() > 0) {
          nextBubble();
          doNext = false;
          int literallyTheSameValue = index;
          onDisplay.append(literallyTheSameValue);
          
          tempBubble = bubbles.get(index);
          float newHeight = tempBubble.getBoxHeight();
          tempBubble.y = height;
          for(int i = 0; i<onDisplay.size(); i++) {
            tempBubble = bubbles.get( onDisplay.get(i) );
            tempBubble.moveBox(newHeight);
          }
        }     
      }
    
      if(onDisplay.size() > 0) {
        for(int i = 0; i<onDisplay.size(); i++) {
          bubbles.get( onDisplay.get(i) ).display();
        }
      }
      
      if(leaving.size() > 0) {
        for(int i = 0; i<leaving.size(); i++) {
          bubbles.get( leaving.get(i) ).display();
        }
      }
      
      countInterval++;
    break;
   }
}
