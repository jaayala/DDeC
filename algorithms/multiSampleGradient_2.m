classdef multiSampleGradient_2 < handle

   properties
       alphaF;
       alphaC;
       delta;
       d;
       pointPerIter = 2;
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
           
            v0 = rand(1,this.d)*2 - 1;
            v = v0 / norm(v0);
            x = [CurrentPoint + this.delta * v; CurrentPoint - this.delta * v];
            var.x = x;
            var.v = v;
      
       end
       
       function gradient = computeGradient(this, y, var)
           gradient = 1/(2*this.delta) * (y(1) - y(2)) * var.v;    
           gradient = gradient(:)';
       end
       
   end
end