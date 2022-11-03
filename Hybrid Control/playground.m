Dr = 130;
MAX_ICE =120;
MIN_MGU = 0;
i = MIN_MGU;
array_mgu = [];
array_ice = [];
while(i<=MAX_ICE)
    array_mgu(end+1) = i;
    array_ice(end+1) = MAX_ICE-i;
    i = i+5;
end
costs = [];
for i=1:k
    disp(i)
end