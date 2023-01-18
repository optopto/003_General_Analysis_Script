function [y] = predict_pyr(X,I_0,p2z)
I_0 = I_0(:)/sum(I_0(:));
len = min(size(p2z));
y = zeros(size(X,3),len);
for idx = 1:size(X,3)
    X2 = X(:,:,idx);
    X2 = X2(:)/sum(X2(:));
    x =  X2-I_0;
    y(idx,:) = p2z*x;
end
end