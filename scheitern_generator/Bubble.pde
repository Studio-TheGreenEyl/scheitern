import java.util.Date;

class Bubble {
  //  Bereich;  Datum;  Autor*in;  Beschreibung;  Kurztext;  Langtext; ; Bildmaterial; Quelle; ;
  int id = 0;
  String field = "";
  String date = "";
  String author = "";
  String description = "";
  String shortText = "";
  String longText = "";
  String source = "";
  String mediaSource = "";
  int wpm = 0;
  float boxHeight;
  
  int alignment = 0;
  float targetY = 0;
  
  float x = 0;
  float y = 0;
  
  boolean exactDate = false;
  Ani movement;
  PGraphics pg;
  
  boolean hasImage = false;
  PImage p = null;
  
  int maxHeight = 720;
  
  String[][] months = {
    {"Jan", "Januar"},
    {"Feb", "Februar"},
    {"März", "März"},
    {"April", "April"},
    {"Mai", "Mai"},
    {"Juni", "Juni"},
    {"Juli", "Juli"},
    {"Aug", "August"},
    {"Sep", "September"},
    {"Okt", "Oktober"},
    {"Nov", "November"},
    {"Dez", "Dezember"}
  };
  
  Bubble(String[] line) {
    //date = dateFormat.parse(lines[1]);
    if (line.length > 5) {
      author = line[2];
      description = line[3];
      shortText = line[4];
      longText = line[5];
      println(shortText);
    } else {
      println("not valid! "+line.length);
    }
  }
  
  Bubble(int _id, String _field, String _date, String _author, String _description, String _shortText, String _longText, String _mediaSource, String _source ) {
    id = _id;
    field = _field;
    date = _date;
    author = _author;
    description = _description;
    shortText = _shortText;
    longText = _longText;
    mediaSource = _mediaSource;
    source = _source;
    
    if(mediaSource.length() > 0) {
      hasImage = true;
      mediaSource = filenameParserForEditorsWhoUseUmlauteAndSpacesAndOtherWeirdThingsInTheirFiles(mediaSource);
      p = loadImage("data/images/" + mediaSource); 
    }
    
    if(!field.equals("Bauhaus-Akteure")) alignment = width;
    else alignment = width*-1;
    x = margin*2;
    y = 0;
    
    wpm = calcWPM();
    
    if(hasImage) {
      wpm = 20;
      boxHeight = scaleWidth(p.width, p.height, textWidth+margin*2+lineWeight);
      boxHeight = constrain(boxHeight, 0, 720);
    } else {
      boxHeight = calcHeight();
    }
    
    float lineLength = textWidth-margin*2-lineWeight; //width/12 * 4;
    float lineHeight = y+boxHeight-50;
    //pg = createGraphics(textWidth+margin*2+lineWeight, (int)getBoxHeight()+margin);
    pg = createGraphics(width, (int)getBoxHeight()+margin);
    pg.beginDraw();
    
    pg.textFont(font, fontSize);
    pg.textLeading(fontSize+textLeading);
    if(!hasImage) {
      if(alignment < 0) pg.text(shortText, 0, 0, lineLength, getBoxHeight()+margin);
      else pg.text(shortText, x, 0, lineLength, getBoxHeight()+margin);
    } else {
      p.resize(textWidth+margin*2+lineWeight, 0);
        float pX = x;
        if(alignment < 0) pX = 0;
        PImage cut = p.get(0, 0, textWidth+margin*2+lineWeight, 720);
        pg.image(cut, pX, 0, lineLength, lineHeight-17-margin*2-20);
        pg.push();
        pg.fill(0);
        pg.pop();
        
    }
      
    pg.textFont(font2, 20);
    pg.fill(255);
    pg.noStroke();

    
    if(alignment < 0) {
      //println("links");
      // horizontale
      pg.rect(0, lineHeight-17-margin*2, lineLength, lineWeight);
      // vertikale
      if(!hasImage) pg.rect(lineLength+margin*2, 0, lineWeight, boxHeight-50-17-margin*2+lineWeight);
      pg.noFill();
      pg.stroke(255, 255, 255);
      if(!hasImage) pg.text(author+", "+formatDate(date), 0, lineHeight-margin);
      //else pg.text(description, 0, lineHeight-margin); // old style
      else pg.text(description, 0, lineHeight-margin, lineLength, 60);
    } else {
      //println("rechts");
      pg.textAlign(RIGHT);
      // horizontale linie
      pg.rect(x, lineHeight-17-margin*2, lineLength, lineWeight);
      // vertikale
      if(!hasImage) pg.rect(0, 0, lineWeight, boxHeight-50-17-margin*2+lineWeight);
      //pg.noFill();
      pg.stroke(255, 255, 255);
      if(!hasImage) pg.text(author+", "+formatDate(date), textWidth, lineHeight-margin);
      //else pg.text(description, textWidth, lineHeight-margin, lineLength, 20);  // old style
      else pg.text(description, x, lineHeight-margin, lineLength, 60);
    }
    
    
    pg.endDraw();
    
    println("new bubble: "+author+", "+formatDate(date));
    movement = new Ani(this, 1*FPS, "y", height);    
    
  }
  
  void display() {
    image(pg, (alignment<0 ? x : specificWidth-textWidth), y);
  }
  
  String getDate() {
    return "01.01.1970 - 00:00:00f";
  }
  
  void setPosition(int _x, int _y) {
    //println("setPos int=" + x +", "+ y);
    x = _x;
    y = _y;
  }
  
