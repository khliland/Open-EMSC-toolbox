function PlotReplicates(ZSelected,ZCorrected,MeanZCorrected,ZResidualsCorrected,SamplesNameStart,SamplesNameEnd,EMSCModel,EMSCWeights);



[nRep,nVar]=size(ZSelected.d);
clf;

if (0)    % same as below but black-white
        SampleName=ZSelected.i(1,SamplesNameStart:SamplesNameEnd);
        subplot(241),plot(str2num(ZSelected.v),ZSelected.d','k'),hold on
        plot(str2num(ZSelected.v),mean(ZSelected.d),'k:'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),
        set(gca,'XDir','reverse');
        subplot(243),MeanZ.d=mean(ZSelected.d),plot(MeanZ.d',ZSelected.d','k'),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M],'k:')
        title(SampleName)
        ZResiduals.d=ZSelected.d-ones(nRep,1)*MeanZ.d;
        subplot(244),plot(MeanZ.d',ZResiduals.d','k'),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[0,0],'k:')
        subplot(242),plot(str2num(ZSelected.v),ZResiduals.d','k'),axis tight,hold on
        v=axis;m=min(v);M=max(v);,plot([m,M],[0,0],'k:')
        set(gca,'XDir','reverse');
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),

        
        subplot(245),plot(str2num(ZSelected.v),ZCorrected.d','k'),hold on,axis tight,
        set(gca,'XDir','reverse'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),axis tight,
        plot(str2num(MeanZCorrected.v),MeanZCorrected.d,'k:'),set(gca,'XDir','reverse'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M],'k:');
        subplot(247),plot(MeanZCorrected.d',ZCorrected.d','k'),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);M=max(v);,plot([m,M],[m,M],'k:')
        subplot(248),plot(MeanZCorrected.d',ZResidualsCorrected.d','k'),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[0,0],'k:')
        subplot(246),plot(str2num(ZSelected.v),ZResidualsCorrected.d','k'),
        xlabel('Wavenumber [cm^-^1]','FontSize',8),
        ylabel('Absorbance','FontSize',8),axis tight,hold on
        v=axis;m=min(v);M=max(v);,plot([m,M],[0,0],'k:')
        set(gca,'XDir','reverse');
end

if (1) % same as above but with colour
        SampleName=ZSelected.i(1,SamplesNameStart:SamplesNameEnd);
        subplot(241),plot(str2num(ZSelected.v),ZSelected.d'),hold on
        plot(str2num(ZSelected.v),mean(ZSelected.d),'k:'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),
        set(gca,'XDir','reverse');
        subplot(243),MeanZ.d=mean(ZSelected.d),plot(MeanZ.d',ZSelected.d'),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M],'k:')
        title(SampleName)
        ZResiduals.d=ZSelected.d-ones(nRep,1)*MeanZ.d;
        subplot(244),plot(MeanZ.d',ZResiduals.d'),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[0,0],'k:')
        subplot(242),plot(str2num(ZSelected.v),ZResiduals.d'),axis tight,hold on
        v=axis;m=min(v);M=max(v);,plot([m,M],[0,0],'k:')
        set(gca,'XDir','reverse');
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),

        
        subplot(245),plot(str2num(ZSelected.v),ZCorrected.d'),hold on,axis tight,
        set(gca,'XDir','reverse'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),axis tight,
        plot(str2num(MeanZCorrected.v),MeanZCorrected.d),set(gca,'XDir','reverse'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M],'k:');
        subplot(247),plot(MeanZCorrected.d',ZCorrected.d),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);M=max(v);,plot([m,M],[m,M],'k:')
        subplot(248),plot(MeanZCorrected.d',ZResidualsCorrected.d'),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[0,0],'k:')
        subplot(246),plot(str2num(ZSelected.v),ZResidualsCorrected.d'),
        xlabel('Wavenumber [cm^-^1]','FontSize',8),
        ylabel('Absorbance','FontSize',8),axis tight,hold on
        v=axis;m=min(v);M=max(v);,plot([m,M],[0,0],'k:')
        set(gca,'XDir','reverse');
        
        %keyboard;
end




if (0)
    
    % Plot Raw spec and abs against mean
        figure;
        SampleName=ZSelected.i(1,SamplesNameStart:SamplesNameEnd);
        subplot(221),plot(str2num(ZSelected.v),ZSelected.d'),hold on
        plot(str2num(ZSelected.v),mean(ZSelected.d)),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),
        set(gca,'XDir','reverse');
        subplot(223),MeanZ.d=mean(ZSelected.d),plot(MeanZ.d',ZSelected.d'),hold on,axis tight,
        xlabel('Absorbance','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M])
        title(SampleName)
        SampleName=ZSelected.i(1,SamplesNameStart:SamplesNameEnd);
        subplot(222),plot(str2num(ZSelected.v),ZCorrected.d'),hold on
        plot(str2num(ZSelected.v),mean(ZCorrected.d),'k:'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),
        set(gca,'XDir','reverse');
        subplot(224),MeanZ.d=mean(ZSelected.d),plot(MeanZCorrected.d',ZCorrected.d'),hold on,axis tight,
        xlabel('Absorbance','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M],'k:')
        title(SampleName)
        set(gcf,'Color',[1 1 1]);
        keyboard;
end


if (0)
    
    % Plot corrected spectra and abs against mean
        figure;
        SampleName=ZSelected.i(1,SamplesNameStart:SamplesNameEnd);
        subplot(211),plot(str2num(ZSelected.v),ZSelected.d'),hold on
        plot(str2num(ZSelected.v),mean(ZSelected.d),'k:'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),
        set(gca,'XDir','reverse');
        subplot(212),MeanZ.d=mean(ZSelected.d),plot(MeanZ.d',ZSelected.d'),hold on,axis tight,
        xlabel('Absorbance','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M],'k:')
        title(SampleName)
        set(gcf,'Color',[1 1 1]);
end









if (0)
        SampleName=ZSelected.i(1,SamplesNameStart:SamplesNameEnd);
        subplot(141),plot(str2num(ZSelected.v),ZCorrected.d','k'),hold on,axis tight,
        set(gca,'XDir','reverse'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8),axis tight,
        title(SampleName)
        plot(str2num(MeanZCorrected.v),MeanZCorrected.d,'k:'),set(gca,'XDir','reverse'),axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[m,M],'k:');
        subplot(143),plot(MeanZCorrected.d',ZCorrected.d','k'),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);M=max(v);plot([m,M],[m,M],'k:')
        subplot(144),plot(MeanZCorrected.d',ZResidualsCorrected.d','k'),hold on,axis tight,
        xlabel('Wavenumber [cm^-^1]','FontSize',8);ylabel('Absorbance','FontSize',8)
        v=axis;m=min(v);,M=max(v);,plot([m,M],[0,0],'k:')
        subplot(142),plot(str2num(ZSelected.v),ZResidualsCorrected.d','k'),
        xlabel('Wavenumber [cm^-^1]','FontSize',8),
        ylabel('Absorbance','FontSize',8),axis tight,hold on
        v=axis;m=min(v);M=max(v);,plot([m,M],[0,0],'k:')
        set(gca,'XDir','reverse');
end


        if (0)
            subplot(349),plot(EMSCModel.Model),title('ModelSpectra','FontSize',8),axis tight,ylabel('EMSC Model','FontSize',8)
            hold on,
            plot(EMSCWeights.d/max(EMSCWeights.d),'.') %relative weights
        
            % Summarize residuals by svd:
            [V,S,U]=svd(ZResidualsCorrected.d',0);
            A=min(size(S));% of PCs to retain
            S=S(1:A,1:A);
            Loadings=V(:,1:A);  Scores=U(:,1:A);
            ZResPCA.Loadings=Loadings;
            ZResPCA.Scores=Scores;
            ZResPCA.S=S;
            subplot(3,4,10)  ,bar(diag(S));axis tight,title('SVD s','FontSize',8)   
            subplot(3,4,11)  ,plot(Scores*S);axis tight,title('SVD ZResScores','FontSize',8)  ,xlabel('reps','FontSize',8)          
            subplot(3,4,12)  ,plot(Loadings*S);axis tight,title('SVD ZResLoadings','FontSize',8) ,xlabel('variables','FontSize',8)     
        end
        drawnow
        
  %      keyboard
        
        