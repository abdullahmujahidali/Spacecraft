clc,clear,close all
%
% load('Spacecraft.mat')
D = [
1.0000, 2.0000, 3.5000, 5.8000, 7.9000;
0.4000, 0.8000, 1.9000, 3.1000, 4.3000;
1.0000, 3.0000, 4.0000, 7.0000, 9.0000;
1.9000, 3.5000, 4.6000, 7.0000, 8.3000;
1.3000, 2.6000, 4.8000, 5.9000, 7.1000;
1.7000, 1.9000, 2.3000, 2.5000, 2.8000;
2.0000, 4.0000, 6.0000, 8.0000, 9.0000;
1.6000, 3.1000, 4.4000, 5.1000, 5.6000
];
% get number of datasets N
[rows,~] = size(D);
N = rows/2;
%
% extract X = EI and Y = EO
X = D(1:2:end,:); % odd rows -> E1
Y = D(2:2:end,:); % even rows -> E0
%
% set default figure properties
figure,hold on, grid on,xlim([0 12]),ylim([0 10])
title('Efficiency Analysis of Spacecraft Engines')
xlabel('Energy Input (E_I) [MJ]')
ylabel('Kinetic Energy (E_0) [MJ]')
%
% compute for each dataset
for i=1:N
%
% current dataset (pair)
x = X(i,:);
y = Y(i,:);
%
lineFit = polyfit(x,y,1); % get m and c from y = mx + c
grad = lineFit(1); % extract m
%
% compute line of the best fit (yfit)
[fitInfo,~,mu] = polyfit(x,y,1);
yfit = polyval(fitInfo,x,[],mu);
%
% format equation E0 = m E1 for display
eqn = sprintf('E%d_0 = %.3f E%d_I',i,grad,i);
%
% conditional plotting
if grad >= 0.8
plot(x,y,'d r','linewidth',1.5) % data
plot(x,yfit,'- r','linewidth',1.5) % fitted line
dim = [.68 (max(x)-4)/10 .5 .4]; % position varies with x values
annotation('textbox',dim,'String',eqn,'FitBoxToText','on');
elseif grad>=0.5 && grad<0.8
plot(x,y,'o b','linewidth',1.5) % data
plot(x,yfit,': b','linewidth',1.5) % fitted line
dim = [.68 (max(x)-6.4)/10 .5 .4]; % position varies with x values
annotation('textbox',dim,'String',eqn,'FitBoxToText','on');
elseif grad<0.5
plot(x,y,'x k','linewidth',1.5)
end
% strore the gradient values in a column matrix for viewing in case
gradient(i,1) = grad;
end
