// Utility.ck
// July 26th, 2017
// Eric Heep

/* General utility functions for arrays or whatever */

public class Utility {

    fun void shuffleArray(int arr[]) {
        arr.size() => int currIdx;
        0 => int tempVal;
        0 => int randIdx;

        while (0 != currIdx) {
            Math.random2(0, currIdx - 1) => randIdx;
            currIdx--;

            arr[currIdx] => tempVal;
            arr[randIdx] => arr[currIdx];
            tempVal => arr[randIdx];
        }
    }
}
