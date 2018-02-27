function [ X ] = load_set( file, no_letters )
%LOAD_SET Load the letters dataset into a X matrix with dimensions
%   no_letters x 128. The number of rows in the file can be obtained by
%   reading the file and counting rows but if we know it a priori, we do
%   not need to calculate it.
%   Each row in the datasets has the following structure:
%   1st elem: row number
%   2nd elem: letter character
%   3rd elem: letter 'sequence' in word. -1 indicates where a new word
%             starts and the following rows have consecutive number per
%             letter. However, that's not the case for the first word, so
%             it's kind of useless and confusing.
%   4th elem: Word index, all letters with the same number (always
%             consecutive), belong to the same word.
%   5th elem: Letter order inside a word.
%   6th - 128th: Sequence of zeros and ones that make the letter
% 129th:      I have no idea.

clc
fid = fopen(file);
X = zeros(no_letters, 128);
i_x = 1;

while ~feof(fid) % not end of the file 
    s = fgetl(fid); % get a line
    j=6; x=zeros(1,128);
    
    line = strsplit(s);
    i = 1;
    while j <= length(line) - 1     %idk what's the use of the last element
        x(i) = str2num(line{j});
        j = j + 1;
        i = i + 1;
    end
    X(i_x,:) = x;
    i_x = i_x + 1;
end

end
