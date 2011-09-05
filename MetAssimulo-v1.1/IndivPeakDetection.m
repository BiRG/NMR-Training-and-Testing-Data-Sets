function [finalmid, peak_list, ibegend, check] = IndivPeakDetection2(x,y,set,howbroad,metabolite)
% IndivPeakDetection:
%--------------------------------------------------------------------------
% Finding the all the maximum peaks above a threshold.
% Revised 040810 TMDE to save the beginning and end positions of the peak
lenofy = length(y);
finalmid = [];
peak_list = [];
ibegend = [];
k=max(y);
if k == 0
    check = 3;
else
    while k > set          
        test = find(y == max(y));          % Find the maximum peak
        %%% PROBLEM IF test1 IS MORE THAN ONE VALUE %%%
        % HM Edit : start with the first point where y=max(y) and if they
        % turn out to be separate peaks they will be cut out individually.
        if length(test>1)
            test1=test(1);
        else
            test1=test;
        end;
        finalmid = [finalmid; test1];       % Put into output.
        half = (max(y))/2;                  % Find the value at half max height.      
                                            % Moving back to find peak width       
        
        %%% Find Line Width %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        countback = test1;                  
        while y(countback) >= set           
            countback = countback - 1;      
        end
        countforward = test1;
        while y(countforward) >= set
            countforward = countforward + 1;
        end
        testa = countback:test1;
        testb = test1:countforward;
        a = half;     
        
        % HM Edit : parameters for spline parsed in wrong order?
        l0 = spline(x(testa),y(testa),a);       %l0 = interp1(y(testa),x(testa),a);     
        l1 = spline(x(testb),y(testb),a);       %l1 = interp1(y(testb),x(testb),a);
        if l1 > l0
            l11 = l1;
            l01 = l0;
        else
            l11 = l0;
            l01 = l1;
        end
        linewidth = l11 - l01;
        
        %%% Set Upper & Lower Limits of Peak Boundary %%%%%%%%%%%%%%%%%%%%%
        
        upper = (howbroad.*(linewidth./2))+x(test1);
        if upper > x(lenofy)
           upper = x(lenofy); 
        end
        lowerv = x(test1) - (howbroad.*(linewidth./2));
        if lowerv < x(1)
            lowerv = x(1);
        end
        
        %%% Set Boundaries for Peak %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [testind1,testind2,check] = IndivPeakSetBoundaries(x,y,lowerv,upper,set,metabolite);        
        
        if check == 0
           band2 = testind1:testind2; 
           ibegend = [ibegend; testind1 testind2];
           peak = zeros(1,lenofy);
           peak(band2) = y(band2);
           peak_list = [peak_list; peak];       
           y(band2) = 0;
           k=max(y);
        else k=set;
          peak_list = []; 
          finalmid = [];
        end;
    end;
end