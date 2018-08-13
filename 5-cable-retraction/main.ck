// main.ck
// (cable-retraction)

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
