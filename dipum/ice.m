function g = ice(varargin)
%ICE Launch Interactive Color Editor.
%
%   OUT = ICE('Name', 'Value', ...) transforms an
%   image's color components based on interactively specified mapping
%   functions. Inputs are Name-Value pairs:  
%
%     Name            Value
%     ------------    -----------------------------------------------
%     'image'         An RGB or monochrome input image to be
%                     transformed by interactively specified
%                     mappings.
%     'space'         The color space of the components to be
%                     modified. Possible values are 'rgb', 'cmy',
%                     'hsi', 'hsv', 'ntsc' (or 'yiq'), 'ycbcr'. When
%                     omitted, the RGB color space is assumed.
%     'wait'          If 'on' (the default), OUT is the mapped input
%                     image and ICE returns to the calling function
%                     or workspace when closed. If 'off', OUT is the
%                     handle of the mapped input image and ICE
%                     returns immediately. 
%
%   EXAMPLES:
%     ice OR ice('wait', 'off')            % Demo user interface
%     ice('image', f)                      % Map RGB or mono image
%     ice('image', f, 'space', 'hsv')      % Map HSV of RGB image
%     g = ice('image', f)                  % Return mapped image
%     g = ice('image', f, 'wait', 'off');  % Return its handle
%
%   ICE displays one popup menu selectable mapping function at a
%   time. Each image component is mapped by a dedicated curve (e.g.,
%   R, G, or B) and then by an all-component curve (e.g., RGB). Each
%   curve's control points are depicted as circles that can be moved,
%   added, or deleted with a two- or three-button mouse:
%
%     Mouse Button    Editing Operation
%     ------------    -----------------------------------------------
%     Left            Move control point by pressing and dragging.
%     Middle          Add and position a control point by pressing
%                     and dragging. (Optionally Shift-Left)
%     Right           Delete a control point. (Optionally
%                     Control-Left) 
%
%   Checkboxes determine how mapping functions are computed, whether
%   the input image and reference pseudo- and full-color bars are
%   mapped, and the displayed reference curve information (e.g.,
%   PDF):
%
%     Checkbox        Function
%     ------------    -----------------------------------------------
%     Smooth          Checked for cubic spline (smooth curve)
%                     interpolation. If unchecked, piecewise linear.
%     Clamp Ends      Checked to force the starting and ending curve
%                     slopes in cubic spline interpolation to 0. No
%                     effect on piecewise linear.
%     Show PDF        Display probability density function(s) [i.e.,
%                     histogram(s)] of the image components affected
%                     by the mapping function.
%     Show CDF        Display cumulative distributions function(s)
%                     instead of PDFs.
%                     <Note: Show PDF/CDF are mutually exclusive.>
%     Map Image       If checked, image mapping is enabled; else
%                     not. 
%     Map Bars        If checked, pseudo- and full-color bar mapping
%                     is enabled; else display the unmapped bars (a
%                     gray wedge and hue wedge, respectively).
%
%   Mapping functions can be initialized via pushbuttons:
%
%     Button          Function
%     ------------    -----------------------------------------------
%     Reset           Init the currently displayed mapping function
%                     and uncheck all curve parameters.
%     Reset All       Initialize all mapping functions.
%
%   Copyright 2002-2020 Gatesmark
%
%   This function, and other functions in the DIPUM Toolbox, are based 
%   on the theoretical and practical foundations established in the 
%   book Digital Image Processing Using MATLAB, 3rd ed., Gatesmark 
%   Press, 2020.
%
%   Book website: http://www.imageprocessingplace.com
%   License: https://github.com/dipum/dipum-toolbox/blob/master/LICENSE.txt

parser = inputParser;
addParameter(parser,'image',imread('peppers.png'));
addParameter(parser,'space','rgb');
addParameter(parser,'wait','on');
parse(parser,varargin{:});

app = iceControlPanel(parser.Results.image,parser.Results.space);
output_fig = app.OutputImageFigure;

if strcmp(parser.Results.wait,'on')
   uiwait(app.Figure);
   im_handle = findobj(output_fig,'type','image');
   g = im_handle.CData;
else
   g = app.OutputImageFigure;
end