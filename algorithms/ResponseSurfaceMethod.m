classdef ResponseSurfaceMethod < handle
 
   properties
       alphaF;
       alphaC;
       delta;
       d;
       perturbationMatrix;
   end
   methods
       function initilize(this, d, delta, nSamplesPerPoint, alphaF, alphaC)
            this.delta = delta;
            this.d = d;
            this.alphaF = alphaF;
            this.alphaC = alphaC;
           
            nCombinations = 2^d;
            perturbationMatrix_temp = zeros(nCombinations*nSamplesPerPoint, d);

            for j =  1:nCombinations
                auxCombination = dec2binvec(j-1,d);
                auxCombination = double(auxCombination(end:-1:1));
                auxCombination(auxCombination == 0) = -1;
                auxCombination = repmat(auxCombination,nSamplesPerPoint,1);
                perturbationMatrix_temp(((j-1)*nSamplesPerPoint+1):(j*nSamplesPerPoint),:) = auxCombination;
            end
            this.perturbationMatrix = [zeros(nSamplesPerPoint, d);  perturbationMatrix_temp];           
       end
       
       function alpha = getAlpha(this,CurrentIteration)
            alpha = this.alphaC * this.alphaF(CurrentIteration);
       end
       
       function n = nPointsPerIter(this)
            n = length(this.perturbationMatrix(:,1));
       end       
       
       function [x, var] = explorationPoints(this, CurrentPoint)
            points =  repmat(CurrentPoint, length(this.perturbationMatrix(:,1)), 1);
            x = points + this.delta * this.perturbationMatrix;   
            var.x = x;
       end
       
       function gradient = computeGradient(this, y, var) %#ok<INUSL>
           x_ones = [ones(length(var.x(:,1)),1) var.x];
           gradient = (x_ones'*x_ones) \ x_ones' * y;
           gradient = gradient(2:end);
           gradient = gradient(:)';
       end
       
   end
end