% function mival = mi_measure(phase_sig, amp_sig)
% % function mival = mi_measure(phase_sig, amp_sig)
% %
% % Returns a value for the MI measure calculated between two signals.
% % (Functionality to deal with multiple trials will be added soon)
% %
% % INPUTS:
% %
% % phase_sig - the instantaneous phase values for a signal which has been
% % filtered for a lower, modulating frequency, passed as a column vector
% %
% % amp_sig - the amplitude values for a signal which has been filtered for a
% % higher, modulated frequency, passed as a column vector 
% %
% % Author: Angela Onslow, May 2010
% 
% num_trials = size(phase_sig, 2);
% 
% for count = 1:num_trials
%     %Create composite signal
%     z = amp_sig(:,count).*exp(1i*phase_sig(:,count));
%     m_raw(count) = mean(z);  %Compute the mean length of composite signal.
% 
%     mival(count,1) = abs((m_raw(count)));
% end
% 
% if num_trials > 1
%     mival = mean(mival);
% end
% end

function MI = mi_measure(phas,ampl,nBins)
%
% function [MI,distKL]=modulationIndex(phas,ampl,nBins)
%
% Computes the Modulation Index (MI), a measure of the amount of
% phase-amplitude coupling between two signals. Phase angles are expected 
% to be in radians. MI is derived from the Kullbach-Leibner distance, which
% is the second, optional, output of the function. The third, optional, 
% input to the function is the number of bins in which to discretize phase 
% (default: 18 bins, giving a 20-degree resolution).
%
% Ref.:
% Tort AB, Komorowski R, Eichenbaum H, Kopell N. Measuring phase-amplitude
% coupling between neuronal oscillations of different frequencies. J
% Neurophysiol. 2010 Aug;104(2):1195-210. doi: 10.1152/jn.00106.2010. Epub
% 2010 May 12. Erratum in: J Neurophysiol. 2010 Oct;104(4):2302. PubMed
% PMID: 20463205; PubMed Central PMCID: PMC2941206.
%
% Example:
%
%   phas=rand(100,1)*2*pi-pi;
%   ampl=randn(100,1)*30+100;
%   [MI,distKL]=modulationIndex(phas,ampl);
%
% pierre.megevand@gmail.com


%% parse inputs
if nargin<2
    error('At least 2 inputs (phase and amplitude) need to be provided.');
end

if ~isvector(phas)||~isvector(ampl)|| ...
        ~isnumeric(phas)||~isnumeric(ampl)|| ...
        length(phas)~=length(ampl)
    error('The phase and amplitude inputs need to be numeric vectors of the same length.');
end

if nargin<3
    nBins=18; % default value
else
    if ~isscalar(nBins)||nBins<=0||rem(nBins,1)~=0
        error('The number of bins must be a natural number above 0.');
    end
end


%% bin the amplitudes according to the phases

binEdges=linspace(-pi,pi,nBins+1);
binCenters=binEdges(1:end-1)-diff(binEdges)/2;

% [phasSort,phasSortIdx]=sort(phas);
% amplSort=ampl(phasSortIdx);
% [n,bin]=histc(phasSort,linspace(-pi,pi,nBins));

[~,binIdx]=histc(phas,binEdges);

amplBin=zeros(1,nBins);
for bin=1:nBins
    if any(binIdx==bin)
        amplBin(bin)=mean(ampl(binIdx==bin));
    end
end

amplP=amplBin/sum(amplBin);

%bar([binCenters binCenters+2*pi],[amplP amplP]);

%% compute Kullback-Leibler distance and modulation index (MI)

amplQ=ones(1,nBins)./nBins;

% amplP=amplQ;
% amplP=[1 zeros(1,nBins-1)];

% in the special case where observed probability in a bin is 0, this tweak
% allows computing a meaningful KL distance nonetheless
if any(amplP==0)
    amplP(amplP==0)=eps;
end

distKL=sum(amplP.*log(amplP./amplQ));

MI=distKL./log(nBins);

end