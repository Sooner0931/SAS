* ALL BASE PROGRAM:;

* 1. LIST REPORT;
proc print data=clinic.admit;
        var age height weight fee;
     run;

proc print data=work.example noobs;
        var age height weight fee;
     run;

proc print data=sales.reps;
        id idnum lastname;
     run;

proc print data=sales.reps;
        id idnum lastname;
        var idnum sex jobcode salary;
     run;

proc print data=clinic.admit;
        var age height weight fee;
        where age>30;
     run;

proc sort data=clinic.admit out=work.wgtadmit;
        by weight age;
     run;

proc sort data=clinic.admit out=work.wgtadmit;
        by descending weight age;
     run;


proc print data=clinic.insure;
        var name policy balancedue;
        where pctinsured < 100;
        sum balancedue;
     run;

proc sort data=clinic.admit out=work.activity;
        by actlevel;
     run;
proc print data=work.activity;
        var age height weight fee;
        where age>30;
        sum fee;
        by actlevel;
     run;

 proc sort data=clinic.admit out=work.activity;
        by actlevel;
     run;
 proc print data=work.activity;
        var age height weight fee;
        where age>30;
        sum fee;
        by actlevel;
        id actlevel;
     run;

proc sort data=clinic.admit out=work.activity;
        by actlevel;
     run;
proc print data=work.activity;
        var age height weight fee;
        where age>30;
        sum fee;
        by actlevel;
        id actlevel;
        pageby actlevel;
     run;

proc print data=clinic.stress double;   * DOUBLE SPACING;
        var resthr maxhr rechr;
        where tolerance='I';
     run;

title1 'Heart Rates for Patients with';
title3 'Increased Stress Tolerance Levels';
footnote1 'Data from Treadmill Tests';
footnote3 '1st Quarter Admissions';
proc print data=clinic.stress;
        var resthr maxhr rechr;
        where tolerance='I';
     run;

title1;                                  * CANCELING ALL TITLES;
footnote1 'Data from Treadmill Tests';
footnote3 '1st Quarter Admissions';
proc print data=clinic.stress;
        var resthr maxhr rechr;
        where tolerance='I';
     run;
footnote;                                * CANCELING ALL FOOTNOYES;
proc tabulate data=clinic.stress;
        var timemin timesec;
        table max*(timemin timesec);
     run;

proc print data=clinic.therapy label;
   label walkjogrun='Walk/Jog/Run';
run;

proc print data=clinic.admit label;
        var actlevel height weight;
        label actlevel='Activity Level'
               height='Height in Inches'
               weight='Weight in Pounds';
     run;

proc print data=clinic.admit;          * TEMPORARY FORAMTTING IN PROC STEP;
        var actlevel fee;
        where actlevel='HIGH';
        format fee dollar4.;
     run;

data flights.march;                     * PERMANENT FORAMTTING IN DATA STEP;
        set flights.mar01;
        label date='Departure Date';
        format date date9.;
     run;

proc format;                           * USER-DEFINED FORAMT;
        value $repfmt
              'TFB'='Bynum'
              'MDC'='Crowley'
              'WKK'='King';
proc print data=vcrsales;
        var salesrep type unitsold;
        format salesrep $repfmt.;
     run;



* 2. CREATING SAS DATA FROM RAW DATA;
* Column Input;

 filename exer 'c:\users\exer.dat';
 data exercise;
        infile exer;
        input ID $ 1-4 Age 6-7 ActLevel $ 9-12 Sex $ 14;
     run;

data sasuser.stress;        
       infile tests obs=10;  
       input ID 1-4 Name $ 6-25 
             RestHR 27-29 MaxHR 31-33        
             RecHR 35-37 TimeMin 39-40 
             TimeSec 42-43 Tolerance $ 45;       
    run;

data sasuser.stress;                   * DEFINING A NEW VAR;
       infile tests;
       input ID 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       TotalTime=(timemin*60)+timesec;
    run;

data sasuser.stress;                   * RE-DEFINING AN EXISTING VAR;
       infile tests;
       input ID 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       resthr=resthr+(resthr*.10);
    run;

data sasuser.stress;                   * ASSIGNING A DATE VALUE IN A FORM OF "ddmmmyyyy"d;
       infile tests;
       input ID 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       TotalTime=(timemin*60)+timesec;
       TestDate='01jan2000'd;
    run;

* Time='9:25't;
* DateTime='18jan2005:9:27:05'dt;

data sasuser.stress;                    * SUBSETTING UISNG if;
       infile tests;
       input ID 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       if tolerance='D';
       TotalTime=(timemin*60)+timesec;
    run;

