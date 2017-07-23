// untitled-1.ck
// July 22nd, 2017
// Eric Heep

adc.left => Gain left => dac.left;
adc.right => Gain right => dac.right;

Meepo meep;
meep.init();

Listener l;

fun void one() {
    while(true) {
        second => now;

        for (int i; i < 20; i++) {
            meep.solenoid(0, 52);
            90::ms => now;
        }
    }
}

fun void two() {
    while(true) {
        second => now;

        for (int i; i < 20; i++) {
            meep.solenoid(1, 51);
            80::ms => now;
        }
    }
}

spork ~ one();
spork ~ two();

day => now;
