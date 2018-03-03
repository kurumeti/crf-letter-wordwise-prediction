function probability = calculateYjYj_1GivenX(F, B, logZ, T, w, x, word, j)
    wordLength = length(word);
    
    forward = zeros(26,1);
    if j > 1
        for i = 1 : 26
            forward(i) = F(i, j-1) + T(i, word(j));
        end
    end
    
    backwards = zeros(26, 1);
    if j + 1 < wordLength
        for i = 1 : 26
            backwards(i) = B(i, j+2) + T(word(j + 1), i);
        end
    end

    yjyj_1 = dot(w(:,word(j)), x(:,j)) + dot(w(:,word(j + 1)), x(:,j + 1)) + T(word(j), word(j + 1));

    probs = zeros(26,26);

    for k = 1 : 26
        for h = 1 : 26
            probs(h, k) = forward(h) + backwards(k) + yjyj_1 - logZ; 
        end
    end
    if j > 1 && j < wordLength - 1
        probability = sum(sum(exp(probs)));
    elseif j < wordLength
        probability = sum(exp(probs(1,:)));
    else
        probability = sum(exp(probs(:,1)));
    end
end
