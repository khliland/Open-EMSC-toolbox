 function [ZCorrectedF,ZResidualsF,ZParametersF]=emsc_rep_correction(ZFTIRSel,EMSCModelFinal,SamplesNameStart,SamplesNameEnd,EMSCWeights,plotid)
%emsc_rep_correction [ZCorrectedF,ZResidualsF,ZParametersF]=emsc_rep_correction(ZFTIRSel,SamplesNameStart,SamplesNameEnd,EMSCOption,NComp,EMSCWeights,plotid)
%
%                    'establishes the EMSC model'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                                                        %
%  Center for Biospectroscopy and Data Modelling                                       %
%  Matforsk                                                                            %
%  Norwegian Food Research Institute                                                   %
%  Osloveien 1                                                                         %
%  1430 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  07.03.08                                                                            %
%                                                                                      %
%
%
%  EMSCOption= 1 (full phys EMSC), 2 (baseline + linear), 3  (baseline)                % 
%
%
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      % 
%  status: working                                                                     %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% todo
% write header
% check if ZCorrecteds{i} is needed

[ZCorrectedF,ZResidualsF,ZParametersF]=cal_emsc(ZFTIRSel,EMSCModelFinal,EMSCWeights);

% Calculate the sample group identifier
gSampleGroup=create_group1(ZFTIRSel,SamplesNameStart,SamplesNameEnd);
N=size(gSampleGroup.g.i,1);

if (plotid)
    figure;
    set(gcf,'Color',[1 1 1]);
end
for i=1:N
    % Find replicates for this sample
    ZSelected=select_from_identifier(ZFTIRSel,SamplesNameStart,gSampleGroup.g.i(i,:));
    [nRep,nVar]=size(ZSelected.d);
    [ZCorrected,ZResidualsUncorrected,EMSCParam]=cal_emsc(ZSelected,EMSCModelFinal,EMSCWeights);

    % Compute replicate means and corected residuals
    MeanZCorrected.d=mean(ZCorrected.d,1);
    MeanZCorrected.i='Mean Z corrected';MeanZCorrected.v=ZSelected.v;

    % Residuals to be used for the EMSC subspace model
    ZResidualsCorrected=ZCorrected;
    ZResidualsCorrected.d=ZCorrected.d-ones(nRep,1)*MeanZCorrected.d;
       
    if (plotid)
        PlotReplicates(ZSelected,ZCorrected,MeanZCorrected,...
            ZResidualsCorrected,SamplesNameStart,SamplesNameEnd,EMSCModelFinal,EMSCWeights);
%        pause(0.5)
    end
    
    
    if (0) % plot raw, EMSC phys and EMSC rep cor. spectra
        EMSCOption=1;
        [EMSCModel]=make_emsc_modfunc(ZSelected,EMSCOption);
        [ZCorrectedPhys,ZResidualsPhys,EMSCParamPhys]=cal_emsc(ZSelected,EMSCModel,EMSCWeights);
        
        % Compute replicate means and corected residuals
        MeanZCorrectedPhys.d=mean(ZCorrectedPhys.d,1);
        MeanZCorrectedPhys.i='Mean Z corrected';ZCorrectedPhys.v=ZSelected.v;
    % Plot Raw spec and abs against mean
        figure;
        SampleName=ZSelected.i(1,SamplesNameStart:SamplesNameEnd);
        subplot(231),plot(str2num(ZSelected.v),ZSelected.d'),hold on
        plot(str2num(ZSelected.v),mean(ZSelected.d,1)),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),
        set(gca,'XDir','reverse');
        subplot(234),MeanZ.d=mean(ZSelected.d,1),plot(MeanZ.d',ZSelected.d'),hold on,axis tight,
        xlabel('Absorbance','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M])
        title(SampleName)
        SampleName=ZSelected.i(1,SamplesNameStart:SamplesNameEnd);
        subplot(232),plot(str2num(ZSelected.v),ZCorrectedPhys.d'),hold on
        plot(str2num(ZSelected.v),mean(ZCorrected.d,1),'k:'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),
        set(gca,'XDir','reverse');
        subplot(235),plot(MeanZCorrectedPhys.d',ZCorrectedPhys.d'),hold on,axis tight,
        xlabel('Absorbance','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M],'k:')
        title(SampleName)
        set(gcf,'Color',[1 1 1]);
        subplot(233),plot(str2num(ZSelected.v),ZCorrected.d'),hold on
        plot(str2num(ZSelected.v),mean(ZCorrected.d,1),'k:'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),
        set(gca,'XDir','reverse');
        subplot(236),plot(MeanZCorrected.d',ZCorrected.d'),hold on,axis tight,
        xlabel('Absorbance','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M],'k:')
        title(SampleName)
        set(gcf,'Color',[1 1 1]);
        keyboard;
    end
    
    
    
    
        
end
 
