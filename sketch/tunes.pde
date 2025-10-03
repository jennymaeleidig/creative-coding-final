//sounds
int minTrackPos = 0;
int maxTrackPos = 0; // will be set based on total length of all tracks
String[][] trackMetadata; //2D array to hold track file names and titles
Minim minim; //https://stackoverflow.com/questions/53950278/outofboundsexception-in-processing-sound-library
Track currentTrack;
float globalVolume = 0; // master volume in dB (range -80 .. 6)

class Track {
  String name;
  int number; //track number (1-based)
  int length; //in ms
  int globalStartPos; //in ms
  int globalEndPos; //in ms
  AudioPlayer player;

  Track(String name, int number, int length, int globalStartPos, AudioPlayer player) {
    this.name = name;
    this.number = number;
    this.length = length;
    this.globalStartPos = globalStartPos;
    this.globalEndPos = globalStartPos + length;
    this.player = player;
  }
}

List<Track> tracks = new ArrayList<Track>();

void initTracks() {

  minim = new Minim(this);

  //OG Kanji Converted to half width kana so it works with the Japanese font
  //https://nihongodera.com/tools/convert
  //https://dencode.com/en/string/character-width
  trackMetadata = new String[][] {
    {"track-01.wav", "ﾕﾋﾞ ｦ ﾅｶﾞﾚﾙ ｽﾅ"},
    {"track-02.wav", "ｻｷｭｳ"},
    {"track-03.wav", "ｼﾞﾒﾝ ﾊ ｱﾂｲ"},
    {"track-04.wav", "ｽﾅ ﾉ ｸｯｼｮﾝ"},
    {"track-05.wav", "ｲｷ"},
    {"track-06.wav", "ｻﾘｭｳ"},
    {"track-07.wav", "ｲｯｼｮｳ"},
    {"track-08.wav", "ﾃﾝｺﾞｸ ﾉ ﾖｳﾅ ｶﾝｼﾞ"}
  };

  maxTrackPos = 0;
  for (String[] track : trackMetadata) {
    String fileName = track[0];
    String title = track[1];
    AudioPlayer player = minim.loadFile(fileName);
    // apply master volume to each loaded player so they start at the same level
    player.setGain(globalVolume);
    // Debug: log each track's length and total
    int totalLength = 0;
    for (int i = 0; i < tracks.size(); i++) {
      totalLength += tracks.get(i).length;
    }
    tracks.add(new Track(title, tracks.size() + 1, player.length(), maxTrackPos, player));
    maxTrackPos += player.length(); // accumulate total length
  }

  currentTrack = tracks.get(0); // Start with the first track
}



void seek(int position) {
  // Find the track that contains the given position
  boolean wasPlaying = currentTrack.player.isPlaying();
  for (Track track : tracks) {
    if (position >= track.globalStartPos && position <= track.globalEndPos) {
      // If it's a different track than the current one, switch
      if (track != currentTrack) {
        if (currentTrack.player.isPlaying()) {
          currentTrack.player.pause();
        }
        currentTrack = track;
      }
      // Calculate the position within the track
      int trackPosition = position - track.globalStartPos;
      currentTrack.player.cue(trackPosition);
      // ensure the track uses the current master volume when resumed/played
      currentTrack.player.setGain(globalVolume);
      if (wasPlaying) {
        currentTrack.player.play();
      }

      break;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    if ( currentTrack.player.isPlaying() ) {
      currentTrack.player.pause();
    }
    // if the player is at the end of the file,
    // advance to the next track (wrap to first)
    else if ( currentTrack.player.position() == currentTrack.player.length() ) {
      int currentIndex = tracks.indexOf(currentTrack);
      int nextIndex = (currentIndex + 1) % tracks.size();
      currentTrack.player.pause();
      currentTrack = tracks.get(nextIndex);
      currentTrack.player.cue(0);
      currentTrack.player.setGain(globalVolume);
      currentTrack.player.play();
    } else {
      currentTrack.player.play();
    }
  }

  if (keyCode == UP) {
    // Increase global (master) volume by 1 dB
    globalVolume = constrain(globalVolume + 1, -80, 6);
    // apply to currently selected track
    currentTrack.player.setGain(globalVolume);
  }

  if (keyCode == DOWN) {
    // Decrease global (master) volume by 1 dB
    globalVolume = constrain(globalVolume - 1, -80, 6);
    // apply to currently selected track
    currentTrack.player.setGain(globalVolume);
  }

  if (keyCode == RIGHT) {
    // jump to beginning of next track (wrap to first)
    boolean wasPlaying = currentTrack.player.isPlaying();
    int currentIndex = tracks.indexOf(currentTrack);
    int nextIndex = (currentIndex + 1) % tracks.size();
    // proceed even if wrapping to first; if only one track this will do nothing visible
    if (nextIndex != currentIndex || tracks.size() > 1) {
      currentTrack.player.pause();
      currentTrack = tracks.get(nextIndex);
      currentTrack.player.cue(0);
      currentTrack.player.setGain(globalVolume);
      if (wasPlaying) {
        currentTrack.player.play();
      }
    }
  }

  if (keyCode == LEFT) {
    // jump to beginning of previous track, do nothing if already at first
    boolean wasPlaying = currentTrack.player.isPlaying();
    int currentIndex = tracks.indexOf(currentTrack);
    if (currentIndex > 0) {
      int prevIndex = currentIndex - 1;
      currentTrack.player.pause();
      currentTrack = tracks.get(prevIndex);
      currentTrack.player.cue(0);
      currentTrack.player.setGain(globalVolume);
      if (wasPlaying) {
        currentTrack.player.play();
      }
    }
  }
}

int getCurrentGlobalPosition() {
  return currentTrack.globalStartPos + currentTrack.player.position();
}
