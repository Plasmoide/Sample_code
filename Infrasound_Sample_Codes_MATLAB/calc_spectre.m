function calc_spectre

%spectrogram computation

global first_use path_mat pathname
global nbvoies h frq_ech heure_jolie ht1 ht2 datafil ordre_fil nb_points data temps
global info_nb_graphe info_name_graphe info_sta_graphe info_indice_file_graphe indice_file unite fe HDEB HFIN nbe sensi name station date_ev date_ev2
global rmsdspHndl fhHndl fbHndl fftHndl StdWinHndl filtHndl posHndl dtHndl nb_graphe ideb ifin BUTTON
global PRE I_bon N_pts_min_inter_paq N_pts_min_paq L_ones xlim0 ylim0 choix_si
global MIN_SNR MAX_SNR MIN_RMS_INF MAX_RMS_INF MIN_DSP_INF MAX_DSP_INF MIN_RMS_SIS MAX_RMS_SIS MIN_DSP_SIS MAX_DSP_SIS
global nb_fig no_spec MEAN_SPE freq chasp voie sig_pre N test_spec OPTION COL file_save K pol zer


durfft = str2num(get(fftHndl,'string'));
durwin = str2num(get(StdWinHndl,'string'));
fb = str2num(get(fbHndl,'string'));
fh = str2num(get(fhHndl,'string'));

