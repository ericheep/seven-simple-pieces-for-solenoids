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

fun void main() {
}

// run

second => now;
<<< "okay", "" >>>;

main();
