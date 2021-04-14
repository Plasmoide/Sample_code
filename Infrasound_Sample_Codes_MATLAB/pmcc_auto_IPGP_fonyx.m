%=== PMCC RUN
path0 = pwd;
path_pmcc_exe = 'pmcc44c1.exe';
path_data = 'Z:\Codes\process_pmcc\IPGP\DATA_FIRST';
path_res = 'Z:\Codes\process_pmcc\IPGP\PMCC-BUL';

path_filters_ini = [path0 '\filters_lin2.ini'];  %=== 15 bandes 0.1-5 Hz, 200-10 s, linéaire
 
%== 124 manque capteur 3 entre datenum(2015,6,9,11,0,0):160 et datenum(2015,6,16,5,0,0):167

SENS = 123;
T1 = datenum(2016,3,1,14,0,0); %106
T2 = datenum(2016,3,8,19,0,0); %149

TT = T1:1/24:T2;

datev = datevec(TT);
TJ = floor(TT' - datenum(datev(:,1),1,1) + 1);    
TY = datev(:,1);
TM = datev(:,2);
TD = datev(:,3);
TH = datev(:,4);
        
%=== fixed parameters in pmcc.ini
Fe = 100.0000000;
Decim = 4;
VStoreMin = 0.2;
VStoreMax = 10;
WindowLength = [90.000000,71.145247,56.618907,45.427324,36.804950,30.161982,25.044014,21.100959,18.063096,15.722624,13.919445,12.530215,11.459905,10.635302,10.000000 ];
TimeStep = [9.000000,7.114525,5.661891,4.542732,3.680495,3.016198,2.504401,2.110096,1.806310,1.572262,1.391944,1.253021,1.145990,1.063530,1.000000 ];
ThresholdConsistency = 0.1;
NbSensors = 3;
NbFilters = 15;
VStoreMinPix = 0.200000;
ThresholdDate = [36.000000,28.458099,22.647563,18.170930,14.721980,12.064793,10.017606,8.440384,7.225238,6.289050,5.567778,5.012086,4.583962,4.254121,4.000000 ];
ThresholdLFamMin = 10.000000;
ThresholdLFamMax = 50.000000;
ThresholdDistance = 1.000000;
sigma_t = [18.000000,14.229049,11.323781,9.085465,7.360990,6.032396,5.008803,4.220192,3.612619,3.144525,2.783889,2.506043,2.291981,2.127060,2.000000];
sigma_f = 5.000000;
sigma_v = 0.10000;
sigma_a = 5.000000;
Length = 3600;

        
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

    if ~exist([path_res '/' str_year])
        mkdir([path_res '/' str_year])
    end
    if ~exist([path_res '/' str_year '/' str_jul])
        mkdir([path_res '/' str_year '/' str_jul])
    end
    if ~exist([path_res '/' str_year '/' str_jul '/' str_hour])
        mkdir([path_res '/' str_year '/' str_jul '/' str_hour])
    end
    
    str_date = [num2str(TY(m)) '-' str_month '-' str_day] ;
    
    path_families_txt = [path_res '\' str_year '\' str_jul '\' str_hour '\families.txt'];
    path_bulletin_txt = [path_res '\' str_year '\' str_jul '\' str_hour '\bulletin.txt'];
    path_result_txt = [path_res '\' str_year '\' str_jul '\' str_hour '\result.txt'];
    path_pmcc_ini = [path_res '\' str_year '\' str_jul '\' str_hour '\pmcc.ini']; 
    
    %=== set pmcc parameters
    str_PathVersion = 'VersionPMCC=4.4';
    str_Technology = ['Technology = infrasound'];
    str_Fe         = ['Fe = ' sprintf('%.6f',Fe)];
    str_Decim      = ['Decim = ' sprintf('%d',Decim)];
    str_OverSamplingRate = ['OverSamplingRate = 1'];
    str_WindowLength = 'WindowLength = ';
    str_TimeStep = 'TimeStep = ';
    str_q = 'q = ';
    str_ThresholdNbSensors  = ['ThresholdNbSensors = '];
    str_ThresholdDate = ['ThresholdDate = '];
    str_sigma_t = ['sigma_t = '];
    for mm = 1:NbFilters
       str_WindowLength = [str_WindowLength  sprintf('%.3f',WindowLength(mm)) ','];
       str_TimeStep     = [str_TimeStep sprintf('%.3f',TimeStep(mm)) ','];
       str_q     = [str_q '50.0,'];
       str_ThresholdNbSensors     = [str_ThresholdNbSensors '3,'];
       str_ThresholdDate = [str_ThresholdDate sprintf('%.1f',ThresholdDate(mm)) ','];
       str_sigma_t = [str_sigma_t sprintf('%.1f',sigma_t(mm)) ','];
    end
    str_WindowLength = str_WindowLength(1:end-1);
    str_TimeStep = str_TimeStep(1:end-1);
    str_q = str_q(1:end-1);
    str_ThresholdNbSensors = str_ThresholdNbSensors(1:end-1);
    str_ThresholdDate = str_ThresholdDate(1:end-1);
    str_ThresholdConsistency = ['ThresholdConsistency = ' num2str(ThresholdConsistency)];
    str_Pix_det_type = ['Pix_det_type = consist'];
    str_Compute_fstat = ['Compute_fstat = 0'];
    str_ThresholdFStatRatio = ['ThresholdFStatRatio = 1.000000'];
    str_NbSensors  = ['NbSensors = ' sprintf('%d',NbSensors)];
    str_NbFilters  = ['NbFilters = ' sprintf('%d',NbFilters)];
    str_NbCoeff    = ['NbCoeff = 4'];     
    str_TypeFiles  = ['TypeFiles = 1'];        
    
    str_PathStreams = ['PathStreams=' path_data '\' num2str(TM(m)) '\' str_year '-' str_jul '\' str_hour];
        str_PathStreams = ['PathStreams=' path_data '\MAIDO\' str_year '-' str_jul '\' str_hour];
        str_PathStreams = ['PathStreams=' path_data '\' str_year '-' str_jul '\' str_hour];

%         if TM(m)==8
%                 str_PathStreams = ['PathStreams=' path_data '\AOUT\' str_year '-' str_jul '\' str_hour];
%         elseif TM(m)==9
%                 str_PathStreams = ['PathStreams=' path_data '\SEPTEMBRE\' str_year '-' str_jul '\' str_hour];
%         end
        
    str_Stations = ['Stations= MB31,MB32,MB33'];
    str_Sensors = ['Sensors = BDF,BDF,BDF']; 

    str_StartingDate = ['StartingDate = ' str_year '-' str_month '-' str_day ' ' str_hour ':00:00'];
    str_Length     = ['Length = ' sprintf('%.3f',Length)];
    str_StoreFam   = ['StoreFam = 0'];
    str_StoreRes   = ['StoreRes = 0'];
    str_StoreBul   = ['StoreBul = 1'];   
    str_VStoreMinPix = ['VStoreMinPix = ' sprintf('%.3f',VStoreMinPix)];
    str_VStoreMin  = ['VStoreMin = ' sprintf('%.1f',VStoreMin)];
    str_VStoreMax  = ['VStoreMax = ' sprintf('%.1f',VStoreMax)];
    str_FamiliesFile = ['FamiliesFile = "' path_families_txt '"'];
    str_BulletinFile = ['BulletinFile = "' path_bulletin_txt '"'];
    str_FiltersFile  = ['FiltersFile = "' path_filters_ini '"'];
    str_PAZFile = ['PAZFile = ""'];
    str_ResultFile = ['ResultFile = "' path_result_txt '"'];
    str_NbSubNet   = ['NbSubNet = 1'];
    str_GeoSubNet  = ['GeoSubNet = {0,1,2}'];
    str_X          = ['X = 0.036009827,-0.008870619,-0.027139209'];
    str_Y          = ['Y = 0.034438304,-0.032707679,-0.001730625'];

    str_Bands      = ['Bands = 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14'];
    str_ThresholdLFamMin  = ['ThresholdLFamMin = ' num2str(ThresholdLFamMin)];
    str_ThresholdLFamMax  = ['ThresholdLFamMax = ' num2str(ThresholdLFamMax)];
    str_ThresholdDistance = ['ThresholdDistance = 1.0'];
    str_sigma_f = ['sigma_f = ' sprintf('%.5f',sigma_f)];
    str_sigma_v = ['sigma_v = ' sprintf('%.5f',sigma_v)];
    str_sigma_a = ['sigma_a = ' sprintf('%.5f',sigma_a)];
    str_OPTION         = ['OPTION = 1'];
    str_OPTION_speed   = ['OPTION_speed = 0'];
    str_OPTION_azimuth = ['OPTION_azimuth = 0'];
    str_Parabolic_interpolation  = ['Parabolic_interpolation = 1'];
    str_Apply_conversion = ['Apply_conversion= 0'];
    str_Apply_filter = ['Apply_filter = 0'];
    str_OLS_WLS = ['OLS_WLS = 0'];
    str_TSTA  = ['TSTA = 2'];
    str_TLTA  = ['TLTA = 10.0'];
    str_NLISS = ['NLISS = 10.0'];
    str_Threshold = ['Threshold = 4.0'];
    str_PowPond = ['PowPond = 0.5'];

    %=== write pmcc.ini
    fid = fopen(path_pmcc_ini,'w');
    fprintf(fid,'%s\n',str_PathVersion);
    fprintf(fid,'%s\n',str_Technology);
    fprintf(fid,'%s\n',str_Fe);
    fprintf(fid,'%s\n',str_Decim);
    fprintf(fid,'%s\n',str_OverSamplingRate );
    fprintf(fid,'%s\n',str_WindowLength);
    fprintf(fid,'%s\n',str_TimeStep);
    fprintf(fid,'%s\n',str_q);
    fprintf(fid,'%s\n',str_ThresholdConsistency);
    fprintf(fid,'%s\n',str_Pix_det_type);
    fprintf(fid,'%s\n',str_Compute_fstat);
    fprintf(fid,'%s\n',str_ThresholdFStatRatio);
    fprintf(fid,'%s\n',str_ThresholdNbSensors);
    fprintf(fid,'%s\n',str_NbSensors);
    fprintf(fid,'%s\n',str_NbFilters);
    fprintf(fid,'%s\n',str_NbCoeff);
    fprintf(fid,'%s\n',str_TypeFiles);
    fprintf(fid,'%s\n',str_PathStreams);
    fprintf(fid,'%s\n',str_Stations);
    fprintf(fid,'%s\n',str_Sensors);
    fprintf(fid,'%s\n',str_StartingDate);
    fprintf(fid,'%s\n',str_Length);
    fprintf(fid,'%s\n',str_StoreFam);
    fprintf(fid,'%s\n',str_StoreRes);
    fprintf(fid,'%s\n',str_StoreBul);
    fprintf(fid,'%s\n',str_VStoreMinPix);
    fprintf(fid,'%s\n',str_VStoreMin);
    fprintf(fid,'%s\n',str_VStoreMax);
    fprintf(fid,'%s\n',str_FamiliesFile);
    fprintf(fid,'%s\n',str_BulletinFile);
    fprintf(fid,'%s\n',str_FiltersFile);
    fprintf(fid,'%s\n',str_PAZFile);
    fprintf(fid,'%s\n',str_ResultFile);
    fprintf(fid,'%s\n',str_NbSubNet);
    fprintf(fid,'%s\n',str_X);
    fprintf(fid,'%s\n',str_Y);
    fprintf(fid,'%s\n',str_GeoSubNet);
    fprintf(fid,'%s\n',str_Bands);
    fprintf(fid,'%s\n',str_ThresholdDate);
    fprintf(fid,'%s\n',str_ThresholdLFamMin);
    fprintf(fid,'%s\n',str_ThresholdLFamMax);
    fprintf(fid,'%s\n',str_ThresholdDistance);
    fprintf(fid,'%s\n',str_sigma_t);
    fprintf(fid,'%s\n',str_sigma_f);
    fprintf(fid,'%s\n',str_sigma_v);
    fprintf(fid,'%s\n',str_sigma_a);
    fprintf(fid,'%s\n',str_OPTION);
    fprintf(fid,'%s\n',str_OPTION_speed);
    fprintf(fid,'%s\n',str_OPTION_azimuth);
    fprintf(fid,'%s\n',str_Parabolic_interpolation);   
    fprintf(fid,'%s\n',str_Apply_conversion);
    fprintf(fid,'%s\n',str_Apply_filter);
    fprintf(fid,'%s\n',str_OLS_WLS);
    fprintf(fid,'%s\n',str_TSTA);
    fprintf(fid,'%s\n',str_TLTA);
    fprintf(fid,'%s\n',str_NLISS);
    fprintf(fid,'%s\n',str_Threshold);
    fprintf(fid,'%s\n',str_PowPond);
    fclose(fid)

    %=== run PMCC
    try

        eval(['!' path_pmcc_exe ' ' path_pmcc_ini]);
    catch
        disp('pmcc error')
    end
    %=== for help pmcc.exe -V -h

    %pause
    
end   %=== times
