// main.ck
// (cable-retraction)

// July 27th, 2017
// Eric Heep

// init

Meepo meep;
Gain g[3];

0 => int test;

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

fun void loudNoises(int idx) {
    while (true) {
        Math.random2(50, 70) => int vel;
        Math.random2(100, 170)::ms => dur wait;
        meep.actuate(idx, vel);
        wait => now;
    }
}


fun void main() {
    spork ~ loudNoises(0);
    spork ~ loudNoises(1);
    spork ~ loudNoises(2);

    now => time startDuration;
    while (now - startDuration < 4::minute) {
        1::ms => now;
    }
}

// run

second => now;
<<< "okay", "" >>>;

main();