%===========calcul des spectres
 
  rmsdspHndl = findobj(gcf,'tag','Radiobutton1');
  rms_dsp = get(rmsdspHndl,'value');
 
  if rms_dsp==1
     OPTION = 'RMS';   %OPTION possible : RMS ou DSP
  else
     OPTION = 'DSP';   %OPTION possible : RMS ou DSP
  end
  
  COL=['b';'g';'r';'w';'m';'y';'c';'k'];
  file_save = 'c:/temp/MEAN_SPECTRE';
   
  disp(' ')
  disp('ACTION :')
  disp(' ');
  disp('   - bouton de gauche pour selection d''une seule fenetre');
  disp('   - bouton du milieu pour cumuler les fenetres');
  disp('   - bouton de droite pour afficher la moyenne');   
       
  if BUTTON==1
      MEAN_SPE = [];
      no_spec = 0;
      test_spec = 'single';
      disp(['Selectionnez le debut et la fin de la fenetre avec la souris ...']);
   elseif (BUTTON==2)
      test_spec = 'cumul';
   elseif (BUTTON==3)
      test_spec = 'go';
   end
         
   %================ DEBUT SINGLE (OPTION 1) =====================
   if strcmp(test_spec,'single')
      do_spectre=0;
      nb_fig=nb_fig+1;
      if (nb_fig==length(COL)+1)
          nb_fig=1;
      end
      [voie,tmin,tmax,N1,N2] = select(heure_jolie,h,frq_ech,nbvoies);
      sig_pre = data{voie}(N1:N2);
      choix_si = 'i';
      str = unite(indice_file(info_indice_file_graphe{voie}));
      if strcmp(str{1}(1:2),'nm')==1 | strcmp(str{1}(1:2),'mV')==1
         choix_si = 's';
      end
      N = length(sig_pre);
      if (durfft>N/frq_ech(voie))
          msgbox(['Duree choisie : ' num2str(N/frq_ech(voie)) ' s trop faible.']);
      else
          dospectre;
      end
  end    
  %================ FIN SINGLE (OPTION 1) =====================
  
  
  %================ DEBUT CUMUL (OPTION 2) =====================
  while strcmp(test_spec,'cumul')
       no_spec = no_spec + 1;
       [voie,tmin,tmax,N1,N2] = select(heure_jolie,h,frq_ech,nbvoies);
       choix_si = 'i';
       str = unite(indice_file(info_indice_file_graphe{voie}));
       if strcmp(str{1}(1:2),'nm')==1 | strcmp(str{1}(1:2),'mV')==1
          choix_si = 's';
       end
       sig_pre = data{voie}(N1:N2);
       N = length(sig_pre);
       if (durfft>N/frq_ech(voie))
           msgbox(['Duree choisie : ' num2str(N/frq_ech(voie)) ' s trop faible.']);
           %figure(2)
           %delete(2);
           %nb_fig=0;
           %chasp={};
       else
           dospectre;
       end
       disp(['Fenetre no : ' num2str(no_spec)]);
       disp(['Selectionnez le debut et la fin de la fenetre avec la souris ...']);
       ButtonName=questdlg('Une autre fenetre ?', 'Genie Question', 'oui','non','oui');
       if strcmp(ButtonName,'non')
          return
       end
  end
   %================ FIN CUMUL (OPTION 2) =====================
   
   
   %================ DEBUT GO (OPTION 3) =====================
   if strcmp(test_spec,'go')
      if no_spec<=1
         msgbox(['Selectionnez au minimum 2 fenetres']);
      else
         figure(gcf+1)
         nb_fig=nb_fig+1;
         if (nb_fig==length(COL)+1)
             nb_fig=1;
         end
         word = {[char(info_sta_graphe{voie}) '-' char(info_name_graphe{voie})]};
         chasp = [chasp ; word];
         
         if strcmp(OPTION,'RMS')
            if strcmp(choix_si,'s')         
               loglog(freq,mean(MEAN_SPE),'color',COL(nb_fig),'linewidth',2);
               hold on
               loglog(freq,MEAN_SPE,'k:');
               axis([1/durfft frq_ech(voie)/2 MIN_RMS_SIS MAX_RMS_SIS])
               hl = legend(char(chasp));
               hhl = get(hl,'child');
               for nn = 1:nb_fig
                   set(hhl(nn),'linestyle','-','linewidth',2,'color',COL(nb_fig-nn+1))
               end
               str_y = ['RMS amplitude (' char(unite(indice_file(info_indice_file_graphe{voie}))) '/VHz)'];
            elseif strcmp(choix_si,'i')
               if nb_fig==1
                  load spe_min 
                  load spe_max 
                  loglog(xmin,ymin,'color','k','linestyle','--','linewidth',2)
                  hold on
                  loglog(xmax,ymax,'color','k','linestyle','-.','linewidth',2)
               end
               C_liss = octav_liss(mean(MEAN_SPE),frq_ech(voie),1/3);

               loglog(freq,C_liss,'color',COL(nb_fig),'linewidth',2)
               %loglog(freq,MEAN_SPE,'k:');
               axis([1/durfft frq_ech(voie)/2 MIN_RMS_INF MAX_RMS_INF])
               hl = legend([{'low noise'} ; {'high noise'} ; chasp]);
               hhl = get(hl,'child');
               for nn = 1:nb_fig
                   set(hhl(nn),'linestyle','-','linewidth',2,'color',COL(nb_fig-nn+1))
               end
               %loglog(freq,(MEAN_SPE),'color',COL(nb_fig),'linestyle',':')               
               str_y = ['RMS amplitude (' char(unite(indice_file(info_indice_file_graphe{voie}))) '/VHz)'];
               if strcmp(unite(indice_file(info_indice_file_graphe{voie})),'mPa')
                  str_y = ['RMS amplitude (Pa/VHz)'];
               end
            end
            
         elseif strcmp(OPTION,'DSP')
            
            if strcmp(choix_si,'s') 
               if nb_fig==1
                  load nlnm_avd 
                  load nhnm_avd 
                  semilogx(nlnm_avd(:,2),nlnm_avd(:,3),'color','k','linestyle','--','linewidth',2)
                  hold on
                  semilogx(nhnm_avd(:,2),nhnm_avd(:,3),'color','k','linestyle','-.','linewidth',2)
                  plot(5,-135,'marker','d','color','k','markerfacecol','r')
               end
               semilogx(freq,20*log10(4*pi*pi*1e-9*mean(MEAN_SPE).*freq.^2),'color',COL(nb_fig),'linewidth',2)
               semilogx(freq,20*log10(4*pi*pi*1e-9*MEAN_SPE.*repmat(freq.^2,[size(MEAN_SPE,1),1])),'k:')
               axis([1/durfft frq_ech(voie)/2 MIN_DSP_SIS MAX_DSP_SIS])
               hl = legend([{'low noise'} ; {'high noise'} ; {'IMS spec.'} ; chasp]);
               hhl = get(hl,'child');
               for nn = 1:nb_fig
                   set(hhl(nn),'linestyle','-','linewidth',2,'color',COL(nb_fig-nn+1))
               end
               str_y = ['Power spectral density (10*log(m**2/s**4)/Hz) dB'];
            elseif strcmp(choix_si,'i')
               if nb_fig==1
                  load spe_min 
                  load spe_max 
                  loglog(xmin,ymin.^2,'color','k','linestyle','--','linewidth',2)
                  hold on
                  loglog(xmax,ymax.^2,'color','k','linestyle','-.','linewidth',2)
               end
               loglog(freq,mean(MEAN_SPE),'color',COL(nb_fig),'linewidth',2)
               loglog(freq,MEAN_SPE,'k:');
               axis([1/durfft frq_ech(voie)/2 MIN_DSP_INF MAX_DSP_INF])
               hl = legend([{'low noise'} ; {'high noise'} ; chasp]);
               hhl = get(hl,'child');
               for nn = 1:nb_fig
                   set(hhl(nn),'linestyle','-','linewidth',2,'color',COL(nb_fig-nn+1))
               end
               str_y = ['Power spectral density (Pa**2/Hz)'];
            end
            
         end
         grid on
         zoom on
         hz=xlabel('frequency (Hz)');
         set(hz,'fontsize',10,'fontweight','demi');
         hz=ylabel(str_y);
         set(hz,'fontsize',10,'fontweight','demi');
         hz=title(['Noise spectrum : ', date_ev2]);
         set(hz,'fontsize',12,'fontweight','bold');
         set(gcf,'inverthardcopy','off')
         MEAN_SPE = [];
         no_spec = 0;
         set(hl,'color',[.5 .5 .5])
         set(gcf,'color',[1 1 1])
         set(gca,'color',[.7 .7 .7])
         set(gcf,'inverthardcopy','off')
         zoom on
         do_spectre = 0;
      end
   end
   %================ END GO (OPTION 3) =====================


