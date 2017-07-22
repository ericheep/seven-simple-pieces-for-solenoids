// Listener.ck
// July 22nd, 2017
// Eric Heep


public class Listener extends Chubgraph {

    inlet => Gain g => OnePole p => outlet;
    inlet => g;

    3 => g.op;
    0.0 => float m_dB;


    fun int isBelow(int db) {
        if (db > Std.rmstodb(p.last())) {
            return true;
        }
    }

    fun int isAbove(int db) {
        if (db < Std.rmstodb(p.last())) {
            return true;
        }
    }

    fun int isBetween(int lowDb, int highDb) {
        Std.rmstodb(p.last()) => float currentDb;
        if (currentDb > lowDb && currentDb < highDb) {
            return true;
        }
    }

}
