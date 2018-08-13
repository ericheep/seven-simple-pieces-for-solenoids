// main.ck
// (vibration-tones)

// August 8th, 2017
// Eric Heep

// init

0 => int test;

Meepo meep;
ADSR solenoidFadeOut[3];
ADSR sineFadeIn[3];

PitchTrack pitch[3];
SinOsc sin[3];
Gain g[3];
HPF hpf[3];


if (test) {
    for (0 => int i; i < 3; i++) {
        adc => g[i] => solenoidFadeOut[i] => dac;
        g[i] => pitch[i] => blackhole;
        sin[i] => sineFadeIn[i] => dac;

        spork ~ pitchSearch(i);
    }
} else {
    adc.chan(0) => g[0] => solenoidFadeOut[0] => dac.left;
    adc.chan(1) => g[1] => solenoidFadeOut[1]  => dac;
    adc.chan(2) => g[2] => solenoidFadeOut[2]  => dac.right;

    sin[0] => sineFadeIn[0] => dac.left;
    sin[1] => sineFadeIn[1] => dac;
    sin[2] => sineFadeIn[2] => dac.right;

    for (0 => int i; i < 3; i++) {
        g[i] => pitch[i] => blackhole;
        sin[i].freq(100);
        sin[i].gain(0.2);

        spork ~ pitchSearch(i);
    }

    meep.init();
}

// guts

fun void magnetize(int idx, dur duration, int inc) {
    now => time start;

    5 => int velocity;
    6::ms => dur milliseconds;

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

        currentFreq => sin[idx].freq;

        20::ms => now;
    }
}

fun void solenoidBranch(dur totalDuration, dur fadeDuration, int idx) {
    for (0 => int i; i < 3; i++) {
        solenoidFadeOut[i].attackTime(1::samp);
        solenoidFadeOut[i].releaseTime(fadeDuration);
        solenoidFadeOut[i].keyOn();
    }

    1::samp => now;

    // start fade out piezos and actuate

    for (0 => int i; i < 3; i++) {
        solenoidFadeOut[i].keyOff();
    }

    for (0 => int i; i < 3; i++) {
        spork ~ magnetize(i, totalDuration, idx);
    }

    totalDuration => now;
}

fun void sineBranch(dur fadeDuration) {
    for (0 => int i; i < 3; i++) {
        sineFadeIn[i].attackTime(fadeDuration);
        sineFadeIn[i].keyOn();
    }

    fadeDuration => now;

    for (0 => int i; i < 3; i++) {
        sineFadeIn[i].releaseTime(10::ms);
        sineFadeIn[i].keyOff();
    }
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
    2.5::minute => dur totalDuration;
    0.666 * totalDuration => dur fadeDuration;
    0.333 * totalDuration => dur waitDuration;

    spork ~ solenoidBranch(totalDuration, fadeDuration, 0);

    waitDuration => now;

    spork ~ sineBranch(fadeDuration);

    fadeDuration => now;
}

// run

second => now;
<<< "okay", "" >>>;

main();
