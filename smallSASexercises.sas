/*coursera protttest.sas*/


proc ttest data=stat1.german plots(shownull)=interval;
    class Group;
    var Pre;
    format Group $NoYes.;
    title "Two-Sample t-test GERMAN, No vs. Yes";
run;

title;




ods graphics;

ods select lsmeans diff diffplot controlplot;
proc glm data=STAT1.garlic 
         plots(only)=(diffplot(center) controlplot);
         
    class Fertilizer;
    model BulbWt=Fertilizer;
    lsmeans Fertilizer / pdiff=all 
                         adjust=tukey;
    lsmeans Fertilizer / pdiff=control('4') 
                         adjust=dunnett;

    title "Post-Hoc Analysis of ANOVA - Fertilizer as Predictor";
run;
quit;

title;


%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

ods graphics / reset=all imagemap;
proc corr data=STAT1.AmesHousing3 rank
          plots(only)=scatter(nvar=all ellipse=none);
   var &interval;
   with SalePrice;
   id PID;
   title "Correlations and Scatter Plots with SalePrice";
run;





%let VAR=Age Weight Height;
%let CIRC=Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;

ods graphics / reset=all imagemap;

proc corr data=STAT1.bodyfat2 rank
          plots(only)=scatter(nvar=all /*ellipse=none*/);
   var &VAR;
   *with SalePrice;
   *id PID;
   title "Correlations and Scatter Plots ";
run;


%let VAR=Age Weight Height;
%let CIRC=Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;

ods graphics / reset=all imagemap;

proc corr data=STAT1.bodyfat2 rank
          plots(only)=scatter(nvar=all /*ellipse=none*/);
   var &CIRC;
   with PctBodyFat2;
   *id PID;
   title "Correlations and Scatter Plots ";
run;




%let VAR=Age Weight Height;
%let CIRC=Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;

ods graphics / reset=all imagemap;

proc corr data=STAT1.bodyfat2 rank
          plots(only)=scatter(nvar=all /*ellipse=none*/)
          out=pearson best=5;
  
   var &CIRC &VAR;
   
   title "Correlations and Scatter Plots ";
run;




ods graphics;

proc reg data=STAT1.bodyfat2;
    model PctBodyFat2=Weight;
    title "Simple Regression with weight as regressor";
run;
quit;

title;










/*st103d01.sas*/  /*Part A*/
ods graphics off;
proc means data=STAT1.drug
           mean var std nway;
    class DrugDose Disease;
    var BloodP;
    format Disease ;
    title 'Selected Descriptive Statistics';
run;

/*st103d01.sas*/  /*Part B*/
proc sgplot data=STAT1.drug;
    vline DrugDose / group=Disease 
                        stat=mean 
                        response=BloodP 
                        markers;
    format Disease;
    */format DrugDose dosefmt.; 
    
run; 




ods graphics on;

proc glm data=STAT1.drug 
         order=internal 
         plots(only)=intplot;
    class DrugDose Disease;
    model BloodP = DrugDose Disease DrugDose*Disease;
    lsmeans DrugDose*Disease / diff slice=Disease;
    format Disease;
    store out=interact;
    title "Model with DrugDose & Disease as Interacting Predictors";
run;
quit;

/*st103d02.sas*/  /*Part B*/
proc plm restore=interact plots=all;
    slice DrugDose*Disease / sliceby=DrugDose adjust=tukey;
    effectplot interaction(sliceby=Disease) / clm;
run; 

title;





/*st103d03.sas*/  /*Part B*/
ods graphics on;
%let VAR=Age Weight Height;
%let CIRC=Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;

proc glm data=STAT1.bodyfat2 
         plots=all;
    */class Weight;
    model PctBodyFat2=Age Weight Height Neck Chest Abdomen Thigh  Wrist; */Hip Knee Ankle Biceps Forearm
    /*lsmeans Weight / pdiff=all 
                         adjust=tukey;
    /*lsmeans Weight / pdiff=control('4') 
                         adjust=dunnett;*/
    store out=multiple;
    title "BDYFAT Model w";
run;
quit;

/*st103d03.sas*/  /*Part C*/
proc plm restore=multiple plots=all;
    effectplot contour (x=PctBodyFat2 y=Weight);
    */effectplot slicefit(x=Weight sliceby=PctBodyFat2=250 to 1000 by 250);
