// main.ck
// (good-enough)

// August 8th, 2017
// Eric Heep

// init

Meepo meep;
meep.init();

Gain g[3];

adc => g[0] => dac.left;
adc => g[1] => dac;
adc => g[2] => dac.right;

g[1].gain(0.8);

// guts

fun void triplets() {
    0.25::second => dur triplet;
    10 => int small;
    20 => int big;
    while (true) {
        meep.actuate(0, small);
        triplet => now;
        meep.actuate(1, small);
        triplet => now;
        meep.actuate(2, small);
        triplet => now;
        meep.actuate(2, big);
        triplet => now;
        meep.actuate(1, small);
        triplet => now;
        meep.actuate(1, small);
        triplet => now;
    }
}

fun void main() {
    triplets();
}

// run

second => now;
<<< "okay", "" >>>;

main();
