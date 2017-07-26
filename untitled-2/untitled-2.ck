// untitled-2.ck
// (electromagnetic-envelopes)

// July 27th, 2017
// Eric Heep

// init

Meepo meep;
Gain g[3];
WinFuncEnv env[3];

if (test) {
    adc => g[0] => env[0] dac;
    g[0].gain(0.0);
} else {
    adc.chan(0) => g[0] => env[0] => dac.left;
    adc.chan(1) => g[1] => env[0] => dac.left;
    adc.chan(2) => g[2] => env[0] => dac.left;

    meep.init();
}


// guts

fun void main() {
}

// run

second => now;
<<< "Okay.", "" >>>;

main();
