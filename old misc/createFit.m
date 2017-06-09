function [fitresult, gof] = createFit(X, Y)
%CREATEFIT(ALPHA,LD)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : alpha
%      Y Output: ld
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 10-Feb-2016 14:30:58


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( X, Y );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.999990995553438;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'ld vs. alpha', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel alpha
% ylabel ld
% grid on


