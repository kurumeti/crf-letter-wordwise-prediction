% Nice explanation of log trick for p(Y|X)
% https://stats.stackexchange.com/questions/105602/example-of-how-the-log-sum-exp-trick-works-in-naive-bayes
global WORD_LENGTH LETTER_SIZE NUM_LETTERS ALPHABET;

WORD_LENGTH = 100;
LETTER_SIZE = 128;
NUM_LETTERS = 26;
ALPHABET = 'abcdefghijklmnopqrstuvwxyz';

% loading this values only to use X for test. I believe we have
% to report with respect of data/train
[x, junk1, junk2] = loadDecoderSet(strcat(pwd,'/code/2/decode_input.txt')); 

% Load weights and transition from the given model for 2(a)
[w, T] = loadModel(strcat(pwd,'/code/2/model.txt'));

data = matfile(strcat(pwd,'/code/2/train_x.mat'));
X = data.X;

word = [18 11 22 17 19];
x_5 = x(:, 1:5);

% calculate Z
[F, B, logz] = logMemo(x_5, w, T);

% F, B, logZ, xj, wDotX, T, j, yj


p = zeros(5,1);
for i = 1 : 5
    p(i) = calculateYjGivenX(F, B, logz, dot(x(:,i), w(:,word(i))), T, i, word(i), length(word));
end


% calculateYjYj_1GivenX(F, B, logZ, T, w, x, word, j)
p2 = zeros(4, 1);
for i = 1 : 4
    p2(i) = calculateYjYj_1GivenX(F, B, logz, T, w, x, word, i);
end
p2

% grad(log p (y|X)) = sum(([[ys = y]] - p(ys = y|X)) * xs)

