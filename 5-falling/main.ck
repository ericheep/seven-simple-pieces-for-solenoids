// main.ck
// (falling)

// July 27th, 2017
// Eric Heep

// init

0 => int test;
70 => int threshold;
0.9 => float pole;
200::ms => dur chainDuration;
1::ms => dur chainIncrement;

Meepo meep;
Listener l;
Utility u;
Gain g[3];

if (test) {
    adc => g[0] => dac;
    adc => l => blackhole;
    g[0].gain(0.0);
} else {
    for (0 => int i; i < 3; i++) {
        adc.chan(i) => g[i] => dac.left;
        adc.chan(i) => l => blackhole;
    }

    meep.init();
}


// guts

fun void chain() {
    [0, 1, 2] @=> int order[];
    u.shuffleArray(order);

    for (0 => int i; i < 3; i++) {
        if (test) {
            <<< i, chainDuration/second, "" >>>;
        } else {
            meep.actuate(order[i], 50);
        }
        if (i < 2) {
            chainDuration => now;
        }
    }

    chainIncrement -=> chainDuration;
    <<< chainDuration/ms, "" >>>;
}

fun void main() {
    while (chainDuration > 1::samp) {
        l.setPole(pole);
        while (l.isBelow(threshold)) {
            1::samp => now;
        }
        l.setPole(0.0);

        chainDuration => now;
        chain();
    }

    <<< "good job", "" >>>;
}

// run

second => now;
<<< "okay", "" >>>;

main();
