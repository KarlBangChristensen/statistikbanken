**********************************************************************************
* NB: Programmet køres i Enhanced Editor i SAS
*
* Dette program, som indeholder udtrækket fra Statistikbanken i XML-format, 
* danner følgende SAS-datasæt i WORK-biblioteket
*
* SAS-datasæt              Beskrivelse
* ----------------------   --------------------------------------------------------
* codes                    Kodede værdier i grupperingsvariabler.
* values                   Formaterede værdier i grupperingsvariabler. 
* codes_with_formats       Kodede værdier i grupperingsvariabler med formater påsat. 
*
* SAS-datasættets navn  får en label svarende til XML-filens "Title"-tag.
*
* Variabler i SAS-datasættene:
* ----------------------------
* Variabelnavnene hentes fra "Text=" informationen i "Variable"-tags.
*
* Alle grupperingsvariabler bliver typen CHARACTER med en længde svarende 
* til længst forekommende værdi for den aktuelle variabel.
*
* Analysevariablen (VALUE), som indeholder antallet, beløbet m.v., er altid numerisk.
*
* Formaterne oprettes på WORK i kataloget FORMATS og er dokumenteret i SAS-datasættet
* WORK.FORMATS_.
*
***************
* In English: *
***************
*
* Important: To be submitted from SAS Enhanced Editor.
*
* This program containing the Query fra StatBank Denmark in XML format
* creates the following SAS tables in the WORK-library:
*
* SAS-table                Description
* ----------------------   --------------------------------------------------------
* codes                    Coded values for classification variables.
* values                   Formatted values for classification variables. 
* codes_with_formats       Coded values with formats for classification variables. 
*
* The names of the SAS tables are labeled according to XML file "Title" Tag.
*
* The columns (variables) in the SAS tables:
* ------------------------------------------
* Column names are derived from "Text=" info in the "Variable" tags.
*
* All classification variables are CHARACTER types. The variable length is length of  
* the longest distinct value for the actual variabel.
* The analysis variable containg the numbers, amounts etc is always NUMERIC.
*
* Formats are created in the WORK library in the catalog FORMATS as documented in the 
* SAS table WORK.FORMATS_.
*
* Version august 2008, Danmarks Statistik, Statistics Denmark
***********************************************************************************;
options nosource nonotes validvarname=any errors=0;

data code_values_(keep=varname varlabel varcode varvalue) 
	values_(keep=varname varcode value);

	length varname $32 varlabel $256 varcode varvalue $200 value 8;
	retain varname varlabel;

	infile cards pad truncover eof=finish;
	input;

	select;
		when (find(_infile_,'<Creation-date>') ne 0) do;
			startpos=find(_infile_,'<Creation-date>');
			endpos=find(_infile_,'</Creation-date>'); 
			call symputx('CREATIONDATE',substr(_infile_,startpos+15,endpos-(startpos+15)));
		end;

		when (find(_infile_,'<Title>') ne 0) do;
			startpos=find(_infile_,'<Title>');
			endpos=find(_infile_,'</Title>'); 
			call symputx('DATASETTITLE',substr(_infile_,startpos+7,endpos-(startpos+7)));
		end;

		when (find(_infile_,'<Unit>') ne 0) do;
			call symputx('UNIT',scan(_infile_,2,'"<>'));
		end;

		when (find(_infile_,'<Variable') ne 0) do;
			number_of_vars+1;
			call symputx(cats('VARNAME',put(number_of_vars,3.) ),scan(_infile_,2,'"'));
			call symputx(cats('VARLABEL',put(number_of_vars,3.) ),scan(_infile_,4,'"'));
			varname=scan(_infile_,2,'"');
			varlabel=scan(_infile_,4,'"');
		end;

		when (find(_infile_,'<Value Code=') ne 0) do;
			varcode=scan(_infile_,2,'"<>');
			varvalue=scan(_infile_,3,'"<>');
			output code_values_;
		end;

		when (find(_infile_,'<No ') ne 0) do; 
			value=scan(_infile_,-3,'<>');
			do i=1 to number_of_vars;
				varname='V'!!trim(left(put(i,3.)));
				varcode=scan(_infile_,i*2,'"');
				output values_;
			end;
		end;

		otherwise;

	end;
	finish:  call symputx('NUMBER_OF_VARS',put(number_of_vars,3.) );
