*;
%let path=C:\Users\karlc\Desktop\statistikbanken;
%let name=livskv11;
%include "&path\&name\&name data.sas";
libname &name "&path\&name";
proc copy in=work out=&name memtype=data;
	select codes codes_with_formats formats values;
run;
ods layout gridded columns=2;
ods region;
proc freq data=values order=freq;
	table v1-v6 / nocum;
	weight value;
run;
ods region;
proc freq data=codes order=freq;
	table v1-v6 / nocum;
	weight value;
run;
ods layout end;
*;
proc sort data=&name..codes_with_formats;
	by v2 v3 v5;
run;
proc freq data=&name..codes_with_formats noprint;
	where V4 in ('S82','S83','S84');
	table V4*V6 / outpct out=table(drop=count percent pct_row);
	weight value;
	by v2 v3 v5;
run;
data table;
	set table;
	RegSj='Andre Regioner';
	if V6 in ('253','259','265','269','336','350') then do; RegSj='RegSj'; end; /* SUH */
	if V6 in ('370','306','316','320','326','329','330','340') then do; RegSj='RegSj'; end; /* NSR_H */
	if V6 in ('360','376','390') then do; RegSj='RegSj'; end; /* NFS */
	item=V5;
run;
*;
proc sort data=table;
	by V5;
run;
/*
options printerpath=gif animation=start animduration=1 animloop=no noanimoverlay;
ods printer file="&path\livskv11.gif";
ods graphics / height=500px width=800px;
*/
options nobyline;
title ;

%macro plot(item, label);
	title "&label";
	proc sgpanel data=table;
		where V2='K' and V5="&item";
		panelby V3 / columns=1 rows=6 noheader;
		hbar RegSj / response=pct_col stat=mean group=V4;
		keylegend / title=' ' noborder;
	*	colaxis valueattrs=(size=14) label=' ';
	*	rowaxis display=(novalues noline noticks) labelattrs=(size=14) label='aldersgrupper';
	run;
%mend plot;
%plot(item=S33, label= I hvilken grad f�ler du dig v�rdsat og anerkendt af andre i din hverdag? );
%plot(item=S34, label= I hvilken grad f�ler du, at du har mulighed for at styre dit liv i den retning, du selv �nsker? 
%plot(item=S35, label= I hvilken grad mener du, at folk generelt er til at stole p�? 
%plot(item=S36, label= I hvilken grad f�ler du dig tryg i dit n�romr�de efter m�rkets frembrud? 
%plot(item=S37, label= I hvilken grad har du tillid til, at politiet vil hj�lpe dig, hvis du har brug for det? 
%plot(item=S38, label=I hvilken grad synes du, at h�rv�rk og kriminalitet er et problem i dit n�romr�de? 

ods printer close;

proc print data=formats noobs;
var start label;
run;
