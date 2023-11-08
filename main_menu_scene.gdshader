// Shader Code updated for Godot 4.0 and optimized

shader_type sky;
render_mode use_half_res_pass;

// Horizon
uniform float offsetHorizon : hint_range(-1.0, 1.0, 0.001) = 0.236;
uniform float horizonIntensity : hint_range(-10.0, 5.0, 0.001) = -0.443;
uniform vec4 sunSetColor : source_color = vec4(0.56, 0.24, 0.0, 1.0);
uniform vec4 horizonColorDay : source_color = vec4(0.57, 0.53, 0.26, 1.0);
uniform vec4 horizonColorNight : source_color = vec4(0.09, 0.16, 0.04, 1.0);

// Sun
uniform vec4 sunColor : source_color = vec4(1.0);
uniform float sunRadius : hint_range(0.0, 2.0, 0.001) = 0.2;
uniform bool flatSun = true;

// Moon
uniform vec4 moonColor : source_color = vec4(1.0);
uniform float moonRadius : hint_range(0.0, 2.0, 0.01) = 0.05;
uniform float moonCrescent : hint_range(-0.3, 0.3, 0.001) = -0.024;

// Sun and Moon Horizon fade parameters
uniform bool enableHorizonFade = true;
uniform float horizonFadeSize = 0.2;
uniform float horizonFadeBlend = 0.1;

// Day Background Colors
uniform vec4 dayBottomColor : source_color = vec4(0.4, 1.0, 1.0, 1.0);
uniform vec4 dayTopColor : source_color = vec4(0.8, 0.8, 1.0, 1.0);

// Night Background Colors
uniform vec4 nightBottomColor : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform vec4 nightTopColor : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Stars
uniform sampler2D starsTexture : source_color;
uniform float starsSpeed : hint_range(0.0, 1.0, 0.001) = 0.2;
uniform float starsCutoff : hint_range(0.0, 1.0, 0.001) = 0.702;
uniform vec4 starsSkyColor : source_color = vec4(0.0, 0.11, 0.05, 1);
uniform float offsetStars : hint_range(-2.0, 2.0, 0.001) = 0.083;
uniform float starsIntensity : hint_range(-10.0, 10.0, 0.001) = -2.829;
uniform float starFalloff : hint_range(1.0, 10.0, 0.001) = 1.79;
uniform float starsFadeModulation : hint_range(-1.80, 1.80, 0.001) = 0.91;

// Clouds
uniform sampler2D cloudNoise1 : source_color;
uniform sampler2D cloudNoise2 : source_color;
uniform vec4 cloudEdgeDayColor : source_color = vec4(0.9, 0.9, 0.9, 1.0);
uniform vec4 cloudMainDayColor : source_color = vec4(1.0);
uniform vec4 cloudEdgeNightColor : source_color = vec4(0.65, 0.79, 0.25, 1.0);
uniform vec4 cloudMainNightColor : source_color = vec4(0.75, 0.76, 0.20, 1.0);
uniform float cloudSpeed1 = 0.01;
uniform float cloudSpeed2 = 0.02;
uniform float cloudSpeed3 = 0.02;
uniform float cloudScale1 = 0.425;
uniform float cloudScale2 = 0.074;
uniform float cloudScale3 = 0.075;
uniform float cloudDistortion = 1.95;
uniform float cloudStrength = 1.0;
uniform float cloudCutoff = 0.013;
uniform float cloudIntensity : hint_range(-10.0, 10.0, 0.001) = -0.009;

void sky() {
    vec3 sunDir = normalize(vec3(0.0, TIME * sunRadius, 0.0));
    vec3 moonDir = normalize(vec3(0.0, TIME * moonRadius, 0.0));

    float horizonLine = smoothstep(-offsetHorizon, offsetHorizon, EYEDIR.y);
    vec3 horizonBlendColor = mix(horizonColorNight.rgb, horizonColorDay.rgb, horizonLine);

    float sunDisc = flatSun ? 1.0 : max(0.0, dot(sunDir, vec3(0.0, -1.0, 0.0)));
    float moonDisc = flatSun ? 1.0 : max(0.0, dot(moonDir, vec3(0.0, -1.0, 0.0)));

    // Calculate day and night colors
    float topMask = horizonLine * 0.5 + 0.5;
    vec4 dayColor = mix(dayBottomColor, dayTopColor, topMask);
    vec4 nightColor = mix(nightBottomColor, nightTopColor, topMask);

    // Calculate stars visibility
    float starVisibility = smoothstep(starsCutoff, starsCutoff + starsFadeModulation, topMask);
    vec4 stars = texture(starsTexture, FRAGCOORD.xy * starsSpeed + vec2(TIME * starsSpeed, 0.0));
    stars = mix(starsSkyColor, stars, starVisibility);

    // Calculate cloud visibility
    vec3 cloudColor = texture(cloudNoise1, FRAGCOORD.xy * cloudSpeed1).rgb * cloudStrength;
    cloudColor += texture(cloudNoise2, FRAGCOORD.xy * cloudSpeed2).rgb * cloudStrength;
    cloudColor = mix(cloudEdgeNightColor.rgb, cloudEdgeDayColor.rgb, horizonLine);
    cloudColor = mix(cloudColor, horizonBlendColor, cloudCutoff);

    // Final sky color calculation
    vec3 skyColor = mix(nightColor.rgb, dayColor.rgb, horizonLine);
    skyColor = mix(skyColor, sunColor.rgb, sunDisc);
    skyColor = mix(skyColor, moonColor.rgb, moonDisc);
    skyColor = mix(skyColor, stars.rgb, starVisibility);
    skyColor = mix(skyColor, cloudColor, cloudIntensity);

    COLOR = skyColor;
}
