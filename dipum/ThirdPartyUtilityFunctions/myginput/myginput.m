function [out1,out2,out3] = myginput(arg1,strpointertype)
%MYGINPUT Graphical input from mouse with custum cursor pointer.
%   [X,Y] = MYGINPUT(N) gets N points from the current axes and returns 
%   the X- and Y-coordinates in length N vectors X and Y.
%
%   [X,Y] = MYGINPUT(N, POINTER) also specifies the cursor pointer, e.g.
%   'crosshair', 'arrow', 'circle' etc. See "Specifying the Figure Pointer"
%   in Matlab's documentation  to see the list of available pointers.
%   
%   MYGINPUT is strictly equivalent to Matlab's original GINPUT, except
%   that a second argument specifies the cursor pointer instead of the
%   default 'fullcrosshair' pointer.
%
%   Example:
%     plot(1:2,1:2,'s');
%     hold on
%     [x,y] = myginput(1,'crosshair');
%     plot(x,y,'o');
%     hold off
%
%   MYGINPUT is copied from Matlab's GINPUT rev. 5.32.4.4.
%
%   See also GINPUT.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.02,  Date: 2006/10/24

% History:
% 2005/10/31: v1.00, first version, from GINPUT rev. 5.32.4.4.
% 2005/11/25: v1.01, line 'uisuspend' modified (for compatibility with
%                    ML7.00)
% 2006/10/24: v1.02, help text improved

out1 = []; out2 = []; out3 = []; y = [];

if nargin<1     % modified MYGINPUT
    strpointertype='crosshair'; % default GINPUT pointer
end

c = computer;
if ~strcmp(c(1:2),'PC') 
   tp = get(0,'TerminalProtocol');
else
   tp = 'micro';
end

if ~strcmp(tp,'none') && ~strcmp(tp,'x') && ~strcmp(tp,'micro'),
   if nargout == 1,
      if nargin == 1,
         out1 = trmginput(arg1);
      else
         out1 = trmginput;
      end
   elseif nargout == 2 || nargout == 0,
      if nargin == 1,
         [out1,out2] = trmginput(arg1);
      else
         [out1,out2] = trmginput;
      end
      if  nargout == 0
         out1 = [ out1 out2 ];
      end
   elseif nargout == 3,
      if nargin == 1,
         [out1,out2,out3] = trmginput(arg1);
      else
         [out1,out2,out3] = trmginput;
      end
   end
else
   
   fig = gcf;
   figure(gcf);
   
   if nargin == 0
      how_many = -1;
      b = [];
   else
      how_many = arg1;
      b = [];
      if  isstr(how_many) ...
            || size(how_many,1) ~= 1 || size(how_many,2) ~= 1 ...
            || ~(fix(how_many) == how_many) ...
            || how_many < 0
         error('Requires a positive integer.')
      end
      if how_many == 0
         ptr_fig = 0;
         while(ptr_fig ~= fig)
            ptr_fig = get(0,'PointerWindow');
         end
         scrn_pt = get(0,'PointerLocation');
         loc = get(fig,'Position');
         pt = [scrn_pt(1) - loc(1), scrn_pt(2) - loc(2)];
         out1 = pt(1); y = pt(2);
      elseif how_many < 0
         error('Argument must be a positive integer.')
      end
   end
   
   % Suspend axes functions
       %haxes = findobj(fig,'type','axes');
        state = uisuspend(fig);
   %haxes = findobj(fig,'type','axes');
   %state = uisuspend(haxes);
   pointer = get(gcf,'pointer');
   set(gcf,'pointer',strpointertype);  % modified MYGINPUT
   fig_units = get(fig,'units');
   char = 0;

   % We need to pump the event queue on unix
   % before calling WAITFORBUTTONPRESS 
   drawnow
   
   while how_many ~= 0
      % Use no-side effect WAITFORBUTTONPRESS
      waserr = 0;
      try
	keydown = wfbp;
      catch
	waserr = 1;
      end
      if(waserr == 1)
         if(ishandle(fig))
            set(fig,'units',fig_units);
	    uirestore(state);
            error('Interrupted');
         else
            error('Interrupted by figure deletion');
         end
      end
      
      ptr_fig = get(0,'CurrentFigure');
      if(ptr_fig == fig)
         if keydown
            char = get(fig, 'CurrentCharacter');
            button = abs(get(fig, 'CurrentCharacter'));
            scrn_pt = get(0, 'PointerLocation');
            set(fig,'units','pixels')
            loc = get(fig, 'Position');
            pt = [scrn_pt(1) - loc(1), scrn_pt(2) - loc(2)];
            set(fig,'CurrentPoint',pt);         
         else
            button = get(fig, 'SelectionType');
            if strcmp(button,'open') 
               button = 1;
            elseif strcmp(button,'normal') 
               button = 1;
            elseif strcmp(button,'extend')
               button = 2;
            elseif strcmp(button,'alt') 
               button = 3;
            else
               error('Invalid mouse selection.')
            end
         end
         pt = get(gca, 'CurrentPoint');
         
         how_many = how_many - 1;
         
         if(char == 13) % & how_many ~= 0)
            % if the return key was pressed, char will == 13,
            % and that's our signal to break out of here whether
            % or not we have collected all the requested data
            % points.  
            % If this was an early breakout, don't include
            % the <Return> key info in the return arrays.
            % We will no longer count it if it's the last input.
            break;
         end
         
         out1 = [out1;pt(1,1)];
         y = [y;pt(1,2)];
         b = [b;button];
      end
   end
   
   uirestore(state);
   set(fig,'units',fig_units);
   
   if nargout > 1
      out2 = y;
      if nargout > 2
         out3 = b;
      end
   else
      out1 = [out1 y];
   end
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function key = wfbp
%WFBP   Replacement for WAITFORBUTTONPRESS that has no side effects.

fig = gcf;
current_char = [];

% Now wait for that buttonpress, and check for error conditions
waserr = 0;
try
  h=findall(fig,'type','uimenu','accel','C');   % Disabling ^C for edit menu so the only ^C is for
  set(h,'accel','');                            % interrupting the function.
  keydown = waitforbuttonpress;
  current_char = double(get(fig,'CurrentCharacter')); % Capturing the character.
  if~isempty(current_char) & (keydown == 1)           % If the character was generated by the 
	  if(current_char == 3)                       % current keypress AND is ^C, set 'waserr'to 1
		  waserr = 1;                             % so that it errors out. 
	  end
  end
  
  set(h,'accel','C');                                 % Set back the accelerator for edit menu.
catch
  waserr = 1;
end
drawnow;
if(waserr == 1)
   set(h,'accel','C');                                % Set back the accelerator if it errored out.
   error('Interrupted');
end

if nargout>0, key = keydown; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
