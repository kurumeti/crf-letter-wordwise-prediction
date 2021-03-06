function [probs] = calc_probYjYj_1_X(Fjminus1, Bjplus2, B, featureF, featureB, logZ, T, featureT1, featureT2, dotWX, TW, wj, wj_1, j, wordLength, alphabet_size)


    scals = dotWX + TW - logZ;
    
    if j > 1 && j < wordLength - 1
        % exp(F(h, j-1) + T(h, wj) + B(k, j+2) + T(wj_1, k) + w(:,wj)'* x(:,j) + w(:,wj_1)'*x(:,j + 1) + T(wj, wj_1) - logZ);
        %featF  =  featureF(:,j-1);
        %featT1   =  featureT1(:, wj);
        %featB = featureB(:,j+2);
        
%         sel_T2 = T(wj_1,:);
%         sel_T2 = repmat(sel_T2, [alphabet_size, 1]);
%         featT2 = reshape(sel_T2, alphabet_size ^ 2, 1);
        % in reality is T(wj_1,:)' but i transposed featT2 to avoid '
        featT2 = featureT2(:,wj_1);
               
        %f = featF + featureT1 + featB + featT2 + scals;
        f = Fjminus1 + featureT1 + Bjplus2 + featT2 + scals;
        probs = sum(exp(f));
        
    elseif j == 1
        % probs = probs + exp(B(k, j+2) + T(wj_1, k) + w(:,wj)'*x(:,j) + w(:,wj_1)'*x(:,j + 1) + T(wj, wj_1) - vlogZ(1:26));
        %featB = featureB(1:26,j+2);
        featB = B(:,j+2); % reverted case here because a i want a sequence 'abc' not 'aaa..bbb.. as un first if
        featT = T(wj_1,:)';
        %featT = featureT2(wj_1,:)';
        
        f = featB + featT + scals;
        probs = sum(exp(f));
    else
        % probs = probs + exp(F(h, j-1) + T(h, wj) + w(:,wj)'*x(:,j) + w(:,wj_1)'*x(:,j + 1) + T(wj, wj_1) - vlogZ(1:26));
        featF = featureF(1:26,j-1);
        featT = featureT1(1:26);
        
        f = featF + featT + scals;
        probs = sum(exp(f));
    end
end

