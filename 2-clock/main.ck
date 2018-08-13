// main.ck
// (clock)

// August 8th, 2017
// Eric Heep

// init

0 => int test;

Meepo meep;
Utility u;
Listener l;
Gain g[3];

if (test) {
    adc => g[0] => dac;
    adc => l => blackhole;
    g[0].gain(0.0);
} else {
    adc.chan(0) => g[0] => dac.left;
    adc.chan(1) => g[1] => dac;
    adc.chan(2) => g[2] => dac.right;

    g[1].gain(0.8);

    for (0 => int i; i < 3; i++) {
        adc.chan(i) => l;
    }

    l => blackhole;

    meep.init();
}

// guts

fun void magnetize(int idx, dur length) {
    now => time start;

    20 => int velocity;
    20::ms => dur milliseconds;

    while (now < start + length) {
        meep.actuate(idx, velocity);
        milliseconds => now;
    }
}

fun void beeps() {
    [0, 1, 2] @=> int order[];
    /* u.shuffleArray(order); */

    for (0 => int i; i < 3; i++) {
        spork ~ magnetize(order[i], 30::ms);

        70::ms => now;
    }
}

fun void main() {
    now => time startDuration;
    while (now < startDuration + 3.5::minute) {
        beeps();
    }
}

// run

second => now;
<<< "okay", "" >>>;

main();