run; 

title;

ods graphics off;
proc reg data=STAT1.BodyFat2;
    model PctBodyFat2=Age Weight Height
          Neck Abdomen Hip Thigh
          Ankle Biceps Forearm Wrist;
    title 'Regression of PctBodyFat2 on All '
          'Predictors';
run;
quit;


/*st104d01.sas*/
ods graphics on; 
%let VAR=Age Weight Height;
%let CIRC=Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
proc glmselect data=STAT1.BodyFat2 plots=all;
	STEPWISE: model PctBodyFat2 = &VAR &CIRC / selection=stepwise details=steps select=SL /*slstay=0.05 slentry=0.05*/;
	title "Stepwise Model Selection for SalePrice - SL 0.05";
run;





ods graphics on / imagemap=on;
%let VAR=Age Weight Height;
%let CIRC=Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
proc reg data=STAT1.BodyFat2 plots=all;
	model PctBodyFat2 = &VAR &CIRC / selection=cp best=60 ss1;
	title "Using Mallows Cp for Model Selection -- best 60";
run;


ods graphics on / imagemap=on;
%let VAR=Age Weight Height;
%let CIRC=Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
%let FAWW= Forearm Abdomen Wrist Weight;

proc reg 	data=STAT1.BodyFat2  
			plots(only)=(QQ RESIDUALBYPREDICTED RESIDUALS);
			model PctBodyFat2 = &FAWW ;
			title "residuals by the four regressors and by the predicted values, and a normal Q-Q plot";
run;





/* Using PROC REG to Generate Potential Outliers*/

ods graphics on / imagemap=on;
%let VAR=Age Weight Height;
%let CIRC=Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
%let FAWW= Forearm Abdomen Wrist Weight;
ods output RSTUDENTBYPREDICTED=Rstud 
           COOKSDPLOT=Cook
           DFFITSPLOT=Dffits 
           DFBETASPANEL=Dfbs;
           
proc reg data=STAT1.BodyFat2
	plots(only label)=
              (RSTUDENTBYPREDICTED 
               COOKSD 
               DFFITS 
               DFBETAS);
    model PctBodyFat2=&FAWW;
    title 'Regression of PctBodyFat2 on Abdomen, Weight, Wrist, and Forearm';
run;
quit;

data influential;
/*  Merge datasets from above.*/
    merge Rstud
          Cook 
          Dffits
		  Dfbs;
    by observation;
    
/*  Flag observations that have exceeded at least one cutpoint;*/
    if (ABS(Rstudent)>3) or (Cooksdlabel ne ' ') or Dffitsout then flag=1;
    array dfbetas{*} _dfbetasout: ;
    do i=2 to dim(dfbetas);
         if dfbetas{i} then flag=1;
    end;

/*  Set to missing values of influence statistics for those*/
/*  that have not exceeded cutpoints;*/
    if ABS(Rstudent)<=3 then RStudent=.;
    if Cooksdlabel eq ' ' then CooksD=.;

/*  Subset only observations that have been flagged.*/
    if flag=1;
    drop i flag;
run;

title;
proc print data=influential;
    id observation;
    var Rstudent CooksD Dffitsout _dfbetasout:; 
run;



/*st105d03.sas*/  /*Part B*/
%let VAR=Age Weight Height;
%let CIRC=Neck Chest Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist;
proc reg data=STAT1.BodyFat2 plots=all;
    model PctBodyFat2 = &VAR &CIRC / vif;
    title 'Collinearity Diagnostics';
run;
quit;




/*Building a Predictive Model Using PROC GLMSELECT*/

%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
         Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
         Masonry_Veneer Lot_Shape_2 Central_Air;

ods graphics;

proc glmselect data=STAT1.ameshousing3 seed=8675309
               plots=all ;
               /*valdata=STAT1.ameshousing4;*/
    class &categorical / param=glm ref=first;
    model SalePrice=&categorical &interval / 
               selection=stepwise
               select=aic  /*Akaike's information criterion (AIC) */
               choose=validate;
    partition fraction (validate=0.33);
    store out=STAT1.amesstore;
    title "stepwise regression as the selection method, Akaike's information criterion (AIC) to add and or remove effects, and average squared error for the validation data to select the best model. Add the REF=FIRST option in the CLASS statement";
run;





