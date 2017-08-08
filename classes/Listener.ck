// Listener.ck
// July 22nd, 2017
// Eric Heep


public class Listener extends Chubgraph {

    inlet => Gain g => OnePole p => outlet;
    inlet => g;

    3 => g.op;
    0.9999 => p.pole;

    fun float dB() {
        return Std.rmstodb(p.last());
    }

    fun void setPole(float pl) {
        p.pole(pl);
    }

    fun int isBelow(float db) {
        if (db > Std.rmstodb(p.last())) {
            return true;
        }
    }

    fun int isAbove(float db) {
        if (db < Std.rmstodb(p.last())) {
            return true;
        }
    }

    fun int isBetween(float  lowDb, float  highDb) {
        Std.rmstodb(p.last()) => float currentDb;
        if (currentDb > lowDb && currentDb < highDb) {
            return true;
        }
    }

}
