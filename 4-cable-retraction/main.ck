// main.ck
// (cable-retraction)

// July 27th, 2017
// Eric Heep

// init

Meepo meep;
Gain g[3];

1 => int test;

if (test) {
    adc => g[0] => dac;
    g[0].gain(0.0);
} else {
    for (0 => int i; i < 3; i++) {
        adc.chan(i) => g[i] => dac.left;
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
