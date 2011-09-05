function  yout = KernelSmootherFinal(x,y,bwidth,thres)
% KernelSmootherFinal: Performs kernel smoothing on the spectral intensities.
%--------------------------------------------------------------------------
% x      =  ppm
% y      =  intensity
% bwidth =  maximum bandwidth (as number of data points)*
% 
% thres = specify a threshold as a percentage of the maximum peak in y.
%
% e.g yo = KernelSmoother(x,y,3,21,'Normal')
%
% * Please note bwidth will be corrected to become an odd number.
%--------------------------------------------------------------------------
%          ** Rebecca Anne Jones - Imperial College London (2008)
%--------------------------------------------------------------------------
%
% 050810 Revised TMDE to optimise speed and correct Gaussian kernel formula
%        Note: other kernel formulae may still contain errors
%        Also tried FFT based smoothing but not easy to adjust kernel
%        bandwidth adaptively so not used (although 10 times faster!)
%

if (mod(bwidth,2)==0) % Correct the window to make sure there is a whole number mid point.
    bwidth = bwidth +1;
end
if (size(y,1)>1) % Make y a row vector
    y=y'; 
    colvec=1; 
else
    colvec=0;
end 

% SIDES FOR BANDWIDTH
sides = (bwidth-1)./2;              % Calculate the length from the mid point to either end.
len = length(y);
yout = y;
threshold = (max(y)./100).*thres;   % Create the threshold.
% Set the initial values.
w0 = 1;                             % Start of window.
wmid = 1;                           % Mid point of window.
flag = 0;                           % Flag= 0 when y point below threshold and flag = 1 when above threshold.

if y(wmid) < threshold
    w1 = sides+1;                   % End of window.
else
    w1 = sides+1;
    flag = 1;
end

k = 1./(bwidth.*threshold);         % Setting the constant for the equation    bandwidth = 1/(k* intensity)

while wmid<=len                     % While the mid point of the window is not greater than the number of y points...
    yvalues = y(w0:w1);
    xvalues = x(w0:w1);
    n = length(yvalues);
    
%             width=w1-w0;
%             if (width<=0) width=1; end
    inv2sig = 2./(bwidth*bwidth); % Bandwidth = 2 sigma of Gaussian
    m = exp(-inv2sig*(wmid - [w0:w1]).^2);
        
       
    out = sum(m .* yvalues) ./ sum(m);
    yout(wmid) = out;
    
    % Setting the next values for the window.
    wmid = wmid + 1;                % The mid point moves.
    leftside = wmid - w0;           % Find the difference between the new midpoint and the start of the window.
    rightside = w1 - wmid;
    
    if wmid<len                     % Until center of band reaches the final datapoint.
        if y(wmid) < threshold
            if flag == 0            % BELOW THRESHOLD AND PREVIOUS VALUE BELOW THRESHOLD.
                if leftside>sides              % If the left side of the window is too big..
                    w0 = w0 + 1;               % ..move the start of the window.
                end
                if w1 < len                    % Keep moving the end of the window until it reaches the final y value.
                    w1 = w1 +1;
                end
            elseif flag == 1            % BELOW THRESHOLD AND PREVIOUS VALUE ABOVE THRESHOLD.
                steps = n;
                if leftside>sides
                    w0 = w0 + 1;
                end
                if w1 < len
                    if rightside<sides
                        w1 = w1 + 1;
                    end
                    if rightside>sides
                        w1 = w1 - 1;
                    end
                end
            end
            flag = 0;
        else                            % ABOVE THRESHOLD
            bandwidth = ceil(1./(y(wmid).*k)); % Scale so that bandwidth~1/y and =bwidth when y=thresh
            if (mod(bandwidth,2)==0)
                bandwidth = bandwidth +1;
            end
            newsides = (bandwidth-1)./2;
            
            if bandwidth >= bwidth
                w0 = wmid - sides;
                w1 = wmid + sides;
            else
                w0 = wmid - newsides;
                w1 = wmid + newsides;
            end       
            flag = 1;       
        end
        if w1 > len
            w1 = len;
        end
        if w0 < 1
            w0 = 1;
        end
    end
end

if colvec, yout=yout(:); end
