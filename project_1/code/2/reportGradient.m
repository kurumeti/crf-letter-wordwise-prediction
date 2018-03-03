% grad_w(log p (y|X)) = sum(([[ys = y]] - p(ys = y|X)) * xs)

global NUM_LETTERS LETTER_SIZE;

LETTER_SIZE = 128;
NUM_LETTERS = 26;

%data = matfile(strcat(pwd,'\code\2\train_words_x.mat'));
data = matfile(strcat(pwd,'/code/2/train_words_x.mat'));
words = data.words;
[w, T] = loadModel(strcat(pwd,'/code/2/model.txt'));
%[w, T] = loadModel(strcat(pwd,'\code\2\model.txt'));

num_words = size(words, 2);
sum_logs = 0;


wGrads = zeros(LETTER_SIZE, 26);

for index = 1 : num_words

    word = words{index};
    x = word.image;
    y = word.letter_number;

    [F, B, logz] = logMemo(x, w, T);
    wordLength = length(y);

    for s = 1 : wordLength

        for letter = 1 : 26
            indicator = y(s) == letter;

            p = calculateYjGivenX(F, B, logz, dot(x(:,s), w(:,letter)), T, s, letter, wordLength);

            wGrads(:, letter) = wGrads(:, letter) + (indicator - p) * x(:, s);
        end
    end

end

% tGrads = zeros(26, 26);
% 

save('wGrads.mat', 'wGrads');