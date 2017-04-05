classdef thompson_sampling_normal_algo < handle
   properties
       meanReward; 
       squareReward;
       count;       
       alpha;
   end
   methods     
       function this = thompson_sampling_normal_algo(alpha)
          this.alpha = alpha;
       end;       
       function initialize (this,num_arms)
           this.meanReward = zeros(1,num_arms);
           this.count = zeros(1,num_arms);
           this.squareReward = zeros(1,num_arms);
       end;
       function chosen_arm = select_arm(this)
           
           minTests = max([2, (3-floor(2*this.alpha))]);
           ind_requiredTested_arm = find(this.count<minTests);
           
          
           if(~isempty(ind_requiredTested_arm))
               chosen_arm = ind_requiredTested_arm(1);
%                chosen_arm = ind_requiredTested_arm(randi([1 length(ind_requiredTested_arm)]));
           else

               S = this.squareReward - this.count.*(this.meanReward.^2);
               F = zeros(1,length(this.count));               
               for i = 1:length(this.count)
                   F(i) = trnd(this.count(i)+2*this.alpha-1,1,1);
               end

               armDistr = F ./ sqrt((this.count.*(this.count+2*this.alpha-1))./S) + this.meanReward;
               [~,chosen_arm] = max(armDistr);
           end
       end
       
       function update(this,chosen_arm,reward)

           this.count(chosen_arm) = this.count(chosen_arm) + 1;
           nk = this.count(chosen_arm);
           this.meanReward(chosen_arm) = (nk-1)/nk * this.meanReward(chosen_arm) + 1/nk*reward;
           this.squareReward(chosen_arm) = this.squareReward(chosen_arm) + reward^2;
       end
   end
end