cards4;
<?xml version="1.0" encoding="UTF-16"?>
<Cube>
<MetaData>
<Language>0</Language>
<Creation-date>07-10-2021 08:53:28</Creation-date>
<LastUpdated>03-06-2016 09:30:00</LastUpdated>
<TableSource>LIVS10</TableSource>
<Title>Livskvalitet efter enhed, køn, alder, tillid, område og tid</Title>
<Contents>Livskvalitet</Contents>
<Unit>-</Unit>
<Note>Anm.: Scoren 0 er &amp;quot;Meget lav grad&amp;quot; og 10 er &amp;quot;Meget høj grad&amp;quot;.</Note>
<Notex></Notex>
<MissingNo>0</MissingNo>
<Variable Code="V1" Text="tid" Prescat="S" Presid="2">
<Value Code="2015">2015</Value>
</Variable>
<Variable Code="V2" Text="enhed" Prescat="S" Presid="1">
<Value Code="S81">Gennemsnitlig score</Value>
</Variable>
<Variable Code="V3" Text="køn" Prescat="H" Presid="1">
<Value Code="M">Mænd</Value>
<Value Code="K">Kvinder</Value>
</Variable>
<Variable Code="V4" Text="alder" Prescat="S" Presid="4">
<Value Code="1829">18-29 år</Value>
<Value Code="3039">30-39 år</Value>
<Value Code="4049">40-49 år</Value>
<Value Code="5059">50-59 år</Value>
<Value Code="6069">60-69 år</Value>
<Value Code="7099">70 år og derover</Value>
</Variable>
<Variable Code="V5" Text="tillid" Prescat="S" Presid="3">
<Value Code="S28">Hvor høj eller lav tillid har du til politikerne i Folketinget?</Value>
<Value Code="S29">Hvor høj eller lav tillid har du til lokalpolitikerne i din kommune?</Value>
<Value Code="S30">Hvor høj eller lav tillid har du til, at du kan få den bedst mulige behandling fra det offentlige, hvis du bliver alvorligt syg?</Value>
<Value Code="S31">Hvor høj eller lav tillid har du til, at du kan få den nødvendige hjælp og service fra din kommune, når du har brug for det?</Value>
<Value Code="S32">Hvor høj eller lav tillid har du til, at du kan få et (nyt) job, der passer til din uddannelse?</Value>
</Variable>
<Variable Code="V6" Text="område" Prescat="S" Presid="5">
<Value Code="101">København</Value>
<Value Code="183">Ishøj</Value>
<Value Code="230">Rudersdal</Value>
<Value Code="400">Bornholm</Value>
<Value Code="253">Greve</Value>
<Value Code="265">Roskilde</Value>
<Value Code="320">Faxe</Value>
<Value Code="360">Lolland</Value>
<Value Code="420">Assens</Value>
<Value Code="430">Faaborg-Midtfyn</Value>
<Value Code="440">Kerteminde</Value>
<Value Code="482">Langeland</Value>
<Value Code="410">Middelfart</Value>
<Value Code="480">Nordfyns</Value>
<Value Code="450">Nyborg</Value>
<Value Code="461">Odense</Value>
<Value Code="479">Svendborg</Value>
<Value Code="492">Ærø</Value>
<Value Code="530">Billund</Value>
<Value Code="561">Esbjerg</Value>
<Value Code="563">Fanø</Value>
<Value Code="607">Fredericia</Value>
<Value Code="510">Haderslev</Value>
<Value Code="621">Kolding</Value>
<Value Code="540">Sønderborg</Value>
<Value Code="550">Tønder</Value>
<Value Code="573">Varde</Value>
<Value Code="575">Vejen</Value>
<Value Code="630">Vejle</Value>
<Value Code="580">Aabenraa</Value>
<Value Code="746">Skanderborg</Value>
<Value Code="751">Aarhus</Value>
<Value Code="657">Herning</Value>
<Value Code="760">Ringkøbing-Skjern</Value>
<Value Code="773">Morsø</Value>
<Value Code="840">Rebild</Value>
<Value Code="820">Vesthimmerlands</Value>
<Value Code="851">Aalborg</Value>
</Variable>
</MetaData>
<Data>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="101" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="183" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="230" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="400" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="253" >2.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="265" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="320" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="360" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="420" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="430" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="440" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="482" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="410" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="480" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="450" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="461" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="479" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="492" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="530" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="561" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="563" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="607" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="510" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="621" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="540" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="550" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="573" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="575" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="630" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="580" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="746" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="751" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="657" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="760" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="773" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="840" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="820" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S28" V6="851" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="101" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="183" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="230" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="400" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="253" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="265" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="320" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="360" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="420" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="430" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="440" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="482" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="410" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="480" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="450" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="461" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="479" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="492" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="530" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="561" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="563" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="607" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="510" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="621" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="540" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="550" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="573" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="575" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="630" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="580" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="746" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="751" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="657" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="760" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="773" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="840" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="820" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S29" V6="851" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="101" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="183" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="230" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="400" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="253" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="265" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="320" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="360" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="420" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="430" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="440" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="482" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="410" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="480" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="450" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="461" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="479" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="492" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="530" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="561" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="563" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="607" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="510" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="621" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="540" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="550" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="573" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="575" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="630" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="580" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="746" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="751" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="657" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="760" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="773" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="840" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="820" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S30" V6="851" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="101" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="183" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="230" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="400" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="253" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="265" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="320" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="360" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="420" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="430" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="440" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="482" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="410" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="480" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="450" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="461" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="479" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="492" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="530" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="561" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="563" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="607" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="510" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="621" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="540" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="550" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="573" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="575" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="630" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="580" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="746" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="751" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="657" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="760" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="773" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="840" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="820" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S31" V6="851" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="101" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="183" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="230" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="400" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="253" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="265" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="320" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="360" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="420" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="430" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="440" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="482" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="410" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="480" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="450" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="461" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="479" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="492" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="530" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="561" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="563" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="607" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="510" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="621" >7.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="540" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="550" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="573" >7.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="575" >7.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="630" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="580" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="746" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="751" >7.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="657" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="760" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="773" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="840" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="820" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="1829" V5="S32" V6="851" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="101" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="183" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="230" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="400" >2.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="253" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="265" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="320" >2.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="360" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="420" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="430" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="440" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="482" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="410" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="480" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="450" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="461" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="479" >2.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="492" >2.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="530" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="561" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="563" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="607" >2.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="510" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="621" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="540" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="550" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="573" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="575" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="630" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="580" >2.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="746" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="751" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="657" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="760" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="773" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="840" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="820" >2.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S28" V6="851" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="101" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="183" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="230" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="400" >2.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="253" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="265" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="320" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="360" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="420" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="430" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="440" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="482" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="410" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="480" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="450" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="461" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="479" >2.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="492" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="530" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="561" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="563" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="607" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="510" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="621" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="540" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="550" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="573" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="575" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="630" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="580" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="746" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="751" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="657" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="760" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="773" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="840" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="820" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S29" V6="851" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="101" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="183" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="230" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="400" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="253" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="265" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="320" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="360" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="420" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="430" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="440" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="482" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="410" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="480" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="450" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="461" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="479" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="492" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="530" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="561" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="563" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="607" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="510" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="621" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="540" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="550" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="573" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="575" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="630" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="580" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="746" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="751" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="657" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="760" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="773" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="840" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="820" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S30" V6="851" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="101" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="183" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="230" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="400" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="253" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="265" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="320" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="360" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="420" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="430" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="440" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="482" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="410" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="480" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="450" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="461" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="479" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="492" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="530" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="561" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="563" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="607" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="510" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="621" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="540" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="550" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="573" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="575" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="630" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="580" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="746" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="751" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="657" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="760" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="773" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="840" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="820" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S31" V6="851" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="101" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="183" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="230" >8.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="400" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="253" >7.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="265" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="320" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="360" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="420" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="430" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="440" >7.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="482" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="410" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="480" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="450" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="461" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="479" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="492" >8.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="530" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="561" >7.3</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="563" >7.5</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="607" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="510" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="621" >7.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="540" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="550" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="573" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="575" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="630" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="580" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="746" >8.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="751" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="657" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="760" >7.4</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="773" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="840" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="820" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="3039" V5="S32" V6="851" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="101" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="183" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="230" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="400" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="253" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="265" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="320" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="360" >2.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="420" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="430" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="440" >2.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="482" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="410" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="480" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="450" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="461" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="479" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="492" >2.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="530" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="561" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="563" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="607" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="510" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="621" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="540" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="550" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="573" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="575" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="630" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="580" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="746" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="751" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="657" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="760" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="773" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="840" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="820" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S28" V6="851" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="101" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="183" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="230" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="400" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="253" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="265" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="320" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="360" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="420" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="430" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="440" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="482" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="410" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="480" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="450" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="461" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="479" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="492" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="530" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="561" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="563" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="607" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="510" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="621" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="540" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="550" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="573" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="575" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="630" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="580" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="746" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="751" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="657" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="760" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="773" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="840" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="820" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S29" V6="851" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="101" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="183" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="230" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="400" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="253" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="265" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="320" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="360" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="420" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="430" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="440" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="482" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="410" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="480" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="450" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="461" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="479" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="492" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="530" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="561" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="563" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="607" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="510" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="621" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="540" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="550" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="573" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="575" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="630" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="580" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="746" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="751" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="657" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="760" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="773" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="840" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="820" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S30" V6="851" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="101" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="183" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="230" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="400" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="253" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="265" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="320" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="360" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="420" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="430" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="440" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="482" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="410" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="480" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="450" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="461" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="479" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="492" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="530" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="561" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="563" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="607" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="510" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="621" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="540" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="550" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="573" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="575" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="630" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="580" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="746" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="751" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="657" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="760" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="773" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="840" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="820" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S31" V6="851" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="101" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="183" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="230" >8.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="400" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="253" >7.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="265" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="320" >7.4</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="360" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="420" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="430" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="440" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="482" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="410" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="480" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="450" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="461" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="479" >7.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="492" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="530" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="561" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="563" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="607" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="510" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="621" >7.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="540" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="550" >7.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="573" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="575" >7.3</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="630" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="580" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="746" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="751" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="657" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="760" >7.7</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="773" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="840" >7.5</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="820" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="4049" V5="S32" V6="851" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="101" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="183" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="230" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="400" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="253" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="265" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="320" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="360" >2.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="420" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="430" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="440" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="482" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="410" >2.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="480" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="450" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="461" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="479" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="492" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="530" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="561" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="563" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="607" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="510" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="621" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="540" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="550" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="573" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="575" >2.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="630" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="580" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="746" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="751" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="657" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="760" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="773" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="840" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="820" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S28" V6="851" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="101" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="183" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="230" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="400" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="253" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="265" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="320" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="360" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="420" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="430" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="440" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="482" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="410" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="480" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="450" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="461" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="479" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="492" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="530" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="561" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="563" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="607" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="510" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="621" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="540" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="550" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="573" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="575" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="630" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="580" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="746" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="751" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="657" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="760" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="773" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="840" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="820" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S29" V6="851" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="101" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="183" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="230" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="400" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="253" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="265" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="320" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="360" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="420" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="430" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="440" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="482" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="410" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="480" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="450" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="461" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="479" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="492" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="530" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="561" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="563" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="607" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="510" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="621" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="540" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="550" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="573" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="575" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="630" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="580" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="746" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="751" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="657" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="760" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="773" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="840" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="820" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S30" V6="851" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="101" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="183" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="230" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="400" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="253" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="265" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="320" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="360" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="420" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="430" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="440" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="482" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="410" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="480" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="450" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="461" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="479" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="492" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="530" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="561" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="563" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="607" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="510" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="621" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="540" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="550" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="573" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="575" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="630" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="580" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="746" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="751" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="657" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="760" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="773" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="840" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="820" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S31" V6="851" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="101" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="183" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="230" >7.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="400" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="253" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="265" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="320" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="360" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="420" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="430" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="440" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="482" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="410" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="480" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="450" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="461" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="479" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="492" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="530" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="561" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="563" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="607" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="510" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="621" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="540" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="550" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="573" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="575" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="630" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="580" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="746" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="751" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="657" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="760" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="773" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="840" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="820" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="5059" V5="S32" V6="851" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="101" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="183" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="230" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="400" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="253" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="265" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="320" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="360" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="420" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="430" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="440" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="482" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="410" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="480" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="450" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="461" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="479" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="492" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="530" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="561" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="563" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="607" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="510" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="621" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="540" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="550" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="573" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="575" >3.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="630" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="580" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="746" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="751" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="657" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="760" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="773" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="840" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="820" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S28" V6="851" >3.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="101" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="183" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="230" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="400" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="253" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="265" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="320" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="360" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="420" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="430" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="440" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="482" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="410" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="480" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="450" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="461" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="479" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="492" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="530" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="561" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="563" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="607" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="510" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="621" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="540" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="550" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="573" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="575" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="630" >3.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="580" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="746" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="751" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="657" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="760" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="773" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="840" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="820" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S29" V6="851" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="101" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="183" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="230" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="400" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="253" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="265" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="320" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="360" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="420" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="430" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="440" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="482" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="410" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="480" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="450" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="461" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="479" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="492" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="530" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="561" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="563" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="607" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="510" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="621" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="540" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="550" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="573" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="575" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="630" >7.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="580" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="746" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="751" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="657" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="760" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="773" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="840" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="820" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S30" V6="851" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="101" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="183" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="230" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="400" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="253" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="265" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="320" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="360" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="420" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="430" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="440" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="482" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="410" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="480" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="450" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="461" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="479" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="492" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="530" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="561" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="563" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="607" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="510" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="621" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="540" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="550" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="573" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="575" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="630" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="580" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="746" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="751" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="657" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="760" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="773" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="840" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="820" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S31" V6="851" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="101" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="183" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="230" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="400" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="253" >5.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="265" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="320" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="360" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="420" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="430" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="440" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="482" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="410" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="480" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="450" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="461" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="479" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="492" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="530" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="561" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="563" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="607" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="510" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="621" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="540" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="550" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="573" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="575" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="630" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="580" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="746" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="751" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="657" >5.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="760" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="773" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="840" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="820" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="6069" V5="S32" V6="851" >5.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="101" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="183" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="230" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="400" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="253" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="265" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="320" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="360" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="420" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="430" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="440" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="482" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="410" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="480" >3.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="450" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="461" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="479" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="492" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="530" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="561" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="563" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="607" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="510" >3.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="621" >3.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="540" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="550" >3.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="573" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="575" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="630" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="580" >3.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="746" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="751" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="657" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="760" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="773" >4.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="840" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="820" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S28" V6="851" >3.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="101" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="183" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="230" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="400" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="253" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="265" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="320" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="360" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="420" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="430" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="440" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="482" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="410" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="480" >4.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="450" >4.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="461" >4.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="479" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="492" >3.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="530" >5.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="561" >5.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="563" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="607" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="510" >4.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="621" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="540" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="550" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="573" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="575" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="630" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="580" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="746" >5.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="751" >4.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="657" >5.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="760" >4.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="773" >4.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="840" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="820" >5.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S29" V6="851" >4.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="101" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="183" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="230" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="400" >7.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="253" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="265" >7.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="320" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="360" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="420" >7.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="430" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="440" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="482" >7.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="410" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="480" >7.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="450" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="461" >7.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="479" >7.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="492" >7.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="530" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="561" >7.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="563" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="607" >7.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="510" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="621" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="540" >7.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="550" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="573" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="575" >7.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="630" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="580" >7.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="746" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="751" >8.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="657" >7.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="760" >7.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="773" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="840" >7.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="820" >7.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S30" V6="851" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="101" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="183" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="230" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="400" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="253" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="265" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="320" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="360" >5.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="420" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="430" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="440" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="482" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="410" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="480" >6.8</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="450" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="461" >6.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="479" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="492" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="530" >6.3</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="561" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="563" >7.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="607" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="510" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="621" >5.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="540" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="550" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="573" >7.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="575" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="630" >6.4</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="580" >6.1</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="746" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="751" >6.9</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="657" >6.6</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="760" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="773" >6.5</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="840" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="820" >6.7</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S31" V6="851" >6.2</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="101" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="183" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="230" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="400" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="253" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="265" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="320" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="360" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="420" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="430" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="440" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="482" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="410" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="480" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="450" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="461" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="479" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="492" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="530" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="561" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="563" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="607" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="510" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="621" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="540" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="550" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="573" >4.0</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="575" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="630" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="580" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="746" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="751" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="657" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="760" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="773" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="840" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="820" >..</No>
<No V1="2015" V2="S81" V3="M" V4="7099" V5="S32" V6="851" >..</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="101" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="183" >3.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="230" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="400" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="253" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="265" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="320" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="360" >3.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="420" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="430" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="440" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="482" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="410" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="480" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="450" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="461" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="479" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="492" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="530" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="561" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="563" >3.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="607" >3.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="510" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="621" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="540" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="550" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="573" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="575" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="630" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="580" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="746" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="751" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="657" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="760" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="773" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="840" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="820" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S28" V6="851" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="101" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="183" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="230" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="400" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="253" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="265" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="320" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="360" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="420" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="430" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="440" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="482" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="410" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="480" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="450" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="461" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="479" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="492" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="530" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="561" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="563" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="607" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="510" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="621" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="540" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="550" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="573" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="575" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="630" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="580" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="746" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="751" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="657" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="760" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="773" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="840" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="820" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S29" V6="851" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="101" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="183" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="230" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="400" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="253" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="265" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="320" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="360" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="420" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="430" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="440" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="482" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="410" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="480" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="450" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="461" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="479" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="492" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="530" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="561" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="563" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="607" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="510" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="621" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="540" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="550" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="573" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="575" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="630" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="580" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="746" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="751" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="657" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="760" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="773" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="840" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="820" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S30" V6="851" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="101" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="183" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="230" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="400" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="253" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="265" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="320" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="360" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="420" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="430" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="440" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="482" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="410" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="480" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="450" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="461" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="479" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="492" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="530" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="561" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="563" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="607" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="510" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="621" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="540" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="550" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="573" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="575" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="630" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="580" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="746" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="751" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="657" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="760" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="773" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="840" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="820" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S31" V6="851" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="101" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="183" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="230" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="400" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="253" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="265" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="320" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="360" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="420" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="430" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="440" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="482" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="410" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="480" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="450" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="461" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="479" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="492" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="530" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="561" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="563" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="607" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="510" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="621" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="540" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="550" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="573" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="575" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="630" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="580" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="746" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="751" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="657" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="760" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="773" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="840" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="820" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="1829" V5="S32" V6="851" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="101" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="183" >3.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="230" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="400" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="253" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="265" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="320" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="360" >2.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="420" >3.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="430" >2.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="440" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="482" >3.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="410" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="480" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="450" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="461" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="479" >2.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="492" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="530" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="561" >3.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="563" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="607" >3.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="510" >2.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="621" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="540" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="550" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="573" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="575" >3.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="630" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="580" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="746" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="751" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="657" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="760" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="773" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="840" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="820" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S28" V6="851" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="101" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="183" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="230" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="400" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="253" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="265" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="320" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="360" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="420" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="430" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="440" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="482" >2.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="410" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="480" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="450" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="461" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="479" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="492" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="530" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="561" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="563" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="607" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="510" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="621" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="540" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="550" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="573" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="575" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="630" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="580" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="746" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="751" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="657" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="760" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="773" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="840" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="820" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S29" V6="851" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="101" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="183" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="230" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="400" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="253" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="265" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="320" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="360" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="420" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="430" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="440" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="482" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="410" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="480" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="450" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="461" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="479" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="492" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="530" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="561" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="563" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="607" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="510" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="621" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="540" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="550" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="573" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="575" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="630" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="580" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="746" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="751" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="657" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="760" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="773" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="840" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="820" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S30" V6="851" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="101" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="183" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="230" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="400" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="253" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="265" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="320" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="360" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="420" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="430" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="440" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="482" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="410" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="480" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="450" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="461" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="479" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="492" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="530" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="561" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="563" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="607" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="510" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="621" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="540" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="550" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="573" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="575" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="630" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="580" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="746" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="751" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="657" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="760" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="773" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="840" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="820" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S31" V6="851" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="101" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="183" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="230" >7.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="400" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="253" >7.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="265" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="320" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="360" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="420" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="430" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="440" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="482" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="410" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="480" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="450" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="461" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="479" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="492" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="530" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="561" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="563" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="607" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="510" >7.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="621" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="540" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="550" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="573" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="575" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="630" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="580" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="746" >7.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="751" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="657" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="760" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="773" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="840" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="820" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="3039" V5="S32" V6="851" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="101" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="183" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="230" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="400" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="253" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="265" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="320" >3.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="360" >3.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="420" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="430" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="440" >2.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="482" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="410" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="480" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="450" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="461" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="479" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="492" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="530" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="561" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="563" >2.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="607" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="510" >3.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="621" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="540" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="550" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="573" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="575" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="630" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="580" >2.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="746" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="751" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="657" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="760" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="773" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="840" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="820" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S28" V6="851" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="101" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="183" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="230" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="400" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="253" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="265" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="320" >3.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="360" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="420" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="430" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="440" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="482" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="410" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="480" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="450" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="461" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="479" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="492" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="530" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="561" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="563" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="607" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="510" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="621" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="540" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="550" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="573" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="575" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="630" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="580" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="746" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="751" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="657" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="760" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="773" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="840" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="820" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S29" V6="851" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="101" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="183" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="230" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="400" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="253" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="265" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="320" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="360" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="420" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="430" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="440" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="482" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="410" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="480" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="450" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="461" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="479" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="492" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="530" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="561" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="563" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="607" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="510" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="621" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="540" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="550" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="573" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="575" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="630" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="580" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="746" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="751" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="657" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="760" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="773" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="840" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="820" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S30" V6="851" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="101" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="183" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="230" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="400" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="253" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="265" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="320" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="360" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="420" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="430" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="440" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="482" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="410" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="480" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="450" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="461" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="479" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="492" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="530" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="561" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="563" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="607" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="510" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="621" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="540" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="550" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="573" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="575" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="630" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="580" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="746" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="751" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="657" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="760" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="773" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="840" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="820" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S31" V6="851" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="101" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="183" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="230" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="400" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="253" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="265" >7.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="320" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="360" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="420" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="430" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="440" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="482" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="410" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="480" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="450" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="461" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="479" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="492" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="530" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="561" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="563" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="607" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="510" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="621" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="540" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="550" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="573" >7.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="575" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="630" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="580" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="746" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="751" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="657" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="760" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="773" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="840" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="820" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="4049" V5="S32" V6="851" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="101" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="183" >3.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="230" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="400" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="253" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="265" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="320" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="360" >3.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="420" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="430" >3.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="440" >3.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="482" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="410" >3.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="480" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="450" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="461" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="479" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="492" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="530" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="561" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="563" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="607" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="510" >3.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="621" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="540" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="550" >3.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="573" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="575" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="630" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="580" >2.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="746" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="751" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="657" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="760" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="773" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="840" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="820" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S28" V6="851" >3.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="101" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="183" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="230" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="400" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="253" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="265" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="320" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="360" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="420" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="430" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="440" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="482" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="410" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="480" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="450" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="461" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="479" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="492" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="530" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="561" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="563" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="607" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="510" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="621" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="540" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="550" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="573" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="575" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="630" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="580" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="746" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="751" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="657" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="760" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="773" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="840" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="820" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S29" V6="851" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="101" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="183" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="230" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="400" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="253" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="265" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="320" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="360" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="420" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="430" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="440" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="482" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="410" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="480" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="450" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="461" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="479" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="492" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="530" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="561" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="563" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="607" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="510" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="621" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="540" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="550" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="573" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="575" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="630" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="580" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="746" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="751" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="657" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="760" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="773" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="840" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="820" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S30" V6="851" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="101" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="183" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="230" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="400" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="253" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="265" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="320" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="360" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="420" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="430" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="440" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="482" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="410" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="480" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="450" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="461" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="479" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="492" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="530" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="561" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="563" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="607" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="510" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="621" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="540" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="550" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="573" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="575" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="630" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="580" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="746" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="751" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="657" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="760" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="773" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="840" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="820" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S31" V6="851" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="101" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="183" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="230" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="400" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="253" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="265" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="320" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="360" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="420" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="430" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="440" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="482" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="410" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="480" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="450" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="461" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="479" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="492" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="530" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="561" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="563" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="607" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="510" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="621" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="540" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="550" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="573" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="575" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="630" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="580" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="746" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="751" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="657" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="760" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="773" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="840" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="820" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="5059" V5="S32" V6="851" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="101" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="183" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="230" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="400" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="253" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="265" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="320" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="360" >2.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="420" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="430" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="440" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="482" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="410" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="480" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="450" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="461" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="479" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="492" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="530" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="561" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="563" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="607" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="510" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="621" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="540" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="550" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="573" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="575" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="630" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="580" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="746" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="751" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="657" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="760" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="773" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="840" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="820" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S28" V6="851" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="101" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="183" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="230" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="400" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="253" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="265" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="320" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="360" >3.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="420" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="430" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="440" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="482" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="410" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="480" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="450" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="461" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="479" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="492" >3.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="530" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="561" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="563" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="607" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="510" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="621" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="540" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="550" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="573" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="575" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="630" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="580" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="746" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="751" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="657" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="760" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="773" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="840" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="820" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S29" V6="851" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="101" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="183" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="230" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="400" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="253" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="265" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="320" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="360" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="420" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="430" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="440" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="482" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="410" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="480" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="450" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="461" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="479" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="492" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="530" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="561" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="563" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="607" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="510" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="621" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="540" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="550" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="573" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="575" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="630" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="580" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="746" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="751" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="657" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="760" >7.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="773" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="840" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="820" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S30" V6="851" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="101" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="183" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="230" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="400" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="253" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="265" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="320" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="360" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="420" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="430" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="440" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="482" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="410" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="480" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="450" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="461" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="479" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="492" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="530" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="561" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="563" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="607" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="510" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="621" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="540" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="550" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="573" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="575" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="630" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="580" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="746" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="751" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="657" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="760" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="773" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="840" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="820" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S31" V6="851" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="101" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="183" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="230" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="400" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="253" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="265" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="320" >3.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="360" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="420" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="430" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="440" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="482" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="410" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="480" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="450" >5.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="461" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="479" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="492" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="530" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="561" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="563" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="607" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="510" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="621" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="540" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="550" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="573" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="575" >6.0</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="630" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="580" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="746" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="751" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="657" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="760" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="773" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="840" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="820" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="6069" V5="S32" V6="851" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="101" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="183" >3.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="230" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="400" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="253" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="265" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="320" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="360" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="420" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="430" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="440" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="482" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="410" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="480" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="450" >3.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="461" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="479" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="492" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="530" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="561" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="563" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="607" >3.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="510" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="621" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="540" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="550" >3.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="573" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="575" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="630" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="580" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="746" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="751" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="657" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="760" >4.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="773" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="840" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="820" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S28" V6="851" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="101" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="183" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="230" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="400" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="253" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="265" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="320" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="360" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="420" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="430" >4.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="440" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="482" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="410" >5.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="480" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="450" >4.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="461" >3.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="479" >4.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="492" >4.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="530" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="561" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="563" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="607" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="510" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="621" >5.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="540" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="550" >4.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="573" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="575" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="630" >4.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="580" >4.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="746" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="751" >4.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="657" >5.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="760" >5.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="773" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="840" >5.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="820" >5.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S29" V6="851" >4.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="101" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="183" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="230" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="400" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="253" >7.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="265" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="320" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="360" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="420" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="430" >7.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="440" >6.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="482" >7.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="410" >7.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="480" >7.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="450" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="461" >7.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="479" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="492" >7.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="530" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="561" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="563" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="607" >7.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="510" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="621" >7.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="540" >7.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="550" >7.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="573" >7.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="575" >7.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="630" >7.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="580" >7.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="746" >7.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="751" >7.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="657" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="760" >7.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="773" >7.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="840" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="820" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S30" V6="851" >7.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="101" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="183" >7.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="230" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="400" >6.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="253" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="265" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="320" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="360" >5.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="420" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="430" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="440" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="482" >7.0</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="410" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="480" >7.3</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="450" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="461" >6.1</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="479" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="492" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="530" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="561" >5.9</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="563" >7.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="607" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="510" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="621" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="540" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="550" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="573" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="575" >7.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="630" >6.8</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="580" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="746" >6.4</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="751" >5.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="657" >6.2</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="760" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="773" >7.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="840" >6.7</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="820" >6.6</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S31" V6="851" >6.5</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="101" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="183" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="230" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="400" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="253" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="265" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="320" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="360" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="420" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="430" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="440" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="482" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="410" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="480" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="450" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="461" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="479" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="492" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="530" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="561" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="563" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="607" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="510" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="621" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="540" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="550" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="573" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="575" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="630" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="580" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="746" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="751" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="657" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="760" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="773" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="840" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="820" >..</No>
<No V1="2015" V2="S81" V3="K" V4="7099" V5="S32" V6="851" >..</No>
</Data>
</Cube>
;;;;
run;
proc sql noprint;
   select varname, 
          max(length(varcode)) as maxcodelength, 
          max(length(varvalue)) as maxvaluelength
		  into :varlist     separated by ' ', 
               :codelength  separated by ' ', 
               :valuelength separated by ' ' 
   from code_values_
   group by varname;

   select distinct quote(trim(varname)), 
                   varname
          into :formatlist_q separated by ',',
               :formatlist   separated by ','
   from code_values_
   where varcode ne varvalue
   ;
