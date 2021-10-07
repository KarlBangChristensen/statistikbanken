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
<Creation-date>07-10-2021 08:51:01</Creation-date>
<LastUpdated>03-06-2016 09:30:00</LastUpdated>
<TableSource>LIVS3</TableSource>
<Title>Livskvalitet efter enhed, meningsfuldhed, køn, alder, område og tid</Title>
<Contents>Livskvalitet</Contents>
<Unit>-</Unit>
<Note>Anm.: Scoren 0 er &amp;quot;Slet ingen mening&amp;quot; og 10 er &amp;quot;fuldt ud mening&amp;quot;</Note>
<Notex></Notex>
<MissingNo>0</MissingNo>
<Variable Code="V1" Text="tid" Prescat="S" Presid="3">
<Value Code="2015">2015</Value>
</Variable>
<Variable Code="V2" Text="enhed" Prescat="S" Presid="1">
<Value Code="S81">Gennemsnitlig score</Value>
</Variable>
<Variable Code="V3" Text="meningsfuldhed" Prescat="S" Presid="2">
<Value Code="S12">I hvilken grad føler du, at de ting, du foretager dig i dit liv, giver mening?</Value>
</Variable>
<Variable Code="V4" Text="køn" Prescat="H" Presid="1">
<Value Code="M">Mænd</Value>
<Value Code="K">Kvinder</Value>
</Variable>
<Variable Code="V5" Text="alder" Prescat="S" Presid="4">
<Value Code="1829">18-29 år</Value>
<Value Code="3039">30-39 år</Value>
<Value Code="4049">40-49 år</Value>
<Value Code="5059">50-59 år</Value>
<Value Code="6069">60-69 år</Value>
<Value Code="7099">70 år og derover</Value>
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
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="101" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="183" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="230" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="400" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="253" >7.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="265" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="320" >7.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="360" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="420" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="430" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="440" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="482" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="410" >7.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="480" >7.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="450" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="461" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="479" >7.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="492" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="530" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="561" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="563" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="607" >6.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="510" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="621" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="540" >7.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="550" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="573" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="575" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="630" >6.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="580" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="746" >7.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="751" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="657" >7.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="760" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="773" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="840" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="820" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="1829" V6="851" >7.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="101" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="183" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="230" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="400" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="253" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="265" >7.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="320" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="360" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="420" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="430" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="440" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="482" >8.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="410" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="480" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="450" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="461" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="479" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="492" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="530" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="561" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="563" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="607" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="510" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="621" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="540" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="550" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="573" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="575" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="630" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="580" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="746" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="751" >7.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="657" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="760" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="773" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="840" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="820" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="3039" V6="851" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="101" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="183" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="230" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="400" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="253" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="265" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="320" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="360" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="420" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="430" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="440" >7.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="482" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="410" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="480" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="450" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="461" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="479" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="492" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="530" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="561" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="563" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="607" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="510" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="621" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="540" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="550" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="573" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="575" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="630" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="580" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="746" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="751" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="657" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="760" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="773" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="840" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="820" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="4049" V6="851" >7.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="101" >7.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="183" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="230" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="400" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="253" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="265" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="320" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="360" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="420" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="430" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="440" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="482" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="410" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="480" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="450" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="461" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="479" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="492" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="530" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="561" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="563" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="607" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="510" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="621" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="540" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="550" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="573" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="575" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="630" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="580" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="746" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="751" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="657" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="760" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="773" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="840" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="820" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="5059" V6="851" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="101" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="183" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="230" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="400" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="253" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="265" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="320" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="360" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="420" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="430" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="440" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="482" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="410" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="480" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="450" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="461" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="479" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="492" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="530" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="561" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="563" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="607" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="510" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="621" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="540" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="550" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="573" >8.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="575" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="630" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="580" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="746" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="751" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="657" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="760" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="773" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="840" >8.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="820" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="6069" V6="851" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="101" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="183" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="230" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="400" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="253" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="265" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="320" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="360" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="420" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="430" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="440" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="482" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="410" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="480" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="450" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="461" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="479" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="492" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="530" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="561" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="563" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="607" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="510" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="621" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="540" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="550" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="573" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="575" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="630" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="580" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="746" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="751" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="657" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="760" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="773" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="840" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="820" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="M" V5="7099" V6="851" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="101" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="183" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="230" >7.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="400" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="253" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="265" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="320" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="360" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="420" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="430" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="440" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="482" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="410" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="480" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="450" >7.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="461" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="479" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="492" >6.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="530" >7.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="561" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="563" >7.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="607" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="510" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="621" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="540" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="550" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="573" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="575" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="630" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="580" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="746" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="751" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="657" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="760" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="773" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="840" >7.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="820" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="1829" V6="851" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="101" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="183" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="230" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="400" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="253" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="265" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="320" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="360" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="420" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="430" >7.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="440" >7.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="482" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="410" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="480" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="450" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="461" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="479" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="492" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="530" >7.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="561" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="563" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="607" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="510" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="621" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="540" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="550" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="573" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="575" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="630" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="580" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="746" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="751" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="657" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="760" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="773" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="840" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="820" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="3039" V6="851" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="101" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="183" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="230" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="400" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="253" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="265" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="320" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="360" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="420" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="430" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="440" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="482" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="410" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="480" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="450" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="461" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="479" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="492" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="530" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="561" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="563" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="607" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="510" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="621" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="540" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="550" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="573" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="575" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="630" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="580" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="746" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="751" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="657" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="760" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="773" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="840" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="820" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="4049" V6="851" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="101" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="183" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="230" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="400" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="253" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="265" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="320" >7.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="360" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="420" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="430" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="440" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="482" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="410" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="480" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="450" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="461" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="479" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="492" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="530" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="561" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="563" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="607" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="510" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="621" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="540" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="550" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="573" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="575" >7.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="630" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="580" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="746" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="751" >7.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="657" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="760" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="773" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="840" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="820" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="5059" V6="851" >7.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="101" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="183" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="230" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="400" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="253" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="265" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="320" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="360" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="420" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="430" >8.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="440" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="482" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="410" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="480" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="450" >8.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="461" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="479" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="492" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="530" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="561" >8.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="563" >8.6</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="607" >8.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="510" >8.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="621" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="540" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="550" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="573" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="575" >8.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="630" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="580" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="746" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="751" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="657" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="760" >8.9</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="773" >8.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="840" >8.7</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="820" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="6069" V6="851" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="101" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="183" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="230" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="400" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="253" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="265" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="320" >8.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="360" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="420" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="430" >8.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="440" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="482" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="410" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="480" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="450" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="461" >8.0</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="479" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="492" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="530" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="561" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="563" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="607" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="510" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="621" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="540" >7.8</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="550" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="573" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="575" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="630" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="580" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="746" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="751" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="657" >8.2</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="760" >8.1</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="773" >8.4</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="840" >8.5</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="820" >8.3</No>
<No V1="2015" V2="S81" V3="S12" V4="K" V5="7099" V6="851" >8.0</No>
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