data sasuser.stress;                   * INPUT IN-STREAM DATA;
       input ID 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       if tolerance='D';
       TotalTime=(timemin*60)+timesec;
       datalines;
     2458 Murray, W            72  185 128 12 38 D
     2462 Almers, C            68  171 133 10  5 I
     2501 Bonaventure, T       78  177 139 11 13 I
     2523 Johnson, R           69  162 114  9 42 S
     2539 LaMance, K           75  168 141 11 46 D
     ;

data _null_;               * WRITING SAS DATASET TO EXTERNAL FILE;
       set sasuser.stress;
       file 'c:\clinic\patients\stress.txt';
       put id 1-4 name  6-25 resthr 27-29 maxhr 31-33
             rechr 35-37 timemin 39-40 timesec 42-43
             tolerance 45 totaltime 47-49;
    run;

data work.test;            * DEBUGGING USING "PUT" TO CHECK DATA ERRORS;
        infile loan;
        input Code $ 1 Amount 3-10 Rate 12-16
              Account $ 18-25 Months 27-28;
        if code='1' then type='variable';
        else if code='2' then type='fixed';
        else put 'MY NOTE: invalid value: '
             code=;
     run;
data finance.newcalc;      * DEBUGGING USING "PUT" TO CHECK DATA ERRORS;
        infile newloans;
        input LoanID $ 1-4 Rate 5-8 Amount 9-19;
        if rate>0 then
           Interest=amount*(rate/12);
        else put 'DATA ERROR ' rate= _n_=;
     run;


* 3. USER-DEFINED FORMATS;
libname MyFormat 'C:\Users\wangbo01-pxb\Desktop\Format';
proc format library=MyFormat;        * NUMERIC CODING;
        value jobfmt
              103='manager'
              105='text processor'
              111='assoc. technical writer'
              112='technical writer'
              113='senior technical writer';
     run;

proc format lib=MyFormat;            * CHARACTER CODING;
        value $grade
              'A'='Good'
              'B'-'D'='Fair'
              'F'='Poor'
              'I','U'='See Instructor';
     run;

proc format lib=MyFormat;              * RANGE CODING 1;
        value agefmt
              0-<12='child'
              12-<20='teenager'
              20-<65='adult'
              65-100='senior citizen';
     run;
proc format lib=MyFormat;              * RANGE CODING 2;
        value agefmt
              low-<12='child'
              12-<20='teenager'
              20-<65='adult'
              65-high='senior citizen'
              other='unknown';
     run;

proc format lib=MyFormat;             * MULTIPLE FORMATS IN A SINGLE FORMAT PROCEDURE;
        value jobfmt
              103='manager'
              105='text processor'
              111='assoc. technical writer'
              112='technical writer'
              113='senior technical writer';
        value $respnse
              'Y'='Yes'
              'N'='No'
              'U'='Undecided'
              'NOP'='No opinion';
     run;

libname MyFormat 'C:\Users\wangbo01-pxb\Desktop\Format';   * APPLY USER-DEFINED FORMAT TO DATASET;
data perm.empinfo;
        infile empdata;
        input @9 FirstName $5. @1 LastName $7. +7 JobTitle 3.
              @19 Salary comma9.;
        format salary comma9.2 jobtitle jobfmt.;
     run;

libname MyFormat 'C:\Users\wangbo01-pxb\Desktop\Format';
proc format library=MyFormat fmtlib;                     * CHECK ALL FORMATS DEFINED IN A LIB;
     run;


* 4. PROC REPORT;
 proc report data=flights.europe nowd;
     run;

proc report data=flights.europe nowd;
        column flight orig dest mail freight revenue;
     run;

 proc report data=flights.europe nowd;
        column flight orig dest mail freight revenue;
        where dest in ('LON','PAR'); 
     run;

proc report data=flights.europe nowd;               * WIDTH IS FOR VAR HEADINGS, SPACING IS FOR SPACE BETWEEN VARS;
        where dest in ('LON','PAR'); 
        column flight orig dest mail freight revenue;
        define flight / order descending 'Flight Number' 
                        center width=6 spacing=5; 
        define orig / 'Flight Origin' center width=6;
		define revenue / format=dollar15.2;
     run;

proc report data=flights.europe nowd;
        where dest in ('LON','PAR'); 
        column flight orig dest mail freight revenue;
        define revenue / format=dollar15.2;
        define flight / width=13 'Flight Number';
        define orig / width=13 spacing=5 'Flight Origin';
        define dest / width=18 spacing=5 'Flight Destination';
     run;

proc report data=flights.europe nowd;                 * USING DEFULT "/" TO BREAK HEADINGS INTO MULTIPLE LINES;
        where dest in ('LON','PAR');
        column flight orig dest mail freight revenue;
        define revenue / format=dollar15.2;
        define flight / width=6 'Flight/Number';
        define orig / width=6 spacing=5 'Flight/Origin';
        define dest / width=11 spacing=5 'Flight/Destination';
     run;

