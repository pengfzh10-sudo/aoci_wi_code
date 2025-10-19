function [G, Y] = generate_channel_delay(num, pr, mode,mu, L)
    pc = 0;
    G = zeros(num,L);
    Y = zeros(num,L);
    state_seq = zeros(num,L);
    
    iid_tp = [1];
    bursty_tp = [0.8, 0.2
                 0.8, 0.2];
    correlate_tp = [(1+mu)/2,(1-mu)/2
                    (1-mu)/2,(1+mu)/2];
%     correlate_tp  = [0.1, 0.5, 0.4
%                      0.4, 0.1, 0.5
%                      0.5, 0.4, 0.1];
    switch(mode)
        case 'bursty'
            P = bursty_tp;
        case 'correlate'
            P = correlate_tp;
            mu = 1;
        otherwise
            P = iid_tp;
    end
    
    
    cum_P = cumsum(P,2);

    current_state = ones(1,L);
    next_state   = ones(1,L);
    mu_L = ones(1,L) * mu;
    r = rand(num,L);
    for num_Y = 1:num
         
        for ii = 1:L
            % 获取当前状态的累积概率分布 (CDF)
       
            cumu_prob = cum_P(current_state(ii), :);
    
            % 生成一个 (0, 1] 之间的随机数
           
    
            % 根据随机数和累积概率确定下一个状态
            % find 会返回第一个满足 r <= cumulativeProbs(i) 的索引 i
            next_state(ii) = find(r(num_Y,ii) <= cumu_prob, 1, 'first');
            current_state(ii) = next_state(ii);
            if(strcmp(mode, 'bursty'))
                if(current_state(ii) == 1)
                    mu_L(ii) = 1;
                elseif(current_state(ii) == 2)
                    mu_L(ii) = mu;
                end
            elseif(strcmp(mode,'correlate'))
                if(current_state(ii) == 1)
                    mu_L(ii) = mu;
                elseif(current_state(ii) == 2)
                    mu_L(ii) = 5;
                elseif(current_state(ii) == 3)
                    mu_L(ii) = 10;
                end
            end
            state_seq(num_Y,ii) = next_state(ii);
            
            Y(num_Y,ii) = single_delay(mode,mu_L(ii) );
        end
      
         
    
    end

    
    current_state = ones(1,1);
    mu_G = mu;
    for jj = 1:L
        num_G = 1;
        while num_G <= num
              % 获取当前状态的累积概率分布 (CDF)
       
            cumu_prob = cum_P(current_state, :);
        
            % 生成一个 (0, 1] 之间的随机数
            r = rand(1,1);
        
            % 根据随机数和累积概率确定下一个状态
            % find 会返回第一个满足 r <= cumulativeProbs(i) 的索引 i
            next_state = find(r   <= cumu_prob, 1, 'first');
    
            current_state = next_state;
            
%             if(current_state == 2)
%                 mu_G = 5;
%             elseif(current_state == 3)
%                 mu_G = 10;
%             end

            if(strcmp(mode,'bursty'))
                if(current_state == 1)
                    mu_G = 1;
                elseif(current_state == 2)
                    mu_G = mu;
                end
            elseif(strcmp(mode,'correlate'))
                if(current_state == 1)
                    mu_G = mu;
                elseif(current_state == 2)
                    mu_G = 5;
                elseif(current_state == 3)
                    mu_G = 10;
                end
            end
    
            Yi  = single_delay(mode,mu_G );      
            G(num_G,jj) = G(num_G,jj) + Yi;
            if(rand(1,1) >= pr)
                num_G = num_G + 1;
            end
        
        end
    end

    
    function Y = single_delay(mode,mu)
        if(strcmp(mode,'const'))
            Y = ones(1,1);
        elseif(strcmp(mode,'normal'))
            Y = 2*rand(1,1);
        elseif(strcmp(mode,'exp'))
            Y = exprnd(mu,1,1);
        else
            Y = exprnd(mu,1,1);
        end
    end
end

