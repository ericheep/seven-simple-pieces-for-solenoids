// main.ck
// (vibration-tones)

// August 8th, 2017
// Eric Heep

// init

0 => int test;

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
    adc.chan(0) => g[0] => solenoidFadeOut => dac.left;
    adc.chan(1) => g[1] => solenoidFadeOut => dac;
    adc.chan(2) => g[2] => solenoidFadeOut => dac.right;

    sin[0] => sineFadeIn => dac.left;
    sin[1] => sineFadeIn => dac;
    sin[2] => sineFadeIn => dac.right;

    for (0 => int i; i < 3; i++) {
        g[i] => pitch[i] => blackhole;
        sin[i].freq(100);

        spork ~ pitchSearch(i);
    }

    meep.init();
}

// guts

fun void magnetize(int idx, dur duration) {
    now => time start;

    Math.random2(3, 5) => int velocity;
    Math.random2(3, 9)::ms => dur milliseconds;

    while (now < start + duration) {
        if (!test) {
            meep.actuate(idx, velocity);
        }

        milliseconds => now;
    }
}

fun void pitchSearch(int idx) {
    float expectedFreq;
    100 => float currentFreq;
    0.1 => float freqIncrement;

    while (true) {
        pitch[idx].get() => expectedFreq;

        if (currentFreq < expectedFreq) {
            freqIncrement +=> currentFreq;
        } else {
            freqIncrement -=> currentFreq;
        }

        currentFreq * (idx + 1) => sin[idx].freq;

        100::ms => now;
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

fun void freqPrint() {
    while (true) {
        <<< "1: ", sin[0].freq(), pitch[0].get(),
            "2: ", sin[1].freq(), pitch[1].get(),
            "3: ", sin[2].freq(), pitch[2].get(), "" >>>;
        100::ms => now;
    }
}

fun void main() {
    spork ~ freqPrint();
    3.0::minute => dur totalDuration;
    0.666 * totalDuration => dur fadeDuration;
    0.333 * totalDuration => dur waitDuration;

    spork ~ solenoidBranch(totalDuration, fadeDuration);

    waitDuration => now;

    spork ~ sineBranch(fadeDuration);

    fadeDuration => now;

    for (0 => int i; i < 3; i++) {
        spork ~ magnetize(i, 1::minute);
    }

    1::minute => now;
}

// run

second => now;
<<< "okay", "" >>>;

main();
