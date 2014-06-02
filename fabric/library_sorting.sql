--JOIN ON FRN: CHECK LINE/LOCATION COUNTS
select frn, count(*) as num_libraries
into fabric.block4_lib_count
from fabric.block4_may22_libonly
group by frn
order by frn;

select frn, sum(num_lines) as num_lines
into fabric.item24_cxns_lib_count
from fabric.item24_cxns_mar28
group by frn
order by frn;

select block4_lib_count.frn, num_libraries, num_lines
into fabric.block4_lib_check_counts
from fabric.block4_lib_count
left join fabric.item24_cxns_lib_count
on block4_lib_count.frn = item24_cxns_lib_count.frn
where num_lines >= num_libraries;

--JOIN ON FRN: KEEP ONLY LIBRARIES WITH CXNS
select funding_year, f471_appnum, block4_may22_libonly.frn, block5_item22, sub_worksheet, entity_rcv_svc_num
	entity_rcv_name, entity_rcv_type, nces_code, rural_urban, student_count, student_nslp_count, 
	nslp_eligible_pct, discount_pct, weighted_product, prek_adult_juvenile_flag, alt_discount_mechanism_flag,
	num_libraries, num_lines
into fabric.block4_cxns_libonly
from fabric.block4_may22_libonly, fabric.block4_lib_check_counts
where block4_may22_libonly.frn = block4_lib_check_counts.frn;

select *
from fabric.block4_cxns_libonly;

--CREATE COLUMN FOR SORTING
alter table fabric.block4_cxns_libonly
drop column if exists size_sort;

alter table fabric.block4_cxns_libonly
add column size_sort int;

--CREATE COLUMNS FOR ASSIGNING CXNS
alter table fabric.block4_cxns_libonly
drop column if exists type_cxn;

alter table fabric.block4_cxns_libonly
add column type_cxn character varying(50);

alter table fabric.block4_cxns_libonly
drop column if exists download_speed;

alter table fabric.block4_cxns_libonly
add column download_speed double precision;