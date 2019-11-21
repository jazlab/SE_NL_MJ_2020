load MPM_productions_regime2.mat

mIPI = meanIPIs;
varIPI = stdIPIs .^ 2;

for Ii = 1:length(Ilst)
    errorbar(Ilst(Ii),mIPI(Ii),...
        sqrt(varIPI(Ii)),...
        'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)))
    hold on
    plot(Ilst(Ii),mIPI(Ii),'o',...
        'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)),...
        'MarkerFaceColor',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)))
end
plot(Ilst,mIPI,'k')
xlabel('Input level')
ylabel('Mean IPI (ms)')
mymakeaxis(gca,'interpreter','latex')