// tester.ck
// July 22nd, 2017
// Eric Heep

adc.left => Gain left => dac.left;
adc.right => Gain right => dac.right;

Meepo meep;
meep.init();

Listener l;

Hid hi;
HidMsg msg;

// which keyboard
0 => int device;
if( !hi.openKeyboard( device ) )me.exit();

1 => int sol;

5 => int millisecond;
5 => int velocity;

fun void status() {
    <<< "Millisecond:\t", millisecond, "\tVelocity:\t", velocity >>>;
}

fun void keyboardControl() {
    while (true) {
        hi => now;
        while (hi.recv(msg)) {
            // 65 ms up,  83 ms down, 68 vel up,  70 vel down
            if (msg.isButtonDown()) {
                <<< msg.ascii, "" >>>;
                if (msg.ascii == 65) {
                    if (millisecond > 1) {
                        1 -=> millisecond;
                    }
                    status();
                }
                if (msg.ascii == 83) {
                    1 +=> millisecond;
                    status();
                }
                if (msg.ascii == 68) {
                    if (millisecond > 0) {
                        1 -=> velocity;
                    }
                    status();
                }
                if (msg.ascii == 70) {
                    1 +=> velocity;
                    status();
                }
            }
        }
    }
}

spork ~ keyboardControl();

while (true) {
    meep.solenoid(sol, velocity);
    millisecond::ms => now;
}

day => now;