  void setPosition(float _x, float _y) {
    //println("setPos float=" + x +", "+ y);
    x = _x;
    y = _y;
  }
  
  
  
  int calcWPM() {
    String[] wordsArray = split(shortText, " ");
    return (int)(wordsArray.length * 0.6);
  }
  
  int getWPM() {
    return wpm;
  }
  
  float getBoxHeight() {
    return boxHeight;
  }
  
  float getY() {
    return y;
  }
  
  void moveBox() {
    //println("move box by its own height");
    //float f = position.y-getBoxHeight();
    //setPosition(10, position.y-getBoxHeight());
    
    movement.to(this, animationLength*FPS, "y", y-getBoxHeight());
    
  }
  
  void moveBox(float h) {
    //println("move box by external height");
    movement.to(this, animationLength*FPS, "y", y-h);
    targetY = y-h;
  }

  boolean isThere() {
    return y - targetY < 1;
  }

  boolean leavingFrame() {
    return y < 0;
  }
  
  void moveToBottom() {
   movement.to(this, 0, "y", height);
  }
  
  int getID() {
    return id;
  }
  
  int calcHeight() {
    String[] wordsArray;
    String tempString = "";
    int numLines = 0;
    float textHeight;
    wordsArray = split(shortText, " ");
    for (int i=0; i < wordsArray.length; i++) {
      if (textWidth(tempString + wordsArray[i]) < textWidth-2*margin-lineWeight) {
        tempString += wordsArray[i] + " ";
      } else {
        tempString = wordsArray[i] + " ";
        numLines++;
      }
    }
    numLines++; //adds the last line
    
    textHeight = numLines * (fontSize+textLeading); //(textDescent() + textAscent() + lineSpacing);
    return(round(textHeight)+100);
  }
  
  void dump() {
    println("date: "+ date +" | author: "+ author +" |  shortText | "+ shortText);
  }

 String formatDate(String date) {
    int flag = getDateType(date);
    if(flag == 0) {
    } else if(flag == 1) {
      date = fixDate(date);
    } else if(flag == 2) {
      date = month2date(date);
    }
    return date;
    }
 
 boolean isSplittable(String s, String delimiter) {
    boolean result = false;
    if(s.length() > 0) {
      String[] splitter = split(s, delimiter);
      if(splitter.length > 1) result = true;
    }
    return result;
  }
  
  int getDateType(String s) {
     /* flags 
       0 = do nothing with date; default
       1 = mm/dd/yyyy
       2 = space delimited
     */
     int flag = 0;
     if(isSplittable(s, "/")) {
       flag = 1;
     } else if(isSplittable(s, "-")) {
       if(isSplittable(s, " ")) flag = 0;
       else flag = 2;
     } else if(isSplittable(s, ".")) {
       flag = 0;
     } else if(isSplittable(s, " ")) {
       
       flag = 0;
     }
     return flag;
  }
  
  String month2date(String s) {
    String result = "";
    if(s.length() > 0) {
      String[] splitter = split(s, "-");
      if(splitter.length > 1) {
        for(int i = 0; i<splitter.length; i++) {
          if(i == 0) {
            char c3 = splitter[i].charAt(splitter[i].length()-1);
            if(c3 == '.') splitter[i] = splitter[i].substring(0, splitter[i].length()-1);
            for(int j = 0; j<months.length; j++) {
              if(months[j][0].equals(splitter[i])) {
                splitter[i] = months[j][1];
                break;
              }
            }
            result = splitter[i] + " ";
          } else if(i == 1) {
            splitter[i] = addYear(splitter[i]);
            result += splitter[i];
          }
          
        }
      }
    }
    return result;
  }
  
  String fixDate(String s) {
    String join = "";
    String[] newDate = new String[3];
    
    if(s.length() > 0) {
      String[] splitter = split(s, "/");
      if(splitter.length > 1) {
        for(int i = 0; i<splitter.length; i++) {
          if(i == 0) {
            splitter[i] = addZeros(splitter[i]);
            newDate[1] = splitter[i];
          } else if(i == 1) {
            splitter[i] = addZeros(splitter[i]);
            newDate[0] = splitter[i];
          } else if(i == 2) {
            splitter[i] = addYear(splitter[i]);
            newDate[2] = splitter[i];
          }
        }
        for(int i = 0; i<newDate.length; i++) {
          join += newDate[i];
          if(i != newDate.length-1) join += ".";
        }     
      }
    }
    return join;
  }
  
  String addZeros(String s) {
    if(s.length() < 2) {
      s = "0" + s;
    }
    return s;
  }
  
  String addYear(String s) {
    if(s.length() >= 2) {
      s = "19" + s;
    }
    return s;
  }
  
  
  
  String filenameParserForEditorsWhoUseUmlauteAndSpacesAndOtherWeirdThingsInTheirFiles(String s) {
    String returner = s; 
    returner = returner.replaceAll(" ", "_");
    returner = returner.replaceAll("JPG", "jpg");
    returner = returner.replaceAll("jpeg", "jpg");
    returner = returner.replaceAll("JPEG", "jpg");
    
    returner = returner.replaceAll("ä", "ae");
    returner = returner.replaceAll("ü", "ue");
    returner = returner.replaceAll("ö", "oe");
    returner = returner.replaceAll(",", "");
    
    
   
    return returner;
  }
  
  float scaleWidth(float originalW, float originalH, float desiredWidth) {
    return originalH / originalW * desiredWidth;
  }
  
  float scaleHeight(float originalW, float originalH, float desiredHeight) {
    return originalW / originalH * desiredHeight;
  }
  
}
