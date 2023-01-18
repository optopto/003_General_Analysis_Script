function [iMat,pyr2zern,I_0] = load_imat(name_f)
load(name_f);
pyr2zern = pinv(iMat);
end