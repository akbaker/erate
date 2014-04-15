select count(*)
from fabric.cci
where cai_type = 'Schools (K-12)';
--Count: 5,298

select state, count(*)
from fabric.cci
where cai_type = 'Schools (K-12)'
group by state
andder by count desc;

--NC: 1836
--IA: 559
--WV: 441
--OH: 410
--SD: 247
--CT: 219
--IL: 198
--VA: 146

select school_name, org_name, service_address, lstreet, lstate
from analysis.nces_pub_full, fabric.cci
where nces_pub_full.school_name = upper(cci.org_name)
	and nces_pub_full.lstate = cci.state
	and nces_pub_full.lcity = upper(cci.city)
	and cai_type = 'Schools (K-12)';
--Match: 1,873

select state, count(*)
from analysis.nces_pub_full, fabric.cci
where nces_pub_full.school_name = upper(cci.andg_name)
	and nces_pub_full.lstate = cci.state
	and nces_pub_full.lcity = upper(cci.city)
	and cai_type = 'Schools (K-12)'
group by state
andder by count desc;

--MATCHES
--NC: 1156/1836
--IA: 559
--WV: 250/441
--OH: 72/410
--SD: 247
--CT: 93/219
--IL: 96/198
--VA: 33/146

--IOWA
select school_id, school_name, org_name
from analysis.nces_pub_full, fabric.cci
where nces_pub_full.lstreet = upper(cci.service_address)
	and nces_pub_full.lcity = upper(cci.city)
	and nces_pub_full.lstate = cci.state
	and cai_type = 'Schools (K-12)'
	and (school_id <> '010264001385' and school_id <> '010264001385' and school_id <> '010264001386'
		 and school_id <> '080453000664' and school_id <> '090057000113' and school_id <> '090219001529'
		 and school_id <> '090498001043' and school_id <> '090330000664' and school_id <> '090002801366'
		 and school_id <> '090015001373' and school_id <> '090432000864' and school_id <> '090339000713'
		 and school_id <> '110008200441' and school_id <> '130258002727' and school_id <> '190822000419'
		 and school_id <> '190798000398' and school_id <> '191329000415' and school_id <> '192244001345'
		 and school_id <> '192244000523' and school_id <> '190549000173' and school_id <> '190393000412'
		 and school_id <> '190575001620' and school_id <> '190575000176' and school_id <> '191104000682'
		 and school_id <> '191311000170' and school_id <> '190001501485' and school_id <> '192253001355'
		 and school_id <> '190330000024' and school_id <> '190597000203' and school_id <> '192466001414'
		 and school_id <> '193063000990' and school_id <> '190897000232' and school_id <> '190897002128'
		 and school_id <> '190897002082' and school_id <> '192820001644' and school_id <> '192058000712'
		 and school_id <> '192058000713' and school_id <> '192058001217' and school_id <> '191095000676'
		 and school_id <> '191830001049' and school_id <> '190003201317' and school_id <> '190873001501'
		 and school_id <> '192172001296' and school_id <> '190375000081' and school_id <> '192085001246'
		 and school_id <> '192871002058' and school_id <> '190693000303' and school_id <> '190693000305'
		 and school_id <> '190402000013' and school_id <> '190402000099' and school_id <> '190474000134'
		 and school_id <> '192802001635' and school_id <> '192802001636' and school_id <> '192556001459'
		 and school_id <> '199901901259' and school_id <> '190912000595' and school_id <> '190309000006'
		 and school_id <> '192799001630' and school_id <> '192799000309' and school_id <> '190684000293'
		 and school_id <> '190678001998' and school_id <> '190678000284' and school_id <> '191269000525'
		 and school_id <> '190786000104' and school_id <> '190786000761' and school_id <> '190786000388'
		 and school_id <> '190786000389' and school_id <> '190786002113' and school_id <> '190786000387'
		 and school_id <> '190786000391' and school_id <> '190945000600' and school_id <> '193135001830'
		 and school_id <> '190960000631' and school_id <> '190960000629' and school_id <> '193096000331'
		 and school_id <> '190468001436' and school_id <> '191071000673' and school_id <> '192316001403'
		 and school_id <> '192211002034' and school_id <> '190627000214' and school_id <> '193192001861'
		 and school_id <> '191518000913' and school_id <> '191266001401' and school_id <> '192412001405'
		 and school_id <> '192901001671' and school_id <> '191041000665' and school_id <> '192067001230'
		 and school_id <> '192238001338' and school_id <> '192112001888' and school_id <> '192112001267'
		 and school_id <> '192667001551' and school_id <> '192541001452' and school_id <> '191488000912'
		 and school_id <> '190322001938' and school_id <> '190322001937' and school_id <> '191332000805'
		 and school_id <> '191152000702' and school_id <> '192415001409' and school_id <> '191034001433'
		 and school_id <> '190792000394' and school_id <> '170942000548' and school_id <> '240021001349'
		 and school_id <> '240051000865' and school_id <> '240051001067' and school_id <> '240015001344'
		 and school_id <> '231110000406' and school_id <> '231478200246' and school_id <> '231101000176'
		 and school_id <> '230828000226' and school_id <> '231167001010' and school_id <> '261119008022'
		 and school_id <> '270819004415' and school_id <> '270001203287' and school_id <> '270001202262'
		 and school_id <> '270001203292' and school_id <> '270001203290' and school_id <> '270001203295'
		 and school_id <> '270001203296' and school_id <> '270001203294' and school_id <> '270001202263'
		 and school_id <> '270001203289' and school_id <> '690003000004' and school_id <> '690003000007'
		 and school_id <> '690003000047' and school_id <> '690003000046' and school_id <> '690003000006'
		 and school_id <> '690003000018' and school_id <> '370420003231' and school_id <> '370387001548'
		 and school_id <> '370342003005' and school_id <> '370108002374' and school_id <> '370268002875'
		 and school_id <> '370177000734' and school_id <> '370472002805' and school_id <> '370297001291'
		 and school_id <> '370225000973' and school_id <> '370204000911' and school_id <> '370225000968'
		 and school_id <> '317802001674' and school_id <> '390479003035' and school_id <> '390494303589'
		 and school_id <> '390472102804' and school_id <> '390472102803' and school_id <> '390021104735'
		 and school_id <> '390029104828' and school_id <> '390472002801' and school_id <> '390472002800'
		 and school_id <> '390467802652' and school_id <> '390467802652' and school_id <> '390442905450'
		 and school_id <> '391000901626' and school_id <> '390451002014' and school_id <> '390465202586'
		 and school_id <> '390465205594' and school_id <> '390465202582' and school_id <> '390029704834'
		 and school_id <> '390132605397' and school_id <> '390494603606' and school_id <> '390494603605'
		 and school_id <> '390050805218' and school_id <> '390001901514' and school_id <> '390047805037'
		 and school_id <> '390052305233' and school_id <> '390141805616' and school_id <> '390052505235'
		 and school_id <> '390465102581' and school_id <> '390465102578' and school_id <> '390465102580'
		 and school_id <> '390446101483' and school_id <> '390494403592' and school_id <> '410883000081'
		 and school_id <> '410883001584' and school_id <> '410883001686' and school_id <> '410883001716'
		 and school_id <> '410883000094' and school_id <> '440114000313' and school_id <> '440021000355'
		 and school_id <> '467830000012' and school_id <> '467830000016' and school_id <> '463049000647'
		 and school_id <> '463049000630' and school_id <> '460004601164' and school_id <> '461785000163'
		 and school_id <> '460004200939' and school_id <> '460004200656' and school_id <> '466518000568'
		 and school_id <> '466518000933' and school_id <> '468043701249' and school_id <> '467746000732'
		 and school_id <> '466546001273' and school_id <> '550852003356' and school_id <> '540162001427');


--SOUTH DAKOTA
alter table analysis.nces_pub_full
add column school_name_sd character varying(200);

update analysis.nces_pub_full
set school_name_sd = school_name
where lstate = 'SD';

update analysis.nces_pub_full
set school_name_sd = substring(school_name_sd, -4)

with new_values as(
select school_id, left(school_name_sd, octet_length(school_name_sd) - (octet_length(school_name_sd) - position('-' in school_name_sd))) as school_name
from analysis.nces_pub_full
where lstate = 'SD'
)
update analysis.nces_pub_full
set school_name_sd = new_values.school_name
from new_values
where new_values.school_id = nces_pub_full.school_id;

update analysis.nces_pub_full
set school_name_sd = regexp_replace(school_name_sd,'-','');

update analysis.nces_pub_full
set school_name_sd = trim(both from school_name_sd);

select school_name_sd, org_name, service_address, lstreet, lstate
from analysis.nces_pub_full, fabric.cci
where nces_pub_full.school_name_sd = upper(cci.org_name)
	and nces_pub_full.lstate = cci.state
	and nces_pub_full.lcity = upper(cci.city)
	and cai_type = 'Schools (K-12)';
--88 matches