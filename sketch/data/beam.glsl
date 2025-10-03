precision highp float;
precision highp sampler2D;

varying vec4 vertTexCoord;

uniform float u_time;
uniform float u_width;
uniform float u_height;
uniform float u_pulse;

const float PI = 3.14159265359f;

// Based on https://www.shadertoy.com/view/DsfSWj

void main()
{
  vec2 uv = vertTexCoord.xy;
  uv -= vec2(0.5);
  uv.x *= u_width/u_height;
  // Draw the lines
  const float it = 5.0;
  float c = 0.0;
  for( float i = 0.0 ; i < it ; i += 1.0 )// line copy from here https://www.shadertoy.com/view/MtBGRt
  {
      float react = .0;
      float c1 = (uv.x + 4.0 + react) * 0.004 * abs( 1.0 / sin( (uv.y * .0) +
        sin(uv.x* 1.4))*(-.3));
      c = clamp(c + c1, 0.0, 1.0);
  }
  vec2 origin = vec2(c);
  float timeValue = u_time ;
  // float angleRad = cos(timeValue);
  float angleRad = u_pulse;
  float offset = mix(.77, 0.5, angleRad); //aligned by 2
  vec2 e = origin;
  
  vec2 cylinderTexCoords = e; // coordinates for shining. Can be apply with sdf or black/white texture( mask)
  cylinderTexCoords.x = (asin(clamp(2.0 * origin.x - 1.0, -1.0, 1.0))) / (PI) + (offset * origin.y) + (0.5 * u_pulse);
  
  vec2 inverseCylinderTexCoords = origin;
  inverseCylinderTexCoords.x = cylinderTexCoords.x - (2.0 * offset * origin.y);
  
  // Calculate final intensity
  float finalIntensity = c + (cylinderTexCoords.x * inverseCylinderTexCoords.x);
  
  // Use intensity as alpha for transparent background
  vec3 beamColor = vec3(0.812,0.525,0.086);
  gl_FragColor = vec4(beamColor * finalIntensity, finalIntensity);
}
