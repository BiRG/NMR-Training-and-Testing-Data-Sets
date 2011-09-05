function DisplayResults(x,ycontrol,ycase,outputdir,both)
% DisplayResults: plots the mean of both groups.
%--------------------------------------------------------------------------
% Displays plots for the mean of ycontrol and ycase. 
%
% DisplayResults(x,ycontrol,ycase)
%
% Inputs:
%   x           The chemical shifts (x-axis) in ppm. 
%   ycontrol    Replicated end spectra of mixture 1.
%   ycase       Replicated end spectra of mixture 2.
%--------------------------------------------------------------------------
%         ** Rebecca Anne Jones - Imperial College London (2008) **
%--------------------------------------------------------------------------

testyco = mean(ycontrol,2);
figure;
subplot(2,1,1); plot(x,testyco,'k');set(gca,'XDir','Reverse');
xlim([0 10]);
top=1.1*max(max(mean(ycontrol,2)),max(mean(ycase,2)));
bottom = -0.1*top;
if top > 0 && bottom >0 && top>bottom
    ylim([bottom top]);
end;
xlabel('\delta (ppm)');  
if both == 1
    title('Mixture 1 with Peak Shift')
else
    title('Mixture 1')
end;
testyca = mean(ycase,2);
subplot(2,1,2); plot(x,testyca,'k');set(gca,'XDir','Reverse');
xlim([0 10]);
if top > 0 && bottom >0 && top>bottom
    ylim([bottom top]);
end;
xlabel('\delta (ppm)');  
if both == 1
    title('Mixture 2 with Peak Shift')
else
    title('Mixture 2')
end;
print ('-f1', '-djpeg', strcat(outputdir,'/','Spectrum.jpeg'));