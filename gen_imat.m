function [imat,p2z] = gen_imat(sp,sm,r1,r2,pup)
pup = pup(:);
for idx = 1:size(sp,2)
    tam = [616, 808];
    var_sp = reshape(sp(:,idx),tam);
    var_sp = var_sp(r1,r2);
    var_sm = reshape(sm(:,idx),tam);
    var_sm = var_sm(r1,r2);
    sp2(:,idx) = var_sp(pup)/sum(var_sp(pup));
    sm2(:,idx) = var_sm(pup)/sum(var_sm(pup));
end
    imat = 0.5*(sm2-sp2)/0.1;
    p2z = pinv(imat);
end