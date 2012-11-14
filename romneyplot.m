%% Plot the number of "likes" on Mitt Romney's facebook page vs time

% Load the data file.  The columns are the unix time (seconds since
% 1/1/1970) and the number of likes.

data = dlmread('romneycount.txt');

% Now convert the time to Matlab's time, which is in number of days since
% some fictional epoch.

% Get a test case using Unix 'date' command:
% > date +"%s = %D %T %Z" 
% 1352910597 = 11/14/12 11:29:57 EST

UTC_offset = -5;
unix2datenum = @(unix_time) ...
  unix_time/86400 + datenum('1970-01-01 00:00:00') + UTC_offset/24;

% test case for date conversion:
assert(strcmp(datestr(unix2datenum(1352910597)), '14-Nov-2012 11:29:57'));

t = unix2datenum(data(:,1));
y = data(:,2);


% Draw some shaded background to indicate the time of day.  Here I convert
% the time of day into phase (in radians), and then apply the sine function
% to get something like "brightness of daylight".

t2 = t(1):0.1:t(end);
v = datevec(t2);
c = v(:,4) + (v(:,5) + v(:,6)/60)/60;     % time of day in fractional hours
c = 2 + sin(c * (2*pi)/24 - pi/2 - pi/6); % offset so that it's not too dark

lims = [min(y) 12050500];
p = pcolor([t2; t2], [lims(1)*ones(size(t2)) ; lims(2)*ones(size(t2))], [c' ; c']);
caxis([0 2]); 
colormap(gray);
set(p,'facecolor','flat', 'linestyle', 'none');        


hold all
t3 = t(1):0.01:t(end);
% first plot a thick white line:
plot(t3, interp1(t, y, t3, 'pchip'), 'linewidth', 10, 'color', [1 1 1]);
% then a less-thick red line:
plot(t3, interp1(t, y, t3, 'pchip'), 'linewidth', 5, 'color', [0.9 0 0]);
hold off

set(gca,'layer','top');   
datetick('x', 'mm/dd HH:MM');
xlabel('Eastern Standard Time');
ylabel('Facebook "likes"');
title('The de-friending of Mitt Romney');
axis tight

% tick_interval = 5000;
% ticks =  tick_interval*(ceil(lims(1)/tick_interval):1:floor(lims(2)/tick_interval));
% set(gca,'ytick', ticks);

% Instead of setting the tick marks automatically, I do it by hand as a
% quick-and-dirty way to put in spaces as thousands separators:

set(gca, 'ytick', [12020000, 12025000, 12030000, 12035000, 12040000, 12045000 12050000], ...
    'yticklabel', {'12 020 000', '12 025 000', '12 030 000', '12 035 000', '12 040 000', '12 045 000', '12 050 000'});
ylim([min(y) 12050500]);  
set(gca, 'FontSize', 14)
set(findall(gca, 'Type','text'), 'FontSize', 16)

print -dpdf romneycount.pdf
print -dpng romneycount.png