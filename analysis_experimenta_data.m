%% Experimental Analysis

%%%%%% paths (see the folders and names)
S_F = matlab.desktop.editor.getActiveFilename; % Script Folder =S_F
[filepath_S_F,name,ext_S_F] = fileparts(S_F);
cd(filepath_S_F);
addpath(filepath_S_F);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%      SELECT FOLDER TO ANALYZE         %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

select_folder_dir= uigetdir('C:\','Select Experiment Folder to be Analyzed');

% get the folder contents
d = dir(select_folder_dir);
% remove all files (isdir property is 0)
dfolders = d([d(:).isdir]); 
% remove '.' and '..' 
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  DATA SELECTION USING FOLDER SELECTION  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Select IMat File Path for Pyramid without Diffractive element case
dir_imat_no_diff = [select_folder_dir '\' dfolders(2).name];
file_imat_no_diff_aux1 = dir(dir_imat_no_diff);
file_imat_no_diff_aux1 =file_imat_no_diff_aux1(~ismember({file_imat_no_diff_aux1(:).name},{'.','..'}));
file_imat_no_diff = [dir_imat_no_diff '\' file_imat_no_diff_aux1(1).name];
% CAMBIAR dir_imat_no_diff   POR  file_imat_with_diff 

%% Select IMat File Path for Pyramid with Diffractive element case
dir_imat_with_diff = [select_folder_dir '\' dfolders(3).name];
file_imat_with_diff_aux1 = dir(dir_imat_with_diff);
file_imat_with_diff_aux1 =file_imat_with_diff_aux1(~ismember({file_imat_with_diff_aux1(:).name},{'.','..'}));
file_imat_with_diff = [dir_imat_with_diff '\' file_imat_with_diff_aux1(1).name];
% CAMBIAR dir_imat_with_diff   POR  file_imat_with_diff 

%% Select Experimental Data directory (folder) for Pyramid without Diffractive Element
dir_exp_data_no_diff = [select_folder_dir '\' dfolders(4).name];

%% Select Experimental Data directory (folder) for Pyramid with Diffractive Element
dir_exp_data_with_diff =  [select_folder_dir '\' dfolders(5).name];

%% Ground Truth data directory (folder)

out_seed=regexp(select_folder_dir,'\','split');
os_final_folder = length(char(out_seed(end)));
os_penultimate_folder = length(char(out_seed(end-1)));
num_slach = 2;
disc_char = os_final_folder + os_penultimate_folder + num_slach;
ground_truth_folder_name = '\002_GroundTruth (GT)';

dir_ground_truth_data = [select_folder_dir(1:end-disc_char) ground_truth_folder_name];


%% Summary of data path used for analysis

Prop = ["Experiment name"; "IMat DP file";"IMat DE file";"Exp Data DP path";"Exp Data DE path"];
Description = [out_seed(end); file_imat_no_diff; file_imat_with_diff; dir_exp_data_no_diff; dir_exp_data_with_diff];
Summary = table(Prop,Description);



%% functions and analysis (don't modify)
display('Taking file from directory')
[names0, r0] = get_files(dir_exp_data_no_diff);
[names1, r0] = get_files(dir_exp_data_with_diff);
[names_gt, ~] = get_files(dir_ground_truth_data);

display('Loading Imats')
[iMat0, pyr2zern0, I00] = load_imat(file_imat_no_diff);
[iMat1, pyr2zern1, I01] = load_imat(file_imat_with_diff);

display('Generating results: estimations and errors')
[Ygt,Yp0,err0] = analyze_data(names0,names_gt,-pyr2zern0,I00);
[Ygt,Yp1,err1] = analyze_data(names1,names_gt,-pyr2zern1,I01);

%% display data
x       = 1:size(Ygt,2);   % Zernike range
idx     = floor(rand*(size(Yp0,1)-1)+1); % random sample from the experiment
r_pos   = 11;   % r_0 position (see the r0 value)

%%%%% PLOT %%%%%%%%%%%%
fig = figure(1);
letter_size = 12;
fig.Position =  [148 114 1667 811];
diag_DP =diag(iMat0'*iMat0);diag_DE =diag(iMat1'*iMat1);
tiledlayout(2,3)
nexttile
plot(diag_DP,'LineWidth',2), hold on, plot(diag_DE,'LineWidth',2)
set(gca,'LineWidth',1, 'Fontsize', 16)
xlim([1 length(diag_DP)])
legend('IMat Diagonal DP','IMat Diagonal DE')
hold off

nexttile([2 2]), errorbar(r0*100,mean(err0(:,:)),std(err0(:,:)),'b','LineWidth',2);hold on
errorbar(r0*100,mean(err1(:,:)),std(err1(:,:)),'r','LineWidth',2);
set(gca,'LineWidth',1, 'Fontsize', letter_size)
title(['Error'],'interpreter','latex','FontSize',letter_size);ylabel(['RMSE [rad]'],'interpreter','latex','FontSize',16);xlabel(['$ r_0  [cm] $'],'interpreter','latex','FontSize',letter_size)
legend('DP RMSE', 'DE RMSE')

nexttile, plot(x,Ygt(idx,x,r_pos),'k','LineWidth',2), hold on, plot(x,Yp0(idx,x,r_pos),'b','LineWidth',2), hold on, plot(x,Yp1(idx,x,r_pos),'r','LineWidth',2)
title(['Estimation for $r_0$ ' num2str(r0(r_pos)*100) ' [cm]'],'interpreter','latex','FontSize',letter_size);ylabel(['Amplitude [rad]'],'interpreter','latex','FontSize',letter_size);xlabel(['$\#$ Zernike'],'interpreter','latex','FontSize',letter_size)
legend('GT', 'DP Zernike Estimation','DE Zernike Estimation')
set(gca,'LineWidth',1, 'Fontsize', letter_size)
xlim([1 length(Ygt)])




