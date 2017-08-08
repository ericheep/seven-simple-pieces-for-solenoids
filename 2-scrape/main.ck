// main.ck
// (scrape)

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
    for (0 => int i; i < 3; i++) {
        adc.chan(i) => g[i] => dac.left;
        adc.chan(i) => l;
    }
    l => blackhole;

    meep.init();
}

// guts

fun void magnetize(int idx, dur length) {
    now => time start;

    Math.random2(5, 6) => int velocity;
    Math.random2(6, 7)::ms => dur milliseconds;

    while (now < start + length) {
        meep.actuate(idx, velocity);
        milliseconds => now;
    }
}

fun void beeps() {
    [0, 1, 2] @=> int order[];
    u.shuffleArray(order);

    for (0 => int i; i < 3; i++) {
        spork ~ magnetize(order[i], 30::ms);

        70::ms => now;
    }
}

fun void main() {
    now => time startDuration;
    500::ms => dur loopDuration;
    1::ms => dur increment;
    while (true) {
        beeps();
        loopDuration - increment => loopDuration;
        loopDuration => now;
        <<< "loop: ", loopDuration/ms, "total: ", (now - startDuration)/minute, ""  >>>;
    }
}

// run

second => now;
<<< "okay", "" >>>;

main();
