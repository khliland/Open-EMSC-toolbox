%function subback
%
%This function will subtract the background of a spectrum in a iterative
%way. It will fit a polynom through the datapoints and those points ether
%of the fitted polynome or those of the spectrum below the fitted spectrum
%will be used for the following iteration. In this way, with higher
%iterations, one obtains a better prediction of the background.
%
%Syntax:
%    NewSpectra = subbackmod (Spectra, xaxis, order, threshhold, doplot)
%    NewSpectra = subbackmod (Spectra, xaxis)
%
%With:
%    Spectra: datamatrix with the spectra in rows
%    xaxis: the corresponding x-axis
%    order: order of the polynomial for fitting the background, default = 5
%    threshhold: stop criterium for the percentual difference between the
%        standarddeviations of two succesive iterations (stddev of the
%        progressing residuals of the background), default = 0.01
%    doplot: boolean, flag to indicate whether the spectrum, its bakground
%        and the background subtracted spectrum need to be plot at the end
%
%Literature:
%    1) Zhao J, Lui H, McLean DI, Zeng H Automated autofluorescence
%    background subtraction algorithm for biomedical Raman spectroscopy,
%    Applied spectroscopy, 61 (2007) 1225-1232
%    2) Lieber CA, Mahadevan-Jansen A, Automated method for subtraction of
%    fluorescence from biological Raman spectra, Applied spectroscopy, 57
%    (2003) 11, 1363-1367
%
%Example:
%    load data
%    xaxis = 1:size(data,2);
%    subplot (2,1,1);
%    plot (xaxis, data);
%    title ('Original dataset');
%    subplot (2, 1, 2);
%    plot (xaxis, subbackmod (data, xaxis));
%    title ('Background subtracted');

%The Biodata toolbox for MATLAB: a spectral database system for storing and
%processing spectra
%C 2008, Kris De Gussem, Raman Spectroscopy Research Group, Department
%of analytical chemistry, Ghent University
%C 2009 Kris De Gussem
%
%This file is part of Biodata.
%
%Biodata is free software: you can redistribute it and/or modify
%it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or
%(at your option) any later version.
%
%Biodata is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with Biodata.  If not, see <http://www.gnu.org/licenses/>.

%Copyright (c) 2008-2009, Kris De Gussem
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without 
%modification, are permitted provided that the following conditions are 
%met:
%
%    * Redistributions of source code must retain the above copyright 
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in 
%      the documentation and/or other materials provided with the distribution
%    * Neither the name of Raman Spectroscopy Research Group, Department of
%	  analytical chemistry, Ghent University nor the names 
%      of its contributors may be used to endorse or promote products derived 
%      from this software without specific prior written permission.
%      
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%POSSIBILITY OF SUCH DAMAGE.

function [NewSpectra, param] = subbackmod (Spectra, xaxis, order, threshhold, doplot)
switch nargin
    case 2
        doplot = 0;
        order = 5;
        threshhold = 0.01;
    case 5
    otherwise
        error ('Biodata:msg', 'Wrong number of input parameters...');
end

[m,n] = size(Spectra);
NewSpectra = zeros(m,n);
warning off MATLAB:polyfit:RepeatedPointsOrRescale

h_importspec = waitbar(0,'Subtracting background...');
for nr = 1:m %do all spectra in matrix
    waitbar(nr/m, h_importspec);

    ThisSpectrum = Spectra(nr,:);
    ThisXaxis = xaxis;
    if all(ThisSpectrum==0)
        warndlg('You tried to subtract the background of a null vector! Please have a detailed look on your data.', 'Background subtraction')
        warning('Biodata:msg', 'You tried to subtract the background of a null vector! Please have a detailed look on your data.');
        NewSpectra(nr,:) = Spectra(nr,:);
    else
        P = polyfit(ThisXaxis,ThisSpectrum,order);
        Po = polyval (P, ThisXaxis);
        Re = ThisSpectrum - Po;
        indRe=1:length(Re);
        Re2 = Re(1,indRe)-Re(1,circshift(indRe,[0 1]));
        Re2(1) = [];
        DEV = std (Re2, 1, 2);
        %DEV = std (Re, 1, 2);
        mySUM = Po+DEV;
        ind = find (ThisSpectrum > mySUM);
        ThisSpectrum(ind) = []; %the ordinary (1,ind) would break the routine in matlab 7.5
        ThisXaxis(ind) = [];
        i = 1;
        prevDEV = DEV;
        while(1)
            i = i+1; %just to count the number of iterations
            P = polyfit(ThisXaxis,ThisSpectrum,order);
            Po = polyval (P, ThisXaxis);
            Re = ThisSpectrum - Po;
            indRe=1:length(Re);
            Re2 = Re(1,indRe)-Re(1,circshift(indRe,[0 1]));
            Re2(1) = [];
            DEV = std (Re2, 1, 2);
            %DEV = std (Re, 1, 2);
            mySUM = Po+DEV;
            ind = find (ThisSpectrum > mySUM);
            % tmpspec=ThisSpectrum;
            ThisSpectrum(1,ind) = mySUM(1,ind);
            if abs((DEV-prevDEV)/DEV) < threshhold
                break;
            end
            prevDEV = DEV;
            tmpDEV(i) = DEV; %#ok<AGROW,NASGU>
            if i>500
                warning ('Biodata:msg', 'Maximum iteration limit of 500 reached. Will stop background subtraction...')
                break;
            end
        end
        NewSpectra(nr,:) = Spectra(nr,:)-polyval (P, xaxis);

        if doplot
            %plot the two spectra
            figure('name', 'Result of background subtraction');
            plot (xaxis, Spectra(nr,:), 'b',xaxis, Spectra(nr,:)-NewSpectra(nr,:), 'r');
            h = title ([ 'Spectrum ' num2str(nr) ]);
            set(h, 'Fontweight', 'bold');
            set(h, 'Fontsize', 16);
            legend('Original spectrum', 'Fitted background');
            figure('name', 'Result: background-subtracted spectrum');

            %plot the final spectrum as wel
            plot (xaxis, NewSpectra(nr,:));
            h = title ([ 'Spectrum ' num2str(nr) ]);
            set(h, 'Fontweight', 'bold');
            set(h, 'Fontsize', 16);

            figure ('name', 'Result: standarddevation of progressing residuals in the background');
            plot (2:length(tmpDEV), tmpDEV(2:length(tmpDEV)));
            h = title ([ 'Spectrum ' num2str(nr) ' (std progressing residuals)' ]);
            set(h, 'Fontweight', 'bold');
            set(h, 'Fontsize', 16);
        end
    end
end
close(h_importspec);
warning on MATLAB:polyfit:RepeatedPointsOrRescale

param.order = order;
param.threshhold = threshhold;
param.doplot = doplot;