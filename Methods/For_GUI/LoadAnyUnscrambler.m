function [ZSaisir, filenameEval] = LoadAnyUnscrambler()

[filename, pathname, index] = uigetfile( ...
    {'*.mat;*.MAT','Unscrambler export for MATLAB (*.mat)';
    '*.*',  'All Files (*.*)'},...
    'Select MATLAB spectra to analyse');%, ...
%     '','MultiSelect', 'off');
k = strfind(filename,'.');
if (k>1)
    filenameEval = filename(1:(k-1));
end

if index == 1 %~isnumeric(pathname)
    NameSaisir = strcat(pathname,filename);
    % load the matlab file saved by Unscrambler and put it to the saisir
    % structure
    load(NameSaisir);
    ZSaisir = [];
    
    % Check Unscrambler version
    if exist('SamplesName','var')
        ObjLabels = SamplesName;
        Matrix    = DataMatrix;
        TempName  = VariableName;
        
    else % 10.01+
        if exist('VarLabels0','var')
            Matrix   = eval(filenameEval);
            TempName = VarLabels0;
            
        else % 9.6
            TempName = VarLabels;
        end
    end
    
    ZSaisir.i = num2str(ObjLabels);
    TempName(TempName==0) = ' ';
    ZSaisir.v = TempName;
    ZSaisir.d = Matrix;
else
    ZSaisir = [];
    filenameEval = [];
end