proc report data=flights.europe nowd split='*';      * USING OTHER DLM (HERE "*") TO BREAK HEADINGS INTO MULTIPLE LINES;
        where dest in ('LON','PAR');
        column flight orig dest mail freight revenue;
        define revenue / format=dollar15.2;
        define flight / width=6 'Flight*Number';
        define orig / width=6 spacing=5 'Flight*Origin';
        define dest / width=11 spacing=5 'Flight*Destination';
     run;

 proc report data=flights.europe nowd;               * COLUMN JUSTIFICATION SPECIFICATION;
        where dest in ('LON','PAR'); 
        column flight orig dest mail freight revenue;
        define revenue / format=dollar15.2;
        define flight / width=6 'Flight/Number' center;
        define orig / width=6 spacing=5 'Flight/Origin' center;
        define dest / width=11 spacing=5 'Flight/Destination' center;
     run;

 proc report data=flights.europe nowd headline headskip;   * HEADLINE AND HEADSKIP;
        where dest in ('LON','PAR');
        column flight orig dest mail freight revenue;
        define revenue / format=dollar15.2;
        define flight / width=6 'Flight/Number' center;
        define orig / width=6 spacing=5 'Flight/Origin' center;
        define dest / width=11 spacing=5 'Flight/Destination' center;
     run;

proc report data=flights.europe nowd headline headskip;    * USING ORDER OPTION TO GROUP IN A GRANULATED MANNER;
        where dest in ('LON','PAR'); 
        column flight orig dest mail freight revenue;
        define revenue / format=dollar15.2;
        define flight / order 'Flight/Number' width=6 center;
        define orig / width=6 spacing=5 'Flight/Origin' center;
        define dest / width=11 spacing=5 'Flight/Destination' 
                      center;
     run;

proc report data=flights.europe nowd headline headskip;    * USING ORDER OPTION TO GROUP IN A AGGREGATED MANNER, BUT IT PRODUCED THE SAME OUTPUT AS ABOVE;
        where dest in ('LON','PAR');
        column flight orig dest mail freight revenue;
        define revenue / format=dollar15.2;
        define flight / group 'Flight/Number' width=6 center;
        define orig / width=6 spacing=5 'Flight/Origin' center;
        define dest / width=11 spacing=5 'Flight/Destination'
                      center;
     run;

proc report data=flights.europe nowd headline headskip;     * USING ORDER OPTION TO GROUP IN A AGGREGATED MANNER;
        where dest in ('LON','PAR'); 
        column flight orig dest mail freight revenue;
        define revenue / format=dollar15.2;
        define flight / group 'Flight/Number' width=6 center;
        define orig / group width=6 spacing=5 'Flight/Origin' 
                      center;
        define dest / group width=11 spacing=5 
                     'Flight/Destination' center;
     run;

proc report data=flights.europe nowd headline headskip;     * CHOOSING THE SUMARRY STAT TO REPORT (HERE mean);
        where dest in ('LON','PAR'); 
        column flight orig dest mail freight revenue;
        define revenue / mean format=dollar15.2               
                         'Average/Revenue';
        define flight / group 'Flight/Number' width=6 center;
        define orig / group width=6 spacing=5 'Flight/Origin' 
                      center;
        define dest / group width=11 spacing=5 
                     'Flight/Destination' center;
     run;

 proc report data=flights.europe nowd;                      * CREATING NEW VAR (HERE emptyseats);
        where dest in ('LON','PAR'); 
        column flight capacity deplaned emptyseats;
        define flight / width=6;
        define emptyseats / computed 'Empty Seats';
        compute emptyseats;
           emptyseats=capacity.sum-deplaned.sum;
        endcomp;
     run;

* 5. PROC MEANS/ SUMMARY/ FREQ;
proc means data=perm.survey median range;
     run;

proc means data=clinic.diabetes min max maxdec=2;
     run;

proc means data=perm.survey mean stderr maxdec=2;
        var item1-item5;
     run;

proc means data=clinic.heart maxdec=1;          * CLASS IS AS SAME AS SORT+BY;
        var arterial heart cardiac urinary;
        class survive sex;
     run;

proc sort data=clinic.heart out=work.heartsort;
             by survive sex;
          run;
proc means data=work.heartsort maxdec=1;
             var arterial heart cardiac urinary;
             by survive sex;
          run;

proc means data=clinic.diabetes;
        var age height weight;
        class sex;
        output out=work.sum_gender
           mean=AvgAge AvgHeight AvgWeight
           min=MinAge MinHeight MinWeight;
     run;

proc summary data=clinic.diabetes;               * NO REPORTS PRINTED;
        var age height weight;
        class sex;
        output out=work.sum_gender
           mean=AvgAge AvgHeight AvgWeight;
     run; 

