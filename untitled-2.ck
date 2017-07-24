// untitled-2.ck
// July 23rd, 2017
// Eric Heep

// init

1 => int test;
25 => int threshold;
0.1::samp => dur chainDuration;

Meepo meep;
Gain g[3];

if (test) {
    adc => g[0] => dac;
    g[0].gain(0.0);
} else {
    adc.chan(0) => g[0] => dac.left;
    adc.chan(1) => g[1] => dac.left;
    adc.chan(2) => g[2] => dac.left;

    meep.init();
}

adc => Listener l => blackhole;
l.setPole(0.9);

// guts

fun void chain() {
    for (0 => int i; i < 3; i++) {
        <<< i, chainDuration/second, "" >>>;
    }
    chainDuration * 2 => chainDuration;
}

fun void main() {
    while (true) {
        while (l.isBelow(threshold)) {
            1::samp => now;
        }

        chainDuration * 3 => dur chainTotal;
        if (chainTotal < second) {
            second => now;
        } else {
            chainTotal => now;
        }

        chain();
    }
}

// run

second => now;
<<< "Okay.", "" >>>;

main();
