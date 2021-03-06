function load(url) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url);
    xhr.send();

    return new Promise((res, err) => {
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    res(xhr.responseText);
                }
                else {
                    err(xhr);
                }
            }
        }
    });
}

const ALPHABET = 'abcdefghijklmnopqrstuvwxyz'.split('');
const NUM_LETTERS = ALPHABET.length;

const LETTER_SIZE = 128;
const WORD_LENGTH = 100;

// return the dot production between x_j and w_yi
// where j is the index of the character in the word
// and yi is the alphabetic letter to compare it to
function xDotW(x, j, w, yi) {
    let sum = 0;
    for (let i = 0; i < LETTER_SIZE; ++i) {
        sum += x[j * LETTER_SIZE + i] * w[yi * LETTER_SIZE + i];
    }
    return sum;
}

// return the transition value between alphabetic characters
// denoted by m and n
function T(t, m, n) {
    return t[n * NUM_LETTERS + m];
}

function decode_input(x, w, t) {

    // both of these will be length 26 (num letters)
    let memo = [];

    // get initial probabilities of the first character
    // for all letters { a...z }
    for (let i = 0; i < NUM_LETTERS; ++i) {
        memo[i] = {
            p: xDotW(x, 0, w, i),
            subword: ALPHABET[i]
        };
    }

    // for each of the next 99 characters...
    for (let j = 1; j < WORD_LENGTH; ++j) {
        let nextMemo = [];
        // for each alphabetic letter { a...z }
        // check which memoized subword + this letter has the best potential
        for (let i = 0; i < NUM_LETTERS; ++i) {
            let max_potential = -1000;
            let max_potential_k = -1;
            for (let k = 0; k < NUM_LETTERS; ++k) {
                let potential = T(t, k, i) + memo[k].p;
                if (potential > max_potential) {
                    max_potential = potential;
                    max_potential_k = k;
                }
            }
            nextMemo[i] = {
                p: xDotW(x, j, w, i) + max_potential,
                subword: memo[max_potential_k].subword + ALPHABET[i]
            };
        }

        // copy nextMemo onto memo
        for (let i = 0; i < NUM_LETTERS; ++i) {
            memo[i] = nextMemo[i];
        }
    }

    // maximize the very last subword
    memo.sort((a, b) => b.p - a.p);
    console.log(memo[0].subword, memo[0].p);
}

function bruteforce_input(x, w, t) {
    const LIMIT = 4; // WORD_LENGTH; // this takes a really fricking long time

    let max_p = -1000;
    let max_word;

    function recurse(word, p, depth) {
        if (depth < LIMIT) {
            for (let i = 0; i < NUM_LETTERS; ++i) {
                word[depth] = i;
                let potential = xDotW(x, depth, w, i) + T(t, word[depth - 1], i);
                recurse(word, p + potential, depth + 1);
            }
        }
        else {
            if (p > max_p) {
                max_p = p;
                max_word = word.slice(); // deep clone the array (since original gets mutated recursively)
            }
        }
    }

    for (let i = 0; i < NUM_LETTERS; ++i) {
        recurse([i], xDotW(x, 0, w, i), 1);
    }

    // this is indexed by 0 --> output should index by 1
    console.log(max_word.map(x => ALPHABET[x]).join(''), max_p);
}


load('decode_input.txt').then((text) => {
    let input = text.split('\n').map(x => +x);

    let x = input.slice(0, WORD_LENGTH * LETTER_SIZE);

    let w = input.slice(WORD_LENGTH * LETTER_SIZE, (WORD_LENGTH + NUM_LETTERS) * LETTER_SIZE);
    let t = input.slice((WORD_LENGTH + NUM_LETTERS) * LETTER_SIZE);

    decode_input(x, w, t);

    bruteforce_input(x, w, t);
});