proc summary data=clinic.diabetes print;         * REPORTS PRINTED;
        var age height weight;
        class sex;
        output out=work.sum_gender
           mean=AvgAge AvgHeight AvgWeight;
     run; 
 
proc freq data=perm.survey;                      * ONE WAY FREQ;
        tables item1-item3;
     run;

proc format;                                     * TWO WAY FREQ;
        value wtfmt low-139='< 140'
                    140-180='140-180'
                    181-high='> 180';
        value htfmt low-64='< 5''5"'
                    65-70='5''5-10"'
                    71-high='> 5''10"';
     run;
proc freq data=clinic.diabetes;                  
        tables weight*height;
        format weight wtfmt. height htfmt.;
     run;

proc format;                                    * N WAY FREQ;
        value wtfmt low-139='< 140'
                    140-180='140-180'
                    181-high='> 180';
        value htfmt low-64='< 5''5"'
                    65-70='5''5-10"'
                    71-high='> 5''10"';
     run;
proc freq data=clinic.diabetes;
        tables sex*weight*height;
        format weight wtfmt. height htfmt.;
     run;

proc freq data=clinic.diabetes;                 * PRINT IN LIST OPTION;
        tables sex*weight*height / LIST;
        format weight wtfmt. height htfmt.;
     run;

proc format;                                    * SUPPRESSING;
        value wtfmt low-139='< 140'
                    140-180='140-180'
                    181-high='> 180';
     run;
proc freq data=clinic.diabetes;
        tables sex*weight / nofreq norow nocol;
        format weight wtfmt.;
     run;


* 6. ODS;
ods listing close;
ods html body='c:\mydata.html';
proc print data=sasuser.mydata;
     run;
ods html close;
ods listing;

ods html file='HTML-file-pathname';
ods pdf file='PDF-file-pathname';
proc print data=sasuser.admit;
     run;
proc tabulate data=clinic.stress2;
         var resthr maxhr rechr;
         table min mean, resthr maxhr rechr;
      run;
ods _all_ close;
ods listing;

ods listing close;
ods html body='c:\records\data.html'
         contents='c:\records\toc.html'
         frame='c:\records\frame.html';
proc print data=clinic.admit label;
         var id sex age height weight actlevel;
         label actlevel='Activity Level';
      run;
proc print data=clinic.stress2;
         var id resthr maxhr rechr;
      run;
ods html close;
ods listing;

* 7. PROC TABULATE;
proc tabulate data= ;  * ONE DIMENSIONAL;
      table type;
proc tabulate data= ;  * STILL ONE DIMENSIONAL;
      table type premium;

proc tabulate data= ;  * 2 DIMENSIONAL: Notice the comma that separates the dimensions;
      table type, premium; * Two-dimensional tables always have row and column headings, one-dimensional tables have only column headings;

proc tabulate data= ;  * 3 DIMENSIONAL;
table type,premium,sum;

proc tabulate data=clinic.diabstat;
        class type sex;
        var totalclaim premium;
        table type,premium;
        table type;
        table sex,totalclaim,type;
     run;

proc tabulate data=clinic.admit;   * REQUESTING SUMMARY STAT BY '*' ;
        var fee;
        table fee*mean;
     run;

proc tabulate data=clinic.admit;
        class sex actlevel;
        table sex*pctn actlevel*n;
     run;

proc tabulate data=clinic.admit;
        class actlevel;
        var height weight;
        table height*mean weight*max,actlevel;
     run;

 proc tabulate data=clinic.admit;
        class sex actlevel;
        var height weight;
        table height*mean weight*max,actlevel;
        table sex*pctn actlevel*n;
     run;

proc tabulate data=clinic.admit;     * SELECTING OBS BASED ON CONDITIONS;
        class sex;
        var height weight; 
        table sex,height*min weight*max;
        where sex='F';
     run;

proc tabulate data=clinic.admit;     * CREATING SUMMARY ROWS; 
        var fee;
        class sex;
        table sex all,fee;
     run;

 proc tabulate data=clinic.admit;    * CREATING SUMMARY COLUNMS; 
        class sex;
        table sex all;
     run;

proc tabulate data=sasuser.therapy;  * LABEL/TITLE/FOOTNOTE; 
     var walkjogrun swim;
     table walkjogrun swim;
     title1 'Attendance in Exercise Therapies';
     footnote1 'September 30, 2002';
     label walkjogrun='Walk/Jog/Run';
run;

 proc tabulate data=clinic.admit;    * KEYLABEL TO ALTER THE OUTPUT OF VAR NAMES; 
        class sex;
        var height weight;
        table (height weight)*mean,sex all;
        label sex='Sex of Patient'
              height='Height'
              weight='Weight';
        keylabel mean='Average'
                 all='All Patients';
     run;

proc tabulate data=clinic.admit format=6.; * SPECIFYING FORMAT IN OPTIONS;
        class actlevel;
        var fee;
        table actlevel all,fee;
     run;

