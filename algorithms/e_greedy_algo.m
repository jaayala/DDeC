classdef e_greedy_algo < handle
    
   properties
       reward; 
       count;
       epsilon;
   end
   methods
       function this = e_greedy_algo(epsilon)
          this.epsilon = epsilon;
       end;
       function initialize (this,num_arms)
           this.reward = zeros(1,num_arms);
           this.count = zeros(1,num_arms);
       end;
       function chosen_arm = select_arm(this)
           % Que rama se elige en funcion de la historia
           ind_untested_arm = find(this.count==0);
           if(~isempty(ind_untested_arm))
                chosen_arm = ind_untested_arm(1);
           else
                if (rand < this.epsilon)
                    chosen_arm = randi(length(this.count),1);
                else
                    [~,chosen_arm] = max(this.reward);
                end
           end
       end
       function update(this,chosen_arm,reward)

           this.count(chosen_arm) = this.count(chosen_arm) + 1;
           nk = this.count(chosen_arm);
           this.reward(chosen_arm) = (nk-1)/nk * this.reward(chosen_arm) + 1/nk*reward;
       end
   end
end