clc
clear
warning off

filename = 'inputs/CREATeV.vap';
VAP_IN.valMAXTIME = 20
VAP_IN.valSTARTFORCES = 18
seqALPHA = [2:1:12]

OUTP = fcnVAP_MAIN(filename, VAP_IN);
% parfor i = 1:length(seqALPHA)
%     OUTP(i) = fcnVAP_MAIN(filename, VAP_IN);
% end
