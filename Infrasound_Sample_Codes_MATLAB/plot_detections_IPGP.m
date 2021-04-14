lire = 0;

path_res = 'Z:\Codes\process_pmcc\IPGP\PMCC-BUL';

T1 = datenum(2016,3,1,14,0,0); %106
T2 = datenum(2016,3,8,19,0,0); %149

TT = T1:T2;
TT = T1:1/24:T2;

FMin = 0.5; 
FMin = 0.05; 
FMax = 5; 
VMin = 0.3; 
VMax = 1;
NbPtsMin = 10;

datev = datevec(TT);
TJ = floor(TT' - datenum(datev(:,1),1,1) + 1);    
TY = datev(:,1);
TM = datev(:,2);
TD = datev(:,3);
TH = datev(:,4);

allBulletin.Tdeb = [];
allBulletin.Tfin = [];
allBulletin.Az = [];
allBulletin.Fmin = [];
allBulletin.Fmax = [];
allBulletin.Fmean = [];
allBulletin.NbPts = [];
allBulletin.Vit = [];
allBulletin.Amp = [];

if lire==1 
    
    for m = 1:length(TT)
    
        str_year = num2str(TY(m));
        str_month = num2str(TM(m));
        str_day = num2str(TD(m));
        str_jul = num2str(TJ(m));
        str_hour = num2str(TH(m));
        
        if length(str_month)==1; str_month = ['0' str_month]; end
        if length(str_day)==1; str_day = ['0' str_day]; end
        if length(str_jul)==1; str_jul = ['0' str_jul]; end
        if length(str_jul)==2; str_jul = ['0' str_jul]; end
        if length(str_hour)==1; str_hour = ['0' str_hour]; end

        path_bul = [path_res '/' str_year '/' str_jul '/bulletin.txt' ];
        
        path_bul = [path_res '\' str_year '\' str_jul '\' str_hour '\bulletin.txt'];

        if exist(char(path_bul))
            B = lire_bul(char(path_bul));
            allBulletin.Vit = [allBulletin.Vit; double(B.Vit)]; 
            allBulletin.Tdeb = [allBulletin.Tdeb; double(B.Tdeb)];
            allBulletin.Tfin = [allBulletin.Tfin; double(B.Tfin)];
            allBulletin.Az = [allBulletin.Az; double(B.Az)];
            allBulletin.Fmin = [allBulletin.Fmin; double(B.Fmin)];
            allBulletin.Fmax = [allBulletin.Fmax; double(B.Fmax)];
            allBulletin.Fmean = [allBulletin.Fmean; double(B.Fmean)];
            allBulletin.NbPts = [allBulletin.NbPts; double(B.NbPts)];
            allBulletin.Amp = [allBulletin.Amp; double(B.Amp)];
        end

    end
    eval(['save BUL_PMCC_IPGP.mat allBulletin'])            

end   %=== lire


load('BUL_PMCC_IPGP.mat')            


indice = find(allBulletin.Tdeb>=T1 & allBulletin.Tdeb<=T2 & allBulletin.NbPts >= NbPtsMin & allBulletin.Fmean>=FMin & allBulletin.Fmean<=FMax & allBulletin.Vit>=VMin & allBulletin.Vit<=VMax);

tdeb = allBulletin.Tdeb(indice);
tfin = allBulletin.Tfin(indice);
az = allBulletin.Az(indice);
fmean = allBulletin.Fmean(indice);
fmin = allBulletin.Fmin(indice);
fmax = allBulletin.Fmax(indice);
npts = allBulletin.NbPts(indice);
v = allBulletin.Vit(indice);
a = allBulletin.Amp(indice);

azi_y = [-180:45:360];
azi_str = [{'S'} {'SW'} {'W'} {'NW'} {'N'} {'NE'} {'E'} {'SE'} {'S'} {'SW'} {'W'} {'NW'} {'N'}];
%=== affichage date   
%        6             'mm/dd'                  03/01                
%       12             'mmmyy'                  Mar00        
%       10             'yyyy'                   2000         
no_date = 6;

date_x = [];
date_str = {};
for year = [TY(1):TY(end)+1]
    if no_date==6
       date_x = [date_x datenum(year,1,1):datenum(year,12,31)];
    elseif no_date==12
       date_x = [date_x datenum(year,[1:12],1)];
    elseif no_date==10
       date_x = [date_x datenum(year,1,1)];
    end
end
for n = 1:length(date_x)
    date_str{n} = datestr(date_x(n),no_date);
end

%=== temps / frequence / azimut
figure(1)
set(gcf,'color','w','inverthardcopy','off')
clf
subplot(211)
hold on
hh = scatter(tdeb, az, 8, fmean, '+');
% for azno = 1:45:361;
%     plot(TIME_ECMWF(1:4:end),(VRATIO_IS(:,azno)-1)*50+azno,'color',.8*[1 1 1]); 
%     plot([TIME_ECMWF(1) TIME_ECMWF(end)],[azno azno],'linew',.5,'linestyle',':','color',.8*[1 1 1]);                   
% end
box on
set(gca,'FontSize',13,'xtick',date_x,'xticklabel',date_str,'ytick',azi_y,'yticklabel',azi_str,'ylim',[0 360])
set(gca, 'Color', [0.4,0.4,0.4])
ylabel('Azimuth [deg]', 'FontSize',16)
set(gca, 'Clim', [FMin, FMax])
set(gca, 'xlim',[T1 T2])
set(gca,'xtick',date_x,'xticklabel',date_str)
cbar = colorbar;
axes(cbar)
set(cbar, 'FontSize', 12)
ylabel('Frequency [Hz]', 'FontSize', 12)
subplot(212)
hold on
hh = scatter(tdeb, az, 8, v, '+');
box on
set(gca,'FontSize',13,'xtick',date_x,'xticklabel',date_str,'ytick',azi_y,'yticklabel',azi_str,'ylim',[0 360])
set(gca, 'Color', [0.4,0.4,0.4])
ylabel('Azimuth [deg]', 'FontSize',16)
set(gca, 'Clim', [VMin, VMax])
set(gca, 'xlim',[T1 T2])
set(gca,'xtick',date_x,'xticklabel',date_str)
cbar = colorbar;
axes(cbar)
set(cbar, 'FontSize', 12)
ylabel('Trace velocity [km/s]', 'FontSize', 12)
drawnow      


%=== densite: frequence / azimut
figure(2)
clf
[nn,ff,aa] = hist2d([FMin FMin fmean' FMax FMax], [0 360 az' 0 360], 15, 180);
hold on
NN  = log10(1+nn);
NLISS = 4;
H = repmat(hanning(NLISS),1,NLISS);
LISS = H.*H';
NN_LISS = conv2(NN,LISS);
NN_LISS = NN_LISS(NLISS/2:end-NLISS/2,NLISS/2:end-NLISS/2);
set(gcf,'pos',[   924   273   870   630],'color','w','inverthardcopy','off')
[C hh] = contourf(ff,aa,NN_LISS,50, 'edgecolor','none');        
box on
ylabel('Azimuth [°]', 'FontSize', 16)     
ylabel('Frequency [Hz]', 'FontSize', 16)     
CLIM = get(gca,'clim');
set(gca,'clim',[0 max(CLIM)*.8],'FontSize',14,'xscale','lin')
axis([FMin FMax 0 360])
xlabel('Frequency [Hz]','FontSize',16)
ylabel('Azimuth [°]','FontSize',16)
cbar = colorbar;
axes(cbar)
set(cbar, 'FontSize', 14)
ylabel('log10 [NbDet]', 'FontSize', 14)     
drawnow

figure(3)
hr=rose3(-az*pi/180+pi/2,90)

