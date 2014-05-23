select *
from analysis.nces_pub_full;

alter table analysis.nces_pub_full
drop column if exists ben;

select school_id, school_name, leaid, lea_name, lstate, school_loc, tot_students, rev_nces_id, applicant_type, ben
into fabric.nces_pub_ben
from analysis.nces_pub_full
left join fabric.ben_nces_xwalk
on ben_nces_xwalk.rev_nces_id = nces_pub_full.leaid;



select school_id, COUNT(*) as myCount
from fabric.nces_pub_ben
where ben IS NOT NULL
group by school_id
order by myCount desc;
--Rows: 118,332
--Schools with BEN: 89,265

select *
from fabric.nces_pub_ben
where school_id = '120039002468';