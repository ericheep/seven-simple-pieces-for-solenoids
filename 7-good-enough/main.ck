// main.ck
// (good-enough)

// August 8th, 2017
// Eric Heep

// init

Meepo meep;
meep.init();

// guts

fun void triplets() {
    0.24::second => dur triplet;
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
