classdef modelLTE2scenario < handle
 
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
        changeStage;
        stageCount;
   end
   methods
       function initialize(this, model1, model2, changeStage, minPoint, maxPoint)
            this.names = model1.coeffnames;
            this.values = {model1.coeffvalues model2.coeffvalues};
            this.formula = model1.formula;
            this.numcoeffs = model1.numcoeffs;
            
            this.snames = model1.scoeffnames;
            this.svalues = {model1.scoeffvalues model2.scoeffvalues};
            this.sformula = model1.sformula;
            this.snumcoeffs = model1.snumcoeffs;            
            
            this.opt_point = {model1.opt_point model2.opt_point};
            this.minPoint = minPoint;
            this.maxPoint = maxPoint;
            this.changeStage = changeStage;
            this.stageCount = 1;
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
                
                if this.stageCount < this.changeStage
                    modelIndex = 1;
                else
                    modelIndex = 2;
                end              

                %Mean computation
                for i = 1:this.numcoeffs
                    eval([this.names{i} ' = ' num2str(this.values{modelIndex}(i)) ';']);
                end
    
                means = zeros(nPoints,1);
                for i = 1:nPoints
                    x = input_val(i,1); %#ok<*NASGU>
                    y = input_val(i,2);

                    means(i) = eval(this.formula);
                end
                
                %Variance computation
                for i = 1:this.snumcoeffs
                    eval([this.snames{i} ' = ' num2str(this.svalues{modelIndex}(i)) ';']);
                end
    
                v = zeros(nPoints,1);
                for i = 1:nPoints
                    x = input_val(i,1); %#ok<*NASGU>
                    y = input_val(i,2);

                    sigma = eval(this.sformula);
                    v(i) = randn*sigma;
                end

                output = max(means +  debug * v, 0) / 1e6;
                
                if debug ~= 0
                    this.stageCount = this.stageCount + nPoints;
                end
                
       end
       function opt_point = getOptPoint(this)
            if this.stageCount < this.changeStage
                modelIndex = 1;
            else
                modelIndex = 2;
            end
            opt_point = this.opt_point{modelIndex};
       end
       function resetScenario(this)
           this.stageCount = 1;           
       end
   end
end