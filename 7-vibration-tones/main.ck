// untitled-7.ck
// (vibration-tones)

// July 27th, 2017
// Eric Heep

// init

1 => int test;

Meepo meep;
ADSR attackEnv;
ADSR releaseEnv;

release.attack(0::samp);

PitchTrack pitch[3];
SinOsc sin[3];
Gain g[3];

for (0 => int i; i < 3; i++) {
    sin[i] => env => dac.left;
}

if (test) {
    adc => g[0] => releaseEnv => dac;
    for (0 => int i; i < 3; i++) {
        sin[i].freq(500 + i * 7.0);
    }
    g[0].gain(0.0);
} else {
    for (0 => int i; i < 3; i++) {
        adc.chan(i) => g[i] => releaseEnv => dac.left;
        adc.chan(i) => pitch[i];
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

fun void main() {
    3::minute => dur totalDuration;

    releaseEnv.releaseTime(totalDuration);

    releaseEnv.keyOn();
    1::samp => now;
    releaseEnv.keyOff();


    for (0 => int i; i < 3; i++) {
        spork ~ magnetize(i, actuateDuration);
    }

    totalDuration * .333 => now;

    attackEnv.attackTime(totalDuration);
    attackEnv.keyOn();

    totalDuration * .333 => now;


    totalDuration * .333 => now;
}

// run

second => now;
<<< "okay", "" >>>;

main();