quit;

%macro konvert;
	%let number_of_formats=&SQLOBS;
	%* Create the CODES dataset ;
	data codes(keep=V1-V&number_of_vars value);
	  %do i=1 %to &number_of_vars;
	    length %scan(&varlist,&i,%str( )) $%scan(&codelength,&i,%str( ));
		 label &&varname&i = "&&varlabel&i";
	  %end;

	  %if %nrbquote(&unit) ne and %nrbquote(&unit) ne %str(-) %then %do;
		 label value = "Value, unit=&unit";
	  %end;

	   retain V1-V&number_of_vars;
	   array vars (&number_of_vars) V1-V&number_of_vars;
	   j=0;
	   do i=1 to number_of_obs;
	      j+1;  
	      set values_ point=i nobs=number_of_obs;
		  vars(j)=varcode;
		  if j=&number_of_vars then do;
		    j=0;
			output;
		  end;
	   end;
	stop;
	run;

	proc sort data=codes;
	  by _character_;
	run;
	/*create all possible combinations */
	proc summary data=codes nway completetypes;
	  class _character_;
	  var value;
	  output out=completetypes(drop=_type_ _freq_) sum=;
	run;
	/* set values to zero */
	data completetypes;
	 set completetypes;
	 value=0;
	run;
	/* fit in reported values */
	data codes(label="&datasettitle");
	 merge completetypes(in=complete)
         codes ;
	 by _character_;
	 if complete;
	run;
	%* Create a dataset to create formats;
	data cntlin;
	  set code_values_;
	  fmtname=compress(varname!!'fmt');
	  type='C';
	run;
	%* Create the formats, formats documentation dataset, format code in LOG;
	proc format cntlin=cntlin(where=(varname in (&formatlist_q)) 
	                          rename=(varcode=start varvalue=label));
	run;
	proc format cntlout=formats;
	 select
	   %do i=1 %to &number_of_formats;
	     $%scan(%superq(formatlist),&i)fmt
	  %end;
	  ;
	run;
	%put;
	%put PROC FORMAT kode, som også kan danne de benyttede formater:;
	%put PROC FORMAT code for your convenience:;
	%put;
	data _null_;
	  length txt $256;
	  set formats end=finish;
	  by fmtname notsorted;
	  if _n_=1 then
	     put 'Proc format;';
	  if first.fmtname then do;
	   txt='value '!!'$'!!trim(left(fmtname)); 
	   put @3 txt;
	  end;
	  txt=quote(trim(start))!!'='!!quote(trim(label));
	  put @6 txt;
	  if last.fmtname then
	   put @6 ';';
	  if finish then
	   put 'run;';
	run;
	%* Create the dataset, coded with formats;
    data codes_with_formats(label="&datasettitle");
	   set codes;
	   %do i=1 %to &number_of_formats;
	     format %scan(%superq(formatlist),&i) $%scan(%superq(formatlist),&i)fmt.;
	  %end;
	run;
	%* Create the dataset with values;
    data values(label="&datasettitle");
	  %do i=1 %to &number_of_vars;
	     length %scan(&varlist,&i,%str( )) $%scan(&valuelength,&i,%str( ));
	  %end;
	   set codes;
	   %do i=1 %to &number_of_formats;
	     %scan(%superq(formatlist),&i) = put(%scan(%superq(formatlist),&i),$%scan(%superq(formatlist),&i)fmt.);
	  %end;
	run;
	%* Cleanup;
	proc datasets library=work nolist;
		delete  cntlin
              code_values_
              values_
              completetypes;
	run;
	quit; 
	%put;
	%put SAS datasættene er nu klar til brug!;
	%put The SAS tables are ready for use!;
	%put;
    options source notes errors=20;
%mend;
%konvert;