/* Scoring Using the SCORE Statement in PROC GLMSELECT*/
proc glmselect data=STAT1.ameshousing3
               seed=8675309
               noprint;
   class &categorical / param=ref ref=first;
   model SalePrice=&categorical &interval / 
               selection=stepwise
               (select=aic 
               choose=validate) hierarchy=single;
   partition fraction(validate=0.3333);
   store out=STAT1.store1;
   score data=stat1.ameshousing4 out=STAT1.scored1;
run;


proc plm restore=STAT1.store1;
    score data=STAT1.ameshousing4 out=STAT1.scored2;
    code file="&homefolder\scoring.sas";
run;

/*
data scored2;
    set STAT1.ameshousing4;
    %include "&homefolder\scoring.sas";
run;

data scored1;
    set STAT1.ameshousing4;
    %include "&homefolder\scoring.sas";
run;
*/

proc compare base=STAT1.scored1 compare=STAT1.scored2 criterion=0.0001;
    var p_Saleprice;
    with Predicted;
run;





/*st107d01.sas*/

proc freq data=stat1.safety;
	tables Unsafe Type Region Size Weight Type*Unsafe Region*Unsafe Size*Unsafe Weight*Unsafe Region*weight*unsafe/
           plots(only)=freqplot(scale=percent) ;
	format Unsafe;

run;
title;



/*st107d03.sas*/

proc freq data=stat1.safety;
	tables Unsafe Region Region*Unsafe /
           plots(only)=freqplot(scale=percent)  chisq measures cl;
	format Unsafe;

run;
title;



/*st107d03.sas*/

proc freq data=stat1.safety;
	tables Unsafe Size Size*Unsafe /
           chisq measures cl;
	format Unsafe;

run;
title;




/*st107d04.sas*/
ods graphics on;
proc logistic data=stat1.safety alpha=0.05
              plots(only)=(effect oddsratio);
      
    model Unsafe(event='1')=Weight / clodds=pl;
    title 'LOGISTIC MODEL (1):usafe=weight';
run;


/*st107d05.sas*/
ods graphics on;
proc logistic data=stat1.titanic plots(only)=(effect oddsratio);
    class  Age (ref='child') / param=ref;
    model Survived(event='1')=Age Sex Class / clodds=pl;
    units age=10;
    title 'LOGISTIC MODEL (2):Survived= sex class age';
run;



/*st107d05.sas*/
ods graphics on;
proc logistic data=stat1.safety alpha=0.05
              plots(only)=(effect oddsratio);
    class Region (ref='Asia') Size (ref='1') / param=ref;
    model Unsafe(event='1')=Weight Size Region / clodds=pl;
    title 'LOGISTIC MODEL (2):Unsafe=weight size region';
run;



/*st107d07.sas*/

ods select none;
proc logistic data=STAT1.ameshousing3;
    class Fireplaces(ref='0') Lot_Shape_2(ref='Regular') / param=ref;
    model Bonus(event='1')=Basement_Area|Lot_Shape_2 Fireplaces;
    units Basement_Area=100;
	store out=isbonus;
run;
ods select all;


data newhouses;
	length Lot_Shape_2 $9;
	input Fireplaces Lot_Shape_2 $ Basement_Area;
	datalines;
	0  Regular    1060
	2  Regular     775
	2  Irregular  1100
	1  Irregular   975
	1  Regular     800
	;
run;

proc plm restore=isbonus;
	score data=newhouses out=scored_houses / ILINK;
	title 'Predictions using PROC PLM';
run;

proc print data=scored_houses;
run;






ods graphics on;
proc logistic data=stat1.safety plots(only)=(effect oddsratio);
    class Region (param=ref ref='Asia')
	      Size (param=ref ref='Small');
    model Unsafe(event='1')=Weight|Size|Region
    /selection=backward clodds=pl ;
    units Weight=-1;
	store out=isSafe;
	format Size sizefmt.;
	title 'Logistic Model: Backwards Elimination';
run;
data checkSafety;
   length Region $9.;
   input Weight Size Region $ 5-13;
   datalines;
   4 1 N America
   3 1 Asia     
   5 3 Asia     
   5 2 N America
	 ;
run;
proc plm restore=isSafe;
	score data=checkSafety out=scored_checkSafety / ILINK;
	title 'Predictions using PROC PLM';
run;

proc print data=scored_checkSafety;
run;
