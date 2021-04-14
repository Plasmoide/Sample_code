function calc_snr

%Signal/noise ratio calculation
%calcul du rapport signal sur bruit

global first_use path_mat pathname
global nbvoies h frq_ech heure_jolie ht1 ht2 datafil ordre_fil nb_points data temps
global info_nb_graphe info_name_graphe info_sta_graphe info_indice_file_graphe indice_file unite fe HDEB HFIN nbe sensi name station date_ev date_ev2
global rmsdspHndl fhHndl fbHndl fftHndl StdWinHndl filtHndl posHndl dtHndl nb_graphe ideb ifin BUTTON
global PRE I_bon N_pts_min_inter_paq N_pts_min_paq L_ones xlim0 ylim0 choix_si
global MIN_SNR MAX_SNR MIN_RMS_INF MAX_RMS_INF MIN_DSP_INF MAX_DSP_INF MIN_RMS_SIS MAX_RMS_SIS MIN_DSP_SIS MAX_DSP_SIS
global nb_snr no_spec MEAN_SPE chasnr 

durfft = str2num(get(fftHndl,'string'));
durwin = str2num(get(StdWinHndl,'string'));
fb = str2num(get(fbHndl,'string'));
fh = str2num(get(fhHndl,'string'));

color=['b';'g';'r';'m';'k';'y';'c'];
   do_snr=0;
   nb_snr=nb_snr+1;
   if (nb_snr==8)
      nb_snr=1;
      MIN_SNR = [];	  		     
      MAX_SNR = [];	  		      
   end
      
   [voie,tmin,tmax,N1,N2] = select(heure_jolie,h,frq_ech,nbvoies) ;
   
   sig_pre = data{voie}(N1:N2);
   N       = length(sig_pre);

   if (durfft>N/frq_ech(voie))
       msgbox(['Duree choisie : ' num2str(N/frq_ech(voie)) ' s trop faible']);
       do_snr=0;
   else
       do_snr=1;
   end

   if (do_snr==1);
      
     	Nfft   = round(durfft*frq_ech(voie));
   	Ndecal = round(Nfft/10);
   	df     = 1/durfft;
   	Nbfen  = ceil((N-Nfft)/Ndecal);
   	freq   = [1:round(Nfft/2)]*df;
      fen    = hanning(Nfft);
      e_fen  = Nfft/sum(fen.^2); 

   	SIG = zeros(Nbfen,Nfft);

   	for m = 1:Nbfen
      	SIG(m,:) = (sqrt(durfft)*sqrt(e_fen)*fft(sig_pre(1+(m-1)*Ndecal:(m-1)*Ndecal+Nfft).*hanning(Nfft))/Nfft)';
     	end
      
      [voie,tmin,tmax,N1,N2] = select(heure_jolie,h,frq_ech,nbvoies);
      
    	sig_pre = data{voie}(N1:N2);
      N       = length(sig_pre);
        
    	if (durfft>N/frq_ech(voie))
          msgbox(['Duree choisie : ' num2str(N/frq_ech(voie)) ' s trop faible']);
	       do_snr=0;
   	else
      	 do_snr=1;
      end
         
      if (do_snr==1);
            
     		 Nfft   = durfft*frq_ech(voie);
   		 Ndecal = Nfft/10;
   	    df     = 1/durfft;
   	    Nbfen  = ceil((N-Nfft)/Ndecal);
   		 freq   = [1:round(Nfft/2)]*df;
          fen    = hanning(Nfft);
          e_fen  = Nfft/sum(fen.^2); 

   		 NOISE = zeros(Nbfen,Nfft);

  			 for m = 1:Nbfen
     		     NOISE(m,:) = (sqrt(durfft)*sqrt(e_fen)*fft(sig_pre(1+(m-1)*Ndecal:(m-1)*Ndecal+Nfft).*hanning(Nfft))/Nfft)';
      	 end
         
   	    if Nbfen>1
      		 SNR=(mean(abs(SIG(:,1:round(Nfft/2)))))./(mean(abs(NOISE(:,1:round(Nfft/2)))));
   		 else 
      		 SNR=(abs(SIG(:,1:round(Nfft/2))))./(abs(NOISE(:,1:round(Nfft/2))));
   		 end
    
    		 figure(gcf+2)
   		 hh = loglog(freq,SNR,color(nb_snr));
          set(hh,'linewidth',2)
            
          MIN_SNR  = [MIN_SNR min(SNR)];
          MAX_SNR  = [MAX_SNR max(SNR)];

          axis([1/durfft frq_ech(voie)/2 min(MIN_SNR)/2 max(MAX_SNR)*2])
          
          word = {[char(info_sta_graphe{voie}) '-' char(info_name_graphe{voie})]};
          chasnr = [chasnr ; word];
          legend(char(chasnr),2);
         
    		 hold on   
   		 grid on
                        
          hz=xlabel('frequency (Hz)');
          set(hz,'fontsize',10,'fontweight','demi');
   	    hz=ylabel('Relative amplitude');
          set(hz,'fontsize',10,'fontweight','demi');
  	       hz=title(['Signal to Noise Ratio : ',date_ev2]);
          set(hz,'fontsize',12,'fontweight','bold');

      end  %end (do_snr==1)     
     
  end % end (do_snr==1);

set(gcf,'inverthardcopy','off')