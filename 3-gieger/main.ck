// main.ck
// (geiger)

// August 8th, 2017
// Eric Heep

// init

Meepo meep;
Gain g[3];

0 => int test;

if (test) {
    adc => g[0] => dac;
    g[0].gain(0.0);
} else {
    adc.chan(0) => g[0] => dac.left;
    adc.chan(1) => g[1] => dac;
    adc.chan(2) => g[2] => dac.right;

    g[1].gain(0.8);

    meep.init();
}

// guts

fun void geiger(int idx, dur length) {
    Math.random2(0, 1) => int which;
    now => time start;
    while (now - start < length) {
        if (which) {
            meep.actuate(idx, 6);
            1::ms => now;
        } else {
            meep.actuate(idx, 10);
            2::ms => now;
        }
    }
}

fun void main() {
    3.5::minute => dur pieceDuration;

    now => time start;
    while (now - start < pieceDuration) {
        Math.random2(3, 15)::second => dur intervalDuration;
        Math.random2(0, 2) => int idx;
        geiger(idx, intervalDuration);
    }
}

// run

second => now;
<<< "okay", "" >>>;

main();
<<< "done", "" >>>;
