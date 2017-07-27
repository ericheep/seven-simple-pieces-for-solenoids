// untitled-7.ck
// (vibration-tones)

// July 27th, 2017
// Eric Heep

// init

1 => int test;
40 => int threshold;
0.9 => float pole;
0.1::samp => dur chainDuration;

Meepo meep;
Pitchtrack pitch[3];
Gain g[3];

if (test) {
    adc => g[0] => dac;
    adc => l => blackhole;
    g[0].gain(0.0);
} else {
    for (0 => int i; i < 3; i++) {
        adc.chan(i) => g[i] => dac.left;
        adc.chan(i) => pitch[i];
    }

    meep.init();
}

// guts

fun void main() {
}

// run

second => now;
<<< "okay", "" >>>;

main();
