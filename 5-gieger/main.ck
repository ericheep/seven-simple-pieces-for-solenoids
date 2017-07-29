// main.ck
// (geiger)

// July 27th, 2017
// Eric Heep

// init

Meepo meep;
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

fun void geiger(int idx) {
}

fun void main() {
    spork ~ geiger(0);
    spork ~ geiger(1);
    spork ~ geiger(2);
}

// run

second => now;
<<< "okay", "" >>>;

main();
