%[X, words] = load_set('test.txt', 25953); %train
[X, words] = load_set('test.txt', 26198); 

save('test.mat', 'X', 'words');


% Using the load_set we can store the training data in a .mat matrix file
% which makes it much faster to load the data for testing. For now, it's
% only loading the letters but we can modify it to get vectors indicating
% words, etc.
%data = matfile('train_words_x.mat');
% X = data.X;
% 
% % visualize a letter
% letter_row = 1;
% x1 = reshape(X(letter_row,:), [16, 8]);
% imshow(x1);
% 
% A = importdata('..\\data\\decode_input.txt');