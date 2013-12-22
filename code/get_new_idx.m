function [ idx, finish ] = get_new_idx( idx, power, k, powers )
    if (power > k)
        finish = true;
        return;
    end
    finish = false;    
    if ((length(powers) >= idx(end) + 1) && (power + powers(idx(end) + 1) - powers(idx(end)) <= k))
        idx(end) = idx(end) + 1;
        return;
    end
    
    gain = Inf;
    for a = (length(idx)-1):-1:1
        gain = 0;
        gain = gain + powers(idx(a) + 1) - powers(idx(a));
        idx(a) = idx(a) + 1;
        for b = (a+1):length(idx)
            gain = gain + powers(idx(a)) - powers(idx(b));
            idx(b) = idx(a);
        end
        if (gain <= 0)
            break;
        end
    end
    if (gain >= 0)
        idx = ones(length(idx) + 1, 1);
        return;
    end
    if (length(idx) > 1)                
        idx(end - 1) = idx(end - 1) + 1;
        idx(end) = idx(end - 1);
    end
end

