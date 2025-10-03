/*
  Jenny Leidig
  Creative Coding
  Final Project
  Fall 2025

  Outline:
    This is my interpretation of "dream desert" by "desert sand feels warm at night"
    and the album cover of which by "Secret Schools".

    The album is available here: https://geometriclullaby.bandcamp.com/album/desert-sand-feels-warm-at-night

    A key theme through out this piece is the ethereal nature of dreams.
    I see the desert as an ocean of time that is ebbing, flowing, and lethargic in nature.
    I wanted to capture this feeling, which I feel that this album cover and album itself do very well.
    The pyramid in this piece serves as a sort of beacon, alluding to the vastness of the space and time it occupies.
    The sand is ever shifting, the beacon seems to draw its power from the earth below, and project it into stars above.

    I tried to capture the above in my recreation of this piece.
    The image moves, yet is still. The sand shifts, the sky moves, the pyramid glows.
    Time passes, slowly. the speed of which is almost imperceptible.
    By interjecting, the user can influence the flow of time and space within the piece.

  Concepts Used and Challenges Faced:
  - GLSL shaders
    - NOTE: that these shaders were first adapted to `#version 300 es`, the version used by glsl.app
      however, processing uses an older version of GLSL, so some syntax had to be changed
      for this I utilized some AI tooling to help with the conversion
      I have found that for backwards ports, AI tools are very helpful especially in ecosystems that I am not as familiar with
      The AI tooling here was only used to help with syntax conversion and supplement my learning, not to create the shaders themselves
    - palette cycling
      - this concept i was already familar with and really wanted to learn how to to utilize it as a tool
        I found a great video / turorial that properly introduced me to the concept of shaders and glsl.
      - a tool that i learned from this, glsl.app, is one that I used throughout the project to prototype and test shaders
      - it was difficult to detemine where best to apply this effect, but after some deliberation and research online
        i found that it is best used to particle effects or simple animated patterns, which lead me to use it for the simple pulsing animation
    - animated gradient
      - since the concepts of the shaders we so new to me, I found the guide i refence in the code here to be very helpful in understanding the basics
      - working through this tutorial allowed me to get a more solid grasp of the basics so that I could then port these shaders to processing
    - beam
      - this shader was one that I found online and modified to fit my needs
      - since i had gained the basic understanding of shaders from the previous two, I was able to adapt this one more easily
    - light bloom / glow
      - I originally intended to use a bloom shader for the particle effects, but after taking a step back
        I realized I was overcomplicating the effect I wanted to achieve. I was able to accomplish this by creating a simple overlay and blending
        it additively.
  - PGraphics
    - texture mapping
      - drawing to offscreen buffer
        - this was a technique I had not used before, but found it to be very useful for creating the pyramid pattern
          i used this piece as an oppotunity to experiment with drawing to an offscreen buffer, a technique that I saw as a common
          practice online.
        - I came across this technique as I knew that I wanted to generate the texture programmatically,
          which I was able to do realtively straightforwardly. The key piece here is then in creating the resulting texture as a PImage
          so it can be properly mapped to the shape
      - applying as texture to shape
        - This definitely took some trial and error to get the texture to map properly
          I took this piece as an opportunity to solidify my understanding of textures and uv mapping
          the biggest challenge here was getting the texture to map properly to the shape by manually adjusting the uv coordinates
  - Minim sound library
    - audio playback
      - the build in library is known to have issues, so I used a workaround from StackOverflow
      - i ran into some playback speed issues when decoding mp3 realtime, so I converted to wav
      - i initally began trying to map the playback position to a single file for the entire album
        but the total runtime was too long for the internal dataypes of the Minim library (overflow)
        so i created a workaround by using multiple files and mapping to each segment
  - Classes
  - Loops
  - Arrays
  - Interactivity
    - mouse interaction
      - the moon is draggable, and its position determines the playback head of the audio
    - keyboard interaction
      - spacebar toggles playback / pause menu
    - there are checkpoints at the end of each track, when reached playback pauses and the user must click play to continue
      once clicked, the next track begins playing
  - Asset Creation
    - I wanted to recreate every part of this piece, so I created all assets myself
    - I utilized Photoshop heavily for creating the textures and images, especially when it came to getting the scale and proportions right
    - for the audio assets, I used Audacity to splice the full audio into segments and convert to wav
  - Trigonometry
    - circles and mapping to circular paths is hard, i heavily relied on stack overflow for general guidance
      sources i used are linked in the relevant files
    - throughout the knowledge gathering of this project, I learned that trigonometry is not my strong suit
      and I will need to continue practicing it in order to fully understand it.
      however, there are some very important concepts that I was able solidify, especially the use of sine
      waves to create cyclical motion
    - the animation of the piece is tied to the position of the moon along a circular path
      - the moon position is determined by the playback head of the audio track
        since the moon itself is interactive, this creates a timelapse effect when the moon is dragged by the user
*/

// https://stackoverflow.com/questions/53950278/outofboundsexception-in-processing-sound-library
import ddf.minim.*;
import java.util.List;
import java.util.ArrayList;

//colors
color lightestOrange = #cf8616;
color lightOrange = #d67f1d;
color orange = #d46a27;
color darkOrange = #f66706;
color darkestOrange = #cd4f0c;
color black = #010101;
var canvas;

void setup() {
  //initialization
  canvas = createCanvas(512, 512, P3D);
  background(black);
  noSmooth(); // sharp!!

  initStars();

  initMoon();

  initSand();

  initPyramid();

  initTracks();

  initPulseCycle();

  initBeam();

  initParticles();

  initTitle();

  initMenu();
}

void draw() {
  //order here determines layering
  background(black);

  drawStars();

  drawMoon();

  drawSand();

  drawParticles();

  drawBeam();

  drawPyramid();

  drawPulseCycle();

  drawBorder();

  drawTitle();

  drawMenu();
}
