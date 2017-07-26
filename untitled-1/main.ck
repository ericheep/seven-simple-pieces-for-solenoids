// main.ck
// (obligatory-phase)

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
    adc.chan(0) => g[0] => dac.left;
    adc.chan(1) => g[1] => dac.left;
    adc.chan(2) => g[2] => dac.left;

    meep.init();
}

// guts

fun void phase(int numNotes, dur totalDuration, dur cycle) {
    (totalDuration/cycle) $ int => int numCycles;

    if (totalDuration/cycle != numCycles) {
        numCycles * cycle => totalDuration;
        <<< "total time is not divisible by the cycle time, calculating a new total of", totalDuration/minute, "minutes" >>>;
    }

    if (numNotes > numCycles) {
        <<< "your total time is too short or your number of notes is too large", "" >>>;
        me.exit();
    }

    for (int i; i < numNotes; i++) {
        spork ~ phaseLoop( i, numCycles, totalDuration);
        0.5::ms => now;
    }

    totalDuration => now;
    1::second => now;
}

fun void phaseLoop(int idx, int numCycles, dur totalDuration) {
    totalDuration/(numCycles - idx) => dur cycleDuration;
    for (int i; i < numCycles - idx; i++) {
        if (test) {
            <<< idx, "" >>>;
        } else {
            meep.actuate(idx , 50);
        }
        cycleDuration => now;
    }
}


fun void main() {
    phase(3, 2::minute, 1.0::second);
}

// run

second => now;
<<< "okay", "" >>>;

main();