proc tabulate data=clinic.admit;           * 3 DIMENSIONAL TABLE;
        class sex actlevel;
        var height weight;
        table actlevel,sex,height*min weight*min;
     run;

 proc tabulate data=clinic.admit;          * 1 DIMENSIONAL TABLE;
        var height weight;
        table height*min weight*min;
     run;

* 8. CREATE & MODIFY VARS;
data clinic.stress;
       infile tests;
       input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       TotalTime=(timemin*60)+timesec;
       retain SumSec 5400;
       sumsec+totaltime;
    run;

data clinic.stress;
       infile tests;
       input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       TotalTime=(timemin*60)+timesec;
       retain SumSec 5400;
       sumsec+totaltime;
       if totaltime>800 then TestLength='Long';
       else if 750<=totaltime<=800 then TestLength='Normal';
       else if totaltime<750 then TestLength='Short';
    run;

 data clinic.stress;
       infile tests;
       input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       TotalTime=(timemin*60)+timesec;
       retain SumSec 5400;
       sumsec+totaltime;
       if totaltime>800 then TestLength='Long';
       else if 750<=totaltime<=800 then TestLength='Normal';
       else put 'NOTE: Check this Length: 'totaltime=;
    run;

 data clinic.stress;                  
       infile tests;
       input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       TotalTime=(timemin*60)+timesec;
       retain SumSec 5400;
       sumsec+totaltime;
       length TestLength $ 6;                               * MODIFY WITH LENGTH STATEMENT TO ACCOMMODATE VAR LENGHT;
       if totaltime>800 then testlength='Long';
       else if 750<=totaltime<=800 then testlength='Normal';
       else if totaltime<750 then TestLength='Short';
    run;

data clinic.stress;                                        * SUBSETTING AND DELETE USING IF;
       infile tests;
       input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       if resthr<70 then delete;                           * SUBSETTING AND DELETE USING IF;
       TotalTime=(timemin*60)+timesec;
       retain SumSec 5400;
       sumsec+totaltime;
       length TestLength $ 6;
       if totaltime>800 then testlength='Long';
       else if 750<=totaltime<=800 then testlength='Normal';
       else if totaltime<750 then TestLength='Short';
    run;

data sasuser.sales(keep=month cumtotal);
data sasuser.sales(drop=lastname residential commercial total);  
     * Alternately, you can add one of these statements within a data step;
keep month cumtotal;
drop lastname residential commercial total;
;

* PERMANENT FORMATTING AND LABEL IN DATA STEP;
data sasuser.sales;
   infile saledata;
   input LastName $ 1-7 Month $ 9-11
         Residential 13-21 Commercial 23-31;
   format residential commercial dollar12.2;
   label month='Month of 1999';
run;
proc print data=sasuser.sales label;
run;

 data emps(keep=salary group);                         * SELECT WHEN;
        set sasuser.payrollmaster;
        length Group $ 20;
        select(jobcode);
           when ("FA1") group="Flight Attendant I";
           when ("FA2") group="Flight Attendant II";
           when ("FA3") group="Flight Attendant III";
           when ("ME1") group="Mechanic I";
           when ("ME2") group="Mechanic II";
           when ("ME3") group="Mechanic III";
           when ("NA1") group="Navigator I";
           when ("NA2") group="Navigator II";
           when ("NA3") group="Navigator III";
           when ("NA1") group="Navigator I";
           when ("NA2") group="Navigator II";
           when ("NA3") group="Navigator III";
           when ("PT1") group="Pilot I";
           when ("PT2") group="Pilot II";
           when ("PT3") group="Pilot III";
           when ("TA1","TA2","TA3") group="Ticket Agents";
           otherwise group="Other";
        end;
     run;

data clinic.stress;                                            * DO GROUP;
       infile tests;
       input ID $ 1-4 Name $ 6-25 RestHR 27-29 MaxHR 31-33
             RecHR 35-37 TimeMin 39-40 TimeSec 42-43
             Tolerance $ 45;
       TotalTime=(timemin*60)+timesec;
       retain SumSec 5400;
       sumsec+totaltime;
       length TestLength $ 6 Message $ 20;
       if totaltime>800 then 
          do;
             testlength='Long';
             message='Run blood panel';
          end;
       else if 750<=totaltime<=800 then testlength='Normal';
       else if totaltime<750 then TestLength='Short';
    run;

data payroll;
        set salaries;
        select(payclass);
        when ('monthly') amt=salary;
        when ('hourly')
           do;
              amt=hrlywage*min(hrs,40);
              if hrs>40 then put 'CHECK TIMECARD'; 
           end;     
        otherwise put 'PROBLEM OBSERVATION';
        end;       
     run;

