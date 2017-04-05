classdef ucb_normal < handle
   properties
       reward; 
       count;
       squareReward;
   end
   methods     
       function initialize (this,num_arms)
           this.reward = zeros(1,num_arms);
           this.count = zeros(1,num_arms);
           this.squareReward = zeros(1,num_arms);
       end;
       function chosen_arm = select_arm(this)
           
           n = sum(this.count);
           minTests = ceil(8*log(n));
           ind_requiredTested_arm = find(this.count<minTests);
           
           ind_untested_arm = find(this.count==0);
           
           if(~isempty(ind_untested_arm))
               chosen_arm = ind_untested_arm(1);
           elseif(~isempty(ind_requiredTested_arm))
%                chosen_arm = ind_requiredTested_arm(1);
               chosen_arm = ind_requiredTested_arm(randi([1 length(ind_requiredTested_arm)]));
           else
               
               bonus = sqrt(16 * (this.squareReward - this.count.*(this.reward.^2))./(this.count-1) * ...
                   (log(n-1))./(this.count));
               ucb = this.reward + bonus;
               [~,chosen_arm] = max(ucb);
           end
       end
       
       function update(this,chosen_arm,reward)
           
           this.count(chosen_arm) = this.count(chosen_arm) + 1;
           nk = this.count(chosen_arm);
           this.reward(chosen_arm) = (nk-1)/nk * this.reward(chosen_arm) + 1/nk*reward;
           this.squareReward(chosen_arm) = this.squareReward(chosen_arm) + reward^2;
       end
   end
end