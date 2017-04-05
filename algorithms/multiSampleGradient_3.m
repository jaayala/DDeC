classdef multiSampleGradient_3 < handle

   properties
       alphaF;
       alphaC;
       delta;
       d;
       pointPerIter = 3;
   end
   methods
       function initilize(this, d, delta, alphaF, alphaC)
           this.delta = delta;
           this.d = d;
            this.alphaF = alphaF;
            this.alphaC = alphaC;           
       end
       function alpha = getAlpha(this,CurrentIteration)
            alpha = this.alphaC * this.alphaF(CurrentIteration);
       end
       
       function n = nPointsPerIter(this)
            n = this.pointPerIter;
       end                
       
       function [x, var] = explorationPoints(this, CurrentPoint)
            x = [CurrentPoint; ...
                CurrentPoint + [this.delta 0]; ...
                CurrentPoint + [0 this.delta]];           
            var = 0;
       end
       
       function gradient = computeGradient(this, y, var) %#ok<INUSD>
           gradient = 1/this.delta * [y(2) - y(1), y(3) - y(1)];
           gradient = gradient(:)';
       end
       
   end
end