%kPAM2KDF 'reads in PAM raw data and makes a KDF file '
% This MatLab function was automatically generated by a converter (KhorosToMatLab) from the Khoros PAM2KDF.pane file
%
% Parameters: 
% Toggle: bg 'Backgr. Correction (if available)', default: 0: 'if data is there the background correction will be applied'
% Double: add0 'Add to Sens. #0', default: 0: 'this constant is added to sensitivity prior to devision'
% Toggle: sc 'Sensitivity Correction (if available)', default: 0: 'if data is there the sensitivity correction will be applied'
% Double: add1 'Add to Sens. #1', default: 0: 'this constant is added to sensitivity prior to devision'
% Toggle: nl 'Do not clip after adjusting', default: 0: 'if selected, not clipping will be performed'
% Integer: subslice 'Slice offset', default: 0: 'The offset of slice to be extracted, when multiple patterns are used'
% InputFile: i 'Input ', required: 'First Input data object'
% OutputFile: o 'Output', required: 'Resulting output data object'
% Toggle: fr 'Evaluate FRAP region', default: 0: 'if selected, the mean of the FRAP region will be evaluated'
% OutputFile: pmf 'Evaluate Plane statistic', optional: 'Evaluates Mean and Std.Dev. into a 2D Array'
% Double: kappa 'Kappa', default: 0.5: 'kappa value with which to scale the data: Val1 - Val2*Kappa/(1-Kappa)'
% Toggle: blc 'Apply bleeching correction to rescaled data', default: 0: 'If selected, a correction for bleeching is applied to rescaled output (not to the noise or to the signal)'
%
% Example: [o, pmf] = kPAM2KDF(i, {'bg',0;'add0',0;'sc',0;'add1',0;'nl',0;'subslice',0;'i','';'o','';'fr',0;'pmf','';'kappa',0.5;'blc',0})
%
% Khoros helpfile follows below:
%
%  PROGRAM
% PAM2KDF - reads in PAM raw data and makes a KDF file
%
%  DESCRIPTION
%
%  
%
%  EXAMPLES
%
%  "SEE ALSO"
%
%  RESTRICTIONS 
%
%  REFERENCES 
%
%  COPYRIGHT
% Copyright (C) 1996-2003, Rainer Heintzmann,  All rights reserved.
% 


function varargout = kPAM2KDF(varargin)
if nargin ==0
  Inputs={};arglist={'',''};
elseif nargin ==1
  Inputs=varargin{1};arglist={'',''};
elseif nargin ==2
  Inputs=varargin{1}; arglist=varargin{2};
else error('Usage: [out1,..] = kPAM2KDF(Inputs,arglist).');
end
if size(arglist,2)~=2
  error('arglist must be of form {''ParameterTag1'',value1;''ParameterTag2'',value2}')
 end
