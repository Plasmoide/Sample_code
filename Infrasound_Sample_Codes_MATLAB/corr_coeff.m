function corr_coeff

global first_use path_mat pathname path_cor 
global nbvoies h frq_ech heure_jolie ht1 ht2 datafil temps ordre_fil nb_points data
global info_nb_graphe info_name_graphe info_sta_graphe info_indice_file_graphe indice_file unite fe HDEB HFIN nbe sensi name station date_ev date_ev2
global rmsdspHndl fhHndl fbHndl fftHndl StdWinHndl filtHndl posHndl dtHndl nb_graphe ideb ifin test_fon BUTTON choix_si
global MIN_SNR MAX_SNR MIN_RMS_INF MAX_RMS_INF MIN_DSP_INF MAX_DSP_INF MIN_RMS_SIS MAX_RMS_SIS MIN_DSP_SIS MAX_DSP_SIS
global nb_fig no_spec MEAN_SPE chasp nb_snr chasnr nb_hist cha_hist nb_coh nb_cor chacor
global nom_cor deg_lat_cor min_lat_cor deg_long_cor min_long_cor bdf_cor path_cor Nb_bande_cor
global PRE I_bon N_pts_min_inter_paq N_pts_min_paq L_ones

durfft = str2num(get(fftHndl,'string'));
durwin = str2num(get(StdWinHndl,'string'));
fb = str2num(get(fbHndl,'string'));
fh = str2num(get(fhHndl,'string'));

COL=['b';'g';'r';'w';'m';'y';'c';'k'];

%diagramme temps-frequence - calcul de la coherence
PRE_FIL = {};

taux5 = 0.5;         % recouvrement (/1)

str_cor = {};
nb = 0;
for voie2=1:nbvoies
   if strcmp(unite(indice_file(info_indice_file_graphe{voie2})),'nm') | strcmp(unite(indice_file(info_indice_file_graphe{voie2})),'Pa') | strcmp(unite(indice_file(info_indice_file_graphe{voie2})),'mPa') | (test_fon==2)
      nb = nb + 1;
      str_cor{nb} = [char(info_sta_graphe{voie2}) '-' char(info_name_graphe{voie2})];
      FE = frq_ech(nb);
   end
end

if nb<2
   msgbox(['Le nombre de voies doit etre superieur a 2']);
   return
end

selection = [];
while length(selection)<2
   [selection,OK] = listdlg('liststring',[str_cor],'name','Correlation : selection des voies');
   if OK==0
      return
   end
end

%================================================================================

exist_cor = findobj(0,'tag','77');
if length(exist_cor)==1
   nb_cor = nb_cor + 1;
else
   chacor = {};
   nb_cor = 1;
end

ech_deb = ideb(1);
ech_fin = ifin(1);

nb  = 0;
dum_cor = 1;
SIG = [];
str_info = [];
for voie2=1:nbvoies
   if strcmp(unite(indice_file(info_indice_file_graphe{voie2})),'nm') | strcmp(unite(indice_file(info_indice_file_graphe{voie2})),'Pa') | strcmp(unite(indice_file(info_indice_file_graphe{voie2})),'mPa') | (test_fon==2)
      nb = nb + 1;
      if dum_cor<=length(selection)
         if nb==selection(dum_cor)  
            SIG(:,dum_cor) = data{voie2}(ech_deb:ech_fin);
            str_info = [ char(info_sta_graphe{voie2}) '-' str_info];
            dum_cor = dum_cor + 1;
         end
      end
   end
end
dum_cor = dum_cor - 1;

%===================================================================
% filtrage des donnees
%===================================================================
wait_b=waitbar(0,'Filtrage en cours...');

for voie2=1:dum_cor
   
   if fb==0
      [b,a] = butter(ordre_fil,fh*2/FE);
   else
      [b,a] = butter(ordre_fil,[fb fh]*2/FE);
   end  
   
   nb = nb_points(voie2);
   waitbar((voie2)*1/nbvoies);
   PRE = SIG(:,voie2) - mean(SIG(:,voie2));
   PRE_FIL{voie2} = PRE ;

   if strcmp(unite(indice_file(info_indice_file_graphe{voie2})),'nm') | strcmp(unite(indice_file(info_indice_file_graphe{voie2})),'Pa') | strcmp(unite(indice_file(info_indice_file_graphe{voie2})),'mPa') | (test_fon==2)
      [nb_paquet,I_deb_paq_new,I_fin_paq_new] = ind_paq(PRE,N_pts_min_inter_paq,N_pts_min_paq);
      if nb_paquet>0
         for m = 1:nb_paquet
            win_cos = cosbell(I_fin_paq_new(m)-I_deb_paq_new(m)+1,L_ones);
            PRE_FIL{voie2}(I_deb_paq_new(m):I_fin_paq_new(m)) = filter(b,a,PRE(I_deb_paq_new(m):I_fin_paq_new(m)).*win_cos);
         end
      end
   end
   
end
close(wait_b);

wait_b = waitbar(0,'calcul de la correlation moyenne ...');
k = 0;
C = 0;
i = [];
for i=1:dum_cor
   for j=i+1:dum_cor
        k = k + 1;
        waitbar(2*k/(dum_cor*(dum_cor-1)));
        C  = C + xcov(PRE_FIL{i},PRE_FIL{j})./sqrt( max(xcov(PRE_FIL{i},PRE_FIL{i}))*max(xcov(PRE_FIL{j},PRE_FIL{j})) );
   end
end
close(wait_b);
C = C/k;

x_temps = [-round(length(C)/2)+1:round(length(C)/2)-1]/FE;

%====================================================================================

h7 = figure(gcf+7);
set(h7,'tag','77')

nb_col = nb_cor;
if nb_cor>8
   nb_col = nb_cor-8;
end

plot(x_temps,C,'linew',2,'col',COL(nb_col))
hold on
grid on

MAX_C1 = max(abs(C));
I_sel = find(x_temps==0);
MAX_C2 = C(I_sel);

title(['Normalized Cross Correlation : ' num2str(date_ev2) ' - [' num2str(fb) ':' num2str(fh) ']Hz'],'fontsize',10,'fontweight','bold','color','k');
str = ['Max : ' num2str(round(MAX_C1*100)/100) ', Max(0) : ' num2str(round(MAX_C2*100)/100)];
chacor{nb_cor} = [str_info(1:end-1) ' - ' str] ;

xlabel('Delay (sec)','fontsize',10,'color','k','fontweight','demi')
ylabel('Correlation Function Estimate','fontsize',10,'color','k','fontweight','demi')
set(gca,'fontsize',8,'xlim',[min(x_temps) max(x_temps)]);

hl = legend(char(chacor));
set(hl,'color',[.5 .5 .5])
set(gcf,'color',[1 1 1])
set(gca,'color',[.7 .7 .7])
set(gcf,'inverthardcopy','off')
zoom on
