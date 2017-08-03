// main.ck
// (vibration-tones)

// August 1st, 2017
// Eric Heep

// init

1 => int test;

Meepo meep;
ADSR solenoidFadeOut;
ADSR sineFadeIn;

PitchTrack pitch[3];
SinOsc sin[3];
Gain g[3];


if (test) {
    for (0 => int i; i < 3; i++) {
        adc => g[i] => solenoidFadeOut => dac;
        g[i] => pitch[i] => blackhole;
        sin[i] => sineFadeIn => dac;

        spork ~ pitchSearch(i);
    }
} else {
    for (0 => int i; i < 3; i++) {
        adc.chan(i) => g[i] => solenoidFadeOut => dac.left;
        g[i] => pitch[i] => blackhole;
        sin[i] => sineFadeIn => dac.left;

        spork ~ pitchSearch(i);
    }

    meep.init();
}

// guts

fun void magnetize(int idx, dur duration) {
    now => time start;

    Math.random2(3, 7) => int velocity;
    Math.random2(3, 7)::ms => dur milliseconds;

    while (now < start + duration) {
        if (!test) {
            meep.actuate(idx, velocity);
        }

        milliseconds => now;
    }
}

fun void pitchSearch(int idx) {
    float expectedFreq;
    float currentFreq;
    0.01 => float freqIncrement;

    while (true) {
        pitch[idx].get() => expectedFreq;
        sin[idx].freq() => currentFreq;

        if (currentFreq < expectedFreq) {
            freqIncrement +=> currentFreq;
        } else {
            freqIncrement -=> currentFreq;
        }

        <<< expectedFreq, currentFreq >>>;

        10::ms => now;
    }
}

fun void solenoidBranch(dur totalDuration, dur fadeDuration) {
    solenoidFadeOut.attackTime(1::samp);
    solenoidFadeOut.releaseTime(fadeDuration);
    solenoidFadeOut.keyOn();

    1::samp => now;

    // start fade out piezos and actuate

    solenoidFadeOut.keyOff();

    for (0 => int i; i < 3; i++) {
        spork ~ magnetize(i, totalDuration);
    }

    totalDuration => now;
}

fun void sineBranch(dur fadeDuration) {
    sineFadeIn.attackTime(fadeDuration);

    // start to fade in sine tones fade in

    sineFadeIn.keyOn();

    fadeDuration => now;
}

fun void main() {
    3::minute => dur totalDuration;
    0.666 * totalDuration => dur fadeDuration;
    0.333 * totalDuration => dur waitDuration;

    spork ~ solenoidBranch(totalDuration, fadeDuration);

    waitDuration => now;

    spork ~ sineBranch(fadeDuration);

    fadeDuration => now;
}

// run

second => now;
<<< "okay", "" >>>;

main();