narglist={'bg', 0;'add0', 0;'sc', 0;'add1', 0;'nl', 0;'subslice', 0;'i', '__input';'o', '__output';'fr', 0;'pmf', '__output';'kappa', 0.5;'blc', 0};
maxval={0,0,0,0,0,1,0,0,0,1,100,0};
minval={0,0,0,0,0,1,0,0,0,1,-100,0};
istoggle=[1,0,1,0,1,1,0,0,1,1,1,1];
was_set=istoggle * 0;
paramtype={'Toggle','Double','Toggle','Double','Toggle','Integer','InputFile','OutputFile','Toggle','OutputFile','Double','Toggle'};
% identify the input arrays and assign them to the arguments as stated by the user
if ~iscell(Inputs)
Inputs = {Inputs};
end
NumReqOutputs=1; nextinput=1; nextoutput=1;
  for ii=1:size(arglist,1)
  wasmatched=0;
  for jj=1:size(narglist,1)
   if strcmp(arglist{ii,1},narglist{jj,1})  % a given argument was matched to the possible arguments
     wasmatched = 1;
     was_set(jj) = 1;
     if strcmp(narglist{jj,2}, '__input')
      if (nextinput > length(Inputs)) 
        error(['Input ' narglist{jj,1} ' has no corresponding input!']); 
      end
      narglist{jj,2} = 'OK_in';
      nextinput = nextinput + 1;
     elseif strcmp(narglist{jj,2}, '__output')
      if (nextoutput > nargout) 
        error(['Output nr. ' narglist{jj,1} ' is not present in the assignment list of outputs !']); 
      end
      if (isempty(arglist{ii,2}))
        narglist{jj,2} = 'OK_out';
      else
        narglist{jj,2} = arglist{ii,2};
      end

      nextoutput = nextoutput + 1;
      if (minval{jj} == 0)  
         NumReqOutputs = NumReqOutputs - 1;
      end
     elseif isstr(arglist{ii,2})
      narglist{jj,2} = arglist{ii,2};
     else
        if strcmp(paramtype{jj}, 'Integer') & (round(arglist{ii,2}) ~= arglist{ii,2})
            error(['Argument ' arglist{ii,1} ' is of integer type but non-integer number ' arglist{ii,2} ' was supplied']);
        end
        if (minval{jj} ~= 0 | maxval{jj} ~= 0)
          if (minval{jj} == 1 & maxval{jj} == 1 & arglist{ii,2} < 0)
            error(['Argument ' arglist{ii,1} ' must be bigger or equal to zero!']);
          elseif (minval{jj} == -1 & maxval{jj} == -1 & arglist{ii,2} > 0)
            error(['Argument ' arglist{ii,1} ' must be smaller or equal to zero!']);
          elseif (minval{jj} == 2 & maxval{jj} == 2 & arglist{ii,2} <= 0)
            error(['Argument ' arglist{ii,1} ' must be bigger than zero!']);
          elseif (minval{jj} == -2 & maxval{jj} == -2 & arglist{ii,2} >= 0)
            error(['Argument ' arglist{ii,1} ' must be smaller than zero!']);
          elseif (minval{jj} ~= maxval{jj} & arglist{ii,2} < minval{jj})
            error(['Argument ' arglist{ii,1} ' must be bigger than ' num2str(minval{jj})]);
          elseif (minval{jj} ~= maxval{jj} & arglist{ii,2} > maxval{jj})
            error(['Argument ' arglist{ii,1} ' must be smaller than ' num2str(maxval{jj})]);
          end
        end
     end
     if ~strcmp(narglist{jj,2},'OK_out') &  ~strcmp(narglist{jj,2},'OK_in') 
       narglist{jj,2} = arglist{ii,2};
     end
   end
   end
   if (wasmatched == 0 & ~strcmp(arglist{ii,1},''))
        error(['Argument ' arglist{ii,1} ' is not a valid argument for this function']);
   end
end
% match the remaining inputs/outputs to the unused arguments and test for missing required inputs
 for jj=1:size(narglist,1)
     if  strcmp(paramtype{jj}, 'Toggle')
        if (narglist{jj,2} ==0)
          narglist{jj,1} = ''; 
        end;
        narglist{jj,2} = ''; 
     end;
     if  ~strcmp(narglist{jj,2},'__input') && ~strcmp(narglist{jj,2},'__output') && istoggle(jj) && ~ was_set(jj)
          narglist{jj,1} = ''; 
          narglist{jj,2} = ''; 
     end;
     if strcmp(narglist{jj,2}, '__input')
      if (minval{jj} == 0)  % meaning this input is required
        if (nextinput > size(Inputs)) 
           error(['Required input ' narglist{jj,1} ' has no corresponding input in the list!']); 
        else
          narglist{jj,2} = 'OK_in';
          nextinput = nextinput + 1;
        end
      else  % this is an optional input
        if (nextinput <= length(Inputs)) 
          narglist{jj,2} = 'OK_in';
          nextinput = nextinput + 1;
        else 
          narglist{jj,1} = '';
          narglist{jj,2} = '';
        end;
      end;
     else 
     if strcmp(narglist{jj,2}, '__output')
      if (minval{jj} == 0) % this is a required output
        if (nextoutput > nargout & nargout > 1) 
           error(['Required output ' narglist{jj,1} ' is not stated in the assignment list!']); 
        else
          narglist{jj,2} = 'OK_out';
          nextoutput = nextoutput + 1;
          NumReqOutputs = NumReqOutputs-1;
        end
      else % this is an optional output
        if (nargout - nextoutput >= NumReqOutputs) 
          narglist{jj,2} = 'OK_out';
          nextoutput = nextoutput + 1;
        else 
          narglist{jj,1} = '';
          narglist{jj,2} = '';
        end;
      end
     end
  end
end
if nargout
   varargout = cell(1,nargout);
else
  varargout = cell(1,1);
end
global KhorosRoot
if exist('KhorosRoot') && ~isempty(KhorosRoot)
w=['"' KhorosRoot];
else
if ispc
  w='"C:\Program Files\dip\khorosBin\';
else
[s,w] = system('which cantata');
w=['"' w(1:end-8)];
end
end
[varargout{:}]=callKhoros([w 'pam2kdf"  -k'],Inputs,narglist);