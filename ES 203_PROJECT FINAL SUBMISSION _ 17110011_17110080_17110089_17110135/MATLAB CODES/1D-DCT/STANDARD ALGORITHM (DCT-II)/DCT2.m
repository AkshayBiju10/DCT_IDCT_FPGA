x = [1.75 1.75 1.75 1.75 1.75 1.75 1.75 1.75 ];
%x = [1 2 3 4 -4 -3 -2 -1];
c = [0 0 0 0 0 0 0 0];
y = [0 0 0 0 0 0 0 0];
alph0 = 0.70710678118654752440084436210485;
for k = 1:1:8
    for n = 1:1:8
            
            if k == 1
            y(k) = y(k) + 0.5*x(n)*alph0*cos((pi*((2*n) - 1)*(k - 1))/16);    
            else 
            y(k) = y(k) + 0.5*x(n)*cos((pi*((2*n) - 1)*(k - 1))/16);    
            end    
    end
end
    