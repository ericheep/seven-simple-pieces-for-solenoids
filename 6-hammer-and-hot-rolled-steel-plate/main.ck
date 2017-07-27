// untitled-6.ck
// (hammer-and-hot-rolled-steel-plate)

// July 27th, 2017
// Eric Heep

// init

1 => int test;
40 => int threshold;
0.9 => float pole;
0.1::samp => dur chainDuration;

Meepo meep;
Listener l;
Gain g[3];

if (test) {
    adc => g[0] => dac;
    adc => l => blackhole;
    g[0].gain(0.0);
} else {
    for (0 => int i; i < 3; i++) {
        adc.chan(i) => g[i] => dac.left;
        adc.chan(i) => l;
    }

    meep.init();
}


// guts

fun void chain(int section) {
    for (0 => int i; i < 3; i++) {
        if (test) {
            <<< i, chainDuration/second, "" >>>;
        } else {
            meep.solenoid(i, 50);
        }

        chainDuration => now;
    }

    if (section == 1) {
        chainDuration * 2 => chainDuration;
    }
    else if (section == 2) {
        chainDuration / 2 => chainDuration;
    }
}

fun void main() {
    // section one
    while (chainDuration < 3::second) {
        l.setPole(pole);
        while (l.isBelow(threshold)) {
            1::samp => now;
        }

        <<< l.dB() >>>;
        chainDuration => now;
        chain(1);

        l.setPole(0.0);

        chainDuration * 3 => dur chainTotal;
        if (chainTotal < second) {
            second => now;
        } else {
            chainTotal => now;
        }
    }

    <<< "take a bow", "" >>>;

    // section two
    while (chainDuration > 1::samp) {
        l.setPole(0.0);

        <<< l.dB() >>>;
        chain(2);

        chainDuration/2 => now;

        while (l.isBelow(threshold)) {
            1::samp => now;
        }

        l.setPole(pole);

        chainDuration => dur chainTotal;
        if (chainTotal < second) {
            second => now;
        } else {
            chainTotal => now;
        }
    }

    <<< "good job", "" >>>;
}

// run

second => now;
<<< "Okay.", "" >>>;

main();
