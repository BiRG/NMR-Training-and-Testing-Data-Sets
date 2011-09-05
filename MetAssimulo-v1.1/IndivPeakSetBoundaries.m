function [testind1,testind2,check] = IndivPeakSetBoundaries(x,y,lowerv,upper,set,metabolite)
% IndivPeakSetBoundaries:
% The upper and lower values were found with the line width. This function
% calculates the gradients and extends the peak until the gradient is less than or equal
% to 0 or while the intensity is great than the set threshold.
check=0;

[dummy1, ind1] = min(abs(x-lowerv));   % Find nearest value
testind1 = ind1;
while lowerv < x(ind1)         % If half
    ind1 = ind1 - 1;
end
if ind1 > 1     % changed from >=1
    testind10 = testind1 - 1;
    grad1 = (y(testind1) - y(testind10))/(x(testind1)- x(testind10));
    %  while grad1 > 0 || y(testind10) > set      % for multiple peaks
    while (grad1 > 0 || y(testind1) > set)  && testind1>2      % good for individual peaks
        testind1 = testind10 ;
        testind10 = testind1 - 1;
        grad1 = (y(testind1) - y(testind10))/(x(testind1)- x(testind10));
    end
    if testind1 == 2
        warning1=strcat('***** No Peaks Detected for : ',metabolite);
        warning(warning1)
        check = 1;
    end;
elseif ind1 < 1
    testind1 = 1;
end;

lenofy = length(y);

[dummy2, ind2] = min(abs(x-upper));
testind2 = ind2;
if check == 0
    while upper > x(ind2)
        ind2 = ind2 + 1;
    end;
    if ind2 < lenofy
        testind20 = testind2 +1;
        grad2 = (y(testind2) - y(testind20))/(x(testind2)- x(testind20));
        while (grad2 < 0 || y(testind2) > set) && (testind2 < lenofy-1 )        % good for individual peaks
            %    while grad2 < 0 || y(testind20) > set       % for multiple peaks
            testind2 = testind20;
            testind20 = testind2 + 1;
            grad2 = (y(testind2) - y(testind20))/(x(testind2)- x(testind20));
        end ;
        if testind2 == lenofy-1
            warning2=strcat('***** No Peaks Detected for : ',metabolite);
            warning(warning2)
            check = 1;
        end;
    elseif ind2 == lenofy
        testind2 = ind2;
    end;
end;