* 9. READING SAS DATASETS;
proc sort data=company.usa out=work.temp;
        by dept;
     run;
data company.budget(keep=dept payroll);          * SET + By;
      set work.temp;
      by dept; 
        if wagecat='S' then Yearly=wagerate*12;
        else if wagecat='H' then Yearly=wagerate*2000; 
        if first.dept then Payroll=0;            * first.var_name;          
        payroll+yearly;               
        if last.dept;                            * last.var_name;
     run;

data work.getobs5;                              * READING OBS USING DIRECT ACCESS, THO THIS CODE GENERATE A continuous looping DUE TO NO END OF FILE MARKER;
        obsnum=5;
        set company.usa(keep=manager payroll) point=obsnum;
     run;
data work.getobs5(drop=obsnum);
        obsnum=5;
        set company.usa(keep=manager payroll) point=obsnum;
        stop;                                   * THIS STOP QUIT THE LOOP, BUT STILL NO OUTPUT;
     run;
data work.getobs5(drop=obsnum);
        obsnum=5;
        set company.usa(keep=manager payroll) point=obsnum;
        output;                                 * THE OUTPUT STATEMENT MAKES THE CODE WORK AS EXPECTED;
        stop;
     run;

data work.addtoend(drop=timemin timesec);
        set clinic.stress2(keep=timemin timesec) end=last;             * READ THE END OBS OF A FILE;
        TotalMin+timemin;
        TotalSec+timesec;
        TotalTime=totalmin*60+timesec;
        if last;                                
     run;

* 10. COMBINING SAS DATASETS;
data one2one;                                * ONE-ONE READING;
        set c;
        set d;
     run;
data clinic.one2one;
        set clinic.patients;
        if age<60;
        set clinic.measure;
     run;

data concat;                                * CONCATENATING;
        set a c;
     run;

data interlv;                               * INTERLEAVINGL;
        set c d;
        by num;
     run;

data merged;                                * MERGE-MATCHING;
        merge a b;
        by num;
     run;

data clinic.merged;       
        merge clinic.demog(rename=(date=BirthDate))
              clinic.visit(rename=(date=VisitDate)); 
        by id;
     run;

data clinic.merged;                         * USING IN= TO CHECK IF OBS CONTRIBUTE TO TARGETING DATASET; 
        merge clinic.demog(in=indemog) 
              clinic.visit(in=invisit
                           rename=(date=BirthDate));
        by id;
		if indemog=1 and invisit=1;
     run;

* 11. SQL;
proc sql;
        select empid,jobcode,salary,
               salary*.06 as bonus
           from sasuser.payrollmaster
           where salary<32000
           order by jobcode;
     quit;

proc sql;                                   * QUERY MULTIPLE TABLES;
        select salcomps.empid,lastname,
               newsals.salary,newsalary
           from sasuser.salcomps,sasuser.newsals
           where salcomps.empid=newsals.empid
           order by lastname;
quit;

proc sql;                                   * GROUP-WISE SUMMARY STATS;
   select sex, avg(age) as AverageAge,
          avg(weight) as AverageWeight
      from sasuser.diabetes
      group by sex
	  order by xxx;
quit;

proc sql;                                   * CREATING TABLES;
        create table work.miles as
           select membertype,
                  sum(milestraveled) as TotalMiles
              from sasuser.frequentflyers
              group by membertype;
quit;
      
* 11. SAS FUNCTIONS;
data hrd.newtemp;                           * INPUT FUNCTION;
        set hrd.temp;
        Salary=input(payrate,2.)*hours;
     run;

 data hrd.newtemp;                          * PUT FUNCTION;
        set hrd.temp;
        Assignment=put(site,2.)||'/'||dept;
     run;

data hrd.nov99;                             * YEAR();
        set hrd.temp;
        if year(startdate)=1999 and month(startdate)=11;
     run;

data hrd.newtemp(drop=month day year);      * MDY();
        set hrd.temp;
		DateCons=mdy(6,17,2002);
        Date=mdy(month,day,year);
		format date date9.;
     run;

DATA A;
INPUT X @@;
CARDS;
1 2 3 4 5 6
;
RUN;

DATA B;
SET A;
Years=intck('year','15jun1999'd,'15jun2001'd);
NewDate=intnx('day','02apr02'd,-1);
FORMAT NewDate DATE9.;
RUN;

data hrd.newtemp(drop=name);                  * SCAN();
        set hrd.temp;
        LastName=scan(name,1);
        FirstName=scan(name,2);
        MiddleName=scan(name,3);
     run;

data work.newtemp(drop=middlename);           * SUBSTR();
        set hrd.newtemp;
        MiddleInitial=substr(middlename,1,1);
     run;

data hrd.temp2;                               * REPLACING SUBSTR;
        set hrd.temp;
        substr(phone,1,3)='433';
     run;

 data hrd.newtemp(drop=address city state zip);   * TRIM();
        set hrd.temp;
        NewAddress=trim(address)||', '||trim(city)||', '||zip;
     run;

data hrd.datapool;                               * INDEX() USED AS AN OBS DETECTOR FOR SUBSETTING;
        set hrd.temp;
        if index(job,'word processing') > 0;
     run;

 data hrd.newtemp;                               * UPCASE();
        set hrd.temp;
        Job=upcase(job);
     run;

data work.after;                                * TRANWRD();
        set work.before;
        name=tranwrd(name,'Miss','Ms.');
        name=tranwrd(name,'Mrs.','Ms.');
     run;

data work.after;                                * INT();
   set work.before;
   Examples=int(examples);
run;

data work.after;                                * ROUND();
   set work.before;
   Examples=round(examples,.2);
run;

* 12. DO LOOPS;
 data finance.earnings;
        set finance.master;
        Earned=0;
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
        earned+(amount+earned)*(rate/12);
     run;
data finance.earnings;
        set finance.master;
        Earned=0;
        do count=1 to 12;
           earned+(amount+earned)*(rate/12);
        end;
     run;

 data work.earn_1 (drop=counter);
        Value=2000;
        do counter=1 to 20;
           Interest=value*.075;
           value+interest;
           Year+1;
        end;
     run;
 data work.earn_2;
        Value=2000;
        do Year=1 to 20;
            Interest=value*.075;
            value+interest;
            output;
         end;
     run; 
  
data work.earn;
        Capital=2000;
        do month=1 to 12;
           Interest=capital*(.075/12);
           capital+interest;
        end;
     run;
data work.earn;
        do year=1 to 20; 
           Capital+2000;             
           do month=1 to 12;         
              Interest=capital*(.075/12); 
              capital+interest;      
           end;                      
        end;             
     run;

data work.compare(drop=i);
      set finance.cdrates;
      Investment=5000;
      do i=1 to years;                   * ITERATION TO AN EXISTING VAR;
         investment+rate*investment;
      end;
   run;

   data work.invest;                    * DO UNTIL;
        do until(Capital>=50000);
           capital+2000;
           capital+capital*.10;
           Year+1;
        end;
     run;

data work.invest;                       * DO WHILE;
        do while(Capital>=50000);
           capital+2000;
           capital+capital*.10;
           Year+1;
        end;
     run;

data work.subset;                       * CREATING A SAMPLE DATASET WITH RATE 0.1;
        do sample=10 to 5000 by 10;
           set factory.widgets point=sample;
           output;
        end;
        stop;
     run;

* 12. ARRAYS;
data work.report(drop=i);
        set master.temps;
        array daytemp{365} day1-day365;
        do i=1 to 365;
           daytemp{i}=5*(daytemp{i}-32)/9;
        end;
     run;

data work.report(drop=i);
        set master.temps;
        array wkday{7} mon tue wed thr fri sat sun;
        do i=1 to 7;
           wkday{i}=5*(wkday{i}-32)/9;
        end;
     run;

data hrd.convert;                       * DIM();
        set hrd.fitclass;
        array wt{*} weight1-weight6;
        do i=1 to dim(wt);
           wt{i}=wt{i}*2.2046;
        end;
     run;

data hrd.diff;
        set hrd.convert;
        array wt{6} weight1-weight6;
        array WgtDiff{5};
        do i=1 to 5;
           wgtdiff{i}=wt{i+1}-wt{i};
        end;
     run;

data finance.report;
        set finance.qsales;
        array sale{4} sales1-sales4;
        array Goal{4} (9000 9300 9600 9900);
        array Achieved{4};
        do i=1 to 4;
           achieved{i}=100*sale{i}/goal{i};
        end;
     run;

* 13. MACROS;
&SYSDATE;
footnote "Report Run on &sysdate";
footnote "Report Run on &sysday, &sysdate9";

data hrd.temppay(drop=day);
        set hrd.newtemp(keep=name payrate hours1 hours2);
        total=hours1+hours2;
        Day="&sysday";
        if day='Friday' then
           do;
              gross=input(payrate,2.)*total;
              tempfee=gross*.05;
           end;
     run;

options symbolgen;
%let year=2000;
title "Temporary Employees for &year";
data hrd.newtemp;
        set hrd.temp;
        if year(enddate)=&year;
run;

%let yr=1999;
title "Temporary Employees for &yr";
data hrd.temp&yr;
        set hrd.temp;
        if year(enddate)=&yr;
run;

%let yr=1999;
%let period=end;
%let libref=hrd;
title "Temporary Employees for &yr";
data &libref..temp&yr;
      set &libref..temp;                        * DOUBLE DOT TO RESOLVE;
      if year(&period.date)=&yr;
run;

data hrd.overtime;                             * CALL SYMPUT;
        set hrd.temp(keep=name overtime);
        if overtime ne .;
        TotalOvertime+overtime;
        call symput('total',totalovertime);
     run;

data hrd.overtime;                             * CONTROLING THE CONDITION TO CALL;
        set hrd.temp(keep=name overtime) end=last;
        if overtime ne .;
        TotalOvertime+overtime;
        if last=1 then call
        symput('total',put(totalovertime,2.));
     run;

* 14. READING RAW DATA;
* COLUMN INPUT FOR FIXED FIELD;
data perm.empinfo;                             
        infile empdata;
        input @9 FirstName $5. @1 LastName $7. +7 JobTitle 3. 
              @19 Salary comma9.;
     run;

 infile receipts pad;                            * PAD OPTION IN INFILE STATEMENT;

* FREE FORMAT LIST INPUT READING;
data perm.survey;
        infile credit;
        input Gender $ Age Bankcard FreqBank Deptcard
              FreqDept;
     run;

data perm.survey;
        infile credit dlm=',';                   * DLM OPTIONS IN INFILE STATEMENT;
        input Gender $ Age Bankcard FreqBank 
              Deptcard FreqDept;
     run;

data perm.survey;
        infile credit missover;                  * MISSOVER OPTIONS IN INFILE STATEMENT;
        input Gender $ Age Bankcard FreqBank 
              Deptcard FreqDept;
     run;

data perm.survey;
        infile credit dsd dlm=' ';                       * DSD OPTIONS IN INFILE STATEMENT;
        input Gender $ Age Bankcard FreqBank 
              Deptcard FreqDept;
     run;

data perm.cityrank;                                   * & AND : MODIFIER;
        infile topten;
        input Rank City & $12.                        ;* The ampersand (&) modifier is used to read character values that contain embedded blanks;
              Pop86 : comma.;                         ;* The colon (:) modifier is used to read nonstandard data values and character values that are longer than eight characters, but which contain no embedded blanks;
     run;

data _null_;                                          * WRITING TO EXTERNAL FILE;
        set perm.finance;
        file 'c:\data\findat2' dlm=',';
        put ssn name salary date : date9.;
     run;
data _null_; 
   set perm.finance; 
   file 'c:\data\findat2' dsd; 
   put ssn name salary : comma. date : date9.; 
run;

* 15. DATE DATA;
DateExpression SASDateInformat  
 10/15/99  MMDDYYw. 
 15Oct99  DATEw. 
 10-15-99  MMDDYYw. 
 99/10/15  YYMMDDw.
 ;
DateExpression SASDateInformat 
 101599 MMDDYY6. 
 10/15/99 MMDDYY8. 
 10 15 99 MMDDYY8. 
 10-15-1999 MMDDYY10.
;
DateExpression SASDateInformat 
 30May00 DATE7. 
 30May2000 DATE9. 
 30-May-2000 DATE11. 
 ;
 TimeExpression  SASTimeInformat  
 17:00:01.34 TIME11. 
 17:00 TIME5. 
 2:34 TIME5. 
;
DateandTimeExpression   SASDatetimeInformat  
 30May2000:10:03:17.2 DATETIME20. 
 30May00 10:03:17.2 DATETIME18. 
 30May2000/10:03 DATETIME15. 
 ;

 options yearcutoff=1920;
     data perm.aprbills;
        infile aprdata;
        input LastName $8. @10 DateIn mmddyy8. +1 DateOut
           mmddyy8. +1 RoomRate 6. @35 EquipCost 6.;
        Days=dateout-datein+1;
        RoomCharge=days*roomrate;
        Total=roomcharge+equipcost;
     run;
 
* 16.  CREATING SINGLE OBS FROM MULTIPLE RECORDS;
data perm.members;                                   * USING /;
        infile memdata;
        input Fname $ Lname $ /
              Address $ 1-20 /
              City & $10. State $ Zip $;
     run;

data perm.patients;                                  * USING #;
        infile patdata;
        input #4 ID $5.
              #1 Fname $ Lname $ 
              #2 Address $23.
              #3 City $ State $ Zip $
              #4 @7 Doctor $6.;
     run;

data perm.patients;                                  * USING BOTH;
        infile patdata;
        input #4 ID $5.
              #1 Fname $ Lname $ / 
                 Address $23. /
                 City $ State $ Zip $ /
                 @7 Doctor $6.;
     run;

* 17.  CREATING MULTIPLE OBS FROM SINGLE RECORDS; 
data perm.april90;  
        infile tempdata;
        input Date : date. HighTemp @@;
        format date date9.;
     run;

data c;
input x y @;
cards;
1 2 3 4
2 2 3 5
3 2 1 1
;run;

data d;
input x y @@;
cards;
1 2 3 4
2 2 3 5
3 2 1 1
;run;

 







