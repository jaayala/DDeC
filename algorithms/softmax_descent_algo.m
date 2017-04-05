classdef softmax_descent_algo < handle
    
   properties
       reward; 
       count;
       tao_0;
   end
   methods
       function this = softmax_descent_algo(tao_0)
          this.tao_0 = tao_0;
       end;
       function initialize (this,num_arms)
           this.reward = zeros(1,num_arms);
           this.count = zeros(1,num_arms);
       end;
       function chosen_arm = select_arm(this)

           ind_untested_arm = find(this.count==0);
           if(~isempty(ind_untested_arm))
                chosen_arm = ind_untested_arm(1);
           else
                nArms = length(this.count);
				tao = this.tao_0 / log(sum(this.count));
                tao = max(tao, this.tao_min);
				denominator = sum(exp(this.reward/tao));
				prob = exp(this.reward/tao) / denominator;
				
				chosen_arm = sum(repmat(rand,1,nArms)> cumsum(prob)/sum(prob))+1;
           end
       end
       function update(this,chosen_arm,reward)

           this.count(chosen_arm) = this.count(chosen_arm) + 1;
           nk = this.count(chosen_arm);
           this.reward(chosen_arm) = (nk-1)/nk * this.reward(chosen_arm) + 1/nk*reward;
       end
   end
end
