// main.ck
// (electromagnetic-envelopes)

// July 27th, 2017
// Eric Heep

// init

Meepo meep;
Gain g[3];
SinOsc s[3];
ADSR env[3];

1 => int test;

if (test) {
    for (0 => int i; i < 3; i++) {
        s[i] => env[i] => dac;
        s[i].freq(100 * (i + 1));
        s[i].gain(0.5);
    }
} else {
    for (0 => int i; i < 3; i++) {
        adc.chan(i) => g[i] => env[i] => dac.left;
    }
    meep.init();
}


// guts

fun void magnetize(int idx, dur duration) {
    now => time start;

    // random for now, will be pull from a set later on

    Math.random2(5, 6) => int velocity;
    Math.random2(6, 7)::ms => dur milliseconds;

    while (now < start + duration) {
        meep.actuate(idx, velocity);
        milliseconds => now;
    }
}


fun void sequence(int idx, dur startingDuration, dur endingDuration, dur totalDuration) {

    startingDuration => dur currentDuration;
    totalDuration - currentDuration => dur restDuration;

    if (!test) {
        spork ~ magnetize(idx, currentDuration);
    }

    // set envelope

    env[idx].attackTime(currentDuration/2.0);
    env[idx].releaseTime(currentDuration/2.0);

    // play

    env[idx].keyOn;
    currentDuration/2.0 => now;
    env[idx].keyOff;
    currentDuration/2.0 => now;

    // rest

    restDuration => now;
}


fun void main() {
    3::second => dur startingDuration;
    10::second => dur endingDuration;

    for (0 => int i; i < 3; i++) {
        spork ~ sequence(i, startingDuration, endingDuration, 4::minute);
        (endingDuration/startingDuration)::samp => now;
        <<< i >>>;
    }
}

// run

second => now;
<<< "Okay.", "" >>>;

main();
