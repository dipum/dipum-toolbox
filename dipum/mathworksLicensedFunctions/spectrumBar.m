function cb_out = spectrumBar(ax)
%spectrumBar Add visible light spectrum bar to plot.
%    spectrumBar adds a visible light spectrum bar to a line plot whose
%    x-values are wavelengths in nm. The spectrum bar covers wavelengths
%    from 380 nm to 780 nm. The spectrum bar will show black for
%    portions of the x-axis extending beyond these limits. Call
%    spectrumBar after making any desired adjustments to the x-axis
%    limits, ticks, and label, because spectrumBar will move those ticks
%    and label underneath the spectrum bar. If spectrumBar is called
%    twice on the same plot, it deletes the existing bar and places a
%    new one.
%
%    spectrumBar(ax) places the bar in the specified axes.
%
%    p = spectrumBar(___) returns the patch object used for displaying
%    the bar.

%   Written by Steve Eddins to accompany Digital Image Processing Using
%   MATLAB, 3rd edition, Gatesmark Press, 2020,
%   http://imageprocessingplace.com.
%
%   Copyright 2019 The MathWorks, Inc.
%   License: https://github.com/mathworks/matlab-color-tools/blob/master/license.txt

if nargin < 1
   ax = gca;
end

% Delete any existing spectrum bars.
delete(findobj(ax,'Tag',"SpectrumBar"));

x_limits = xlim(ax);

[rgb,lambda] = spectrumColors;

ncolors = 200;
x = linspace(x_limits(1),x_limits(2),ncolors);
colors = interp1(lambda,rgb,x,'pchip',0);

ax.Colormap = colors;
ax.CLim = x_limits;

cb = colorbar(ax,'Location','southoutside','Ticks',[],...
   'LineWidth',0.1,'Color',"black",...
   'Tag',"SpectrumBar");

cb.Ticks = ax.XTick;
cb.Label.String = ax.XLabel.String;
cb.TickDirection = "out";

ax.XTickLabels = [];
ax.XLabel = [];

if nargout > 0
   cb_out = cb;
end
