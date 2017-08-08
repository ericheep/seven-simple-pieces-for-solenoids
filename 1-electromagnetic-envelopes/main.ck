// main.ck
// (electromagnetic-envelopes)

// July 27th, 2017
// Eric Heep

// init

Meepo meep;
Gain g[3];
SinOsc s[3];
WinFuncEnv env[3];

0 => int test;

if (test) {
    for (0 => int i; i < 3; i++) {
        s[i] => env[i] => dac;
        s[i].freq(400 * (i + 1));
        s[i].gain(0.8);
    }
} else {
    for (0 => int i; i < 3; i++) {
        adc.chan(i) => g[i] => env[i] => dac.left;
    }
    meep.init();
}

// guts

[3, 3, 5, 5] @=> int velocity[];
[3::ms, 4::ms, 3::ms, 4::ms] @=> dur milliseconds[];

int numSettings;
int numEndings;

if (velocity.size() == milliseconds.size()) {
    velocity.size() => numSettings;
} else {
    <<< "fix it", "" >>>;
    me.exit();
}

fun void magnetize(int idx, dur duration) {
    now => time start;
    Math.random2(0, numSettings - 1) => int settingIdx;

    while (now < start + duration) {
        if (!test) {
            meep.actuate(idx, velocity[settingIdx]);
        }

        milliseconds[settingIdx] => now;
    }
}


fun void rise(int idx, float percentActive, dur totalDuration) {
    percentActive * totalDuration => dur windowDuration;
    totalDuration - windowDuration => dur restDuration;
    Math.random2f(0.0, 1.0) * restDuration => dur waitDuration;

    env[idx].attack(windowDuration/2.0);
    env[idx].release(windowDuration/2.0);

    waitDuration => now;

    // actuate

    spork ~ magnetize(idx, windowDuration);

    // attack / release

    env[idx].keyOn();
    windowDuration/2 => now;
    env[idx].keyOff();
    windowDuration/2 => now;

}

fun void go(int idx, dur pieceDuration) {
    now => time start;

    25::second => dur minDuration;
    40::second => dur maxDuration;

    (pieceDuration/(((minDuration + maxDuration)/2.0)))$int => int averageNumRises;

    0.3 => float minPercent;
    1.0 => float maxPercent;

    (maxPercent - minPercent)/averageNumRises => float riseIncrement;

    while (now < start + pieceDuration) {
        Math.random2f(minPercent, Std.clampf(minPercent + 0.2, minPercent, 1.0)) => float risePercent;
        (Math.random2f(0.0, 1.0) * (maxDuration - minDuration)) + minDuration => dur riseDuration;
        rise(idx, risePercent, riseDuration);

        riseIncrement +=> minPercent;

        // just in case

        if (minPercent > 1.0) {
            1.0 => minPercent;
        }
    }

    numEndings++;
}

fun void main() {
    4::minute => dur pieceDuration;

    for (0 => int i; i < 3; i++) {
        spork ~ go(i, pieceDuration);
    }

    now => time start;

    while (numEndings < 3) {
        second => now;
    }
}

// run

second => now;
<<< "okay", "" >>>;

main();
