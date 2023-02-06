function [Yz,Y_est,error] = analyze_data(names, names_GT, pyr2zern, I_0)

RMSE = @(X,Y) sqrt(mean((X-Y).^2,2));


for idx = 1:length(names)
    load(names{idx});
    Y_z = load(names_GT{idx}).Y_z;
    yest = predict_pyr(X_s, I_0, pyr2zern);
    Y_est(:,:,idx) =yest;
    ran = size(Y_est);
    rx = 1:ran(1);
    ry = 1:ran(2);
    Y_z = Y_z*0.1;
    Yz(:,:,idx) = Y_z(rx,ry);
    error(:,idx) = RMSE(yest(rx,ry),Y_z(rx,ry));
end

return

