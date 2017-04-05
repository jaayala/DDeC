classdef modelLTE < handle
 
   properties
        formula;
        names;
        values;
        numcoeffs;
        sformula;
        snames;
        svalues;
        snumcoeffs;        
        minPoint;
        maxPoint;
        opt_point;
   end
   methods
       function initialize(this, model, minPoint, maxPoint)
            this.names = model.coeffnames;
            this.values = model.coeffvalues;
            this.formula = model.formula;
            this.numcoeffs = model.numcoeffs;
            
            this.snames = model.scoeffnames;
            this.svalues = model.scoeffvalues;
            this.sformula = model.sformula;
            this.snumcoeffs = model.snumcoeffs;            
            
            this.minPoint = minPoint;
            this.maxPoint = maxPoint;
            this.opt_point = model.opt_point;
       end
       
       function output = getValues(this, input_val, debug)
           
                if nargin == 2
                    debug = 1;
                end
                
                nPoints = length(input_val(:,1));
                minPoint_m = repmat(this.minPoint,nPoints,1);
                maxPoint_m = repmat(this.maxPoint,nPoints,1);
                if sum(sum(input_val < minPoint_m | input_val > maxPoint_m)) > 0
                    error('Evaluated points out of range.')
                end                 
                
                %Mean computation
                for i = 1:this.numcoeffs
                    eval([this.names{i} ' = ' num2str(this.values(i)) ';']);
                end
    
                means = zeros(nPoints,1);
                for i = 1:nPoints
                    x = input_val(i,1); %#ok<*NASGU>
                    y = input_val(i,2);

                    means(i) = eval(this.formula);
                end
                
                %Variance computation
                for i = 1:this.snumcoeffs
                    eval([this.snames{i} ' = ' num2str(this.svalues(i)) ';']);
                end
    
                v = zeros(nPoints,1);
                for i = 1:nPoints
                    x = input_val(i,1); %#ok<*NASGU>
                    y = input_val(i,2);

                    sigma = eval(this.sformula);
                    v(i) = randn*sigma;
                end

                output = max(means +  debug * v, 0) / 1e6;
       end
       function opt_point = getOptPoint(this)
           opt_point = this.opt_point;
       end             
   end
end