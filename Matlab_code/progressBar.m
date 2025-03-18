function progressBar(command, message, currentValue, maxValue, style)
%function progressBar(command, message, currentValue, maxValue, style)
%
% This function displays an ASCII progress bar like the following:
%
% Some text: [...............               ]
%     |      ||              |              |
%  message   ||-currentValue-|              |
%            |                              |
%            |--------- maxValue -----------|
% Run it with the 'init' string as command to initialize the bar
% subsequent calls with 'update' as command will update the status
%
% command (string): 'init': start a new progress bar
%                   'update': updates an existing progress bar
%
% message (string): the message to display (e.g. 'Some text: ')
% currentValue (int): the current value of the bar. as many points as this
%                     value will be displayed.
% maxValue (int): maximum value for the bar. The two square brackets are set
%                 this number of characters apart.
% style (string, optinal): two characters used to display unfilled/filled
%                 points. Defaults to ' .' (space dot).
%                 Nice combinations are ' #', '_#', '*#', '-+'.
%                 
%
%
% Example:
%
%   progressBar('init', 'My progress: ', 0, 10);
%   for i=1:10
%       progressBar('update', 'My progress: ', i, 10);
%       pause(0.5);
%   end
%
% NOTE: producing any other output on the screen while the progressBar is
% displayed will result in incorrect behavior

%
% Author: Francesco Santini
% Version: 1.0.2
% Date: 2007-01-22
%

lineLength = 20;

if (strcmp(command, 'init'))
    tic;
end

fractionComplete = currentValue/maxValue;
elapsedTime = toc;

if (fractionComplete == 0)
    eta = 60*1000;
else
    eta = round(elapsedTime*(1-fractionComplete)/fractionComplete);
end

etaMins = floor(eta/60);
etaSecs = mod(eta, 60);

if (etaMins > 999)
    etaMins = 999;
    etaSecs = 59;
end

currentValue = round(currentValue / maxValue * lineLength);
maxValue = lineLength;

if ~exist('style', 'var')
    style = ' .';
end

if (strcmp(command, 'init'))
    fprintf(message);
end

strToPrint = '[';

for i=1:currentValue
    strToPrint = [strToPrint style(2)];
end
for i=currentValue+1:maxValue
    strToPrint = [strToPrint style(1)];
end
strToPrint = [strToPrint '] ETA: ' sprintf('%3d:%02d', etaMins, etaSecs) '\n'];

if (strcmp(command, 'update'))
    strLen = length(strToPrint)-1; % -1 because \n counts as 2 chars but is deleted by 1 \b
    % prints as many backspaces as the string
    for i=1:strLen
        strToPrint = ['\b' strToPrint];
    end
end
fprintf(strToPrint);