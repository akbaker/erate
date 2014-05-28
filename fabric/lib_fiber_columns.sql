--LIBRARY FIBER COLUMNS

--CAI
alter table fabric.imls_cai
add column fiber int;

update fabric.imls_cai
set fiber = 1
where transtech = 50;

update fabric.imls_cai
set fiber = -1
where transtech <> 50 AND transtech <> -999;

update fabric.imls_cai
set fiber = 0
where transtech = -999;

select *
from fabric.imls_cai;

select fiber, count(*)
from fabric.imls_cai
group by fiber;

--KANSAS
alter table fabric.ks_lib
add column fiber int;

update fabric.ks_lib
set fiber = 1
where download_speed > 100;

update fabric.ks_lib
set fiber = -1
where cxn_type = 'T-1' OR download_speed IS NULL;

update fabric.ks_lib
set fiber = 0
where download_speed < 100 AND cxn_type IS NULL;

select fiber, count(*)
from fabric.ks_lib
group by fiber;

--NEW JERSEY
alter table fabric.nj_lib
add column fiber int;

update fabric.nj_lib
set fiber = 1
where transtech = 50;

update fabric.nj_lib
set fiber = -1
where transtech <> 50 AND transtech <> -9999;

update fabric.nj_lib
set fiber = 1
where downspeed_tier > 9 AND transtech IS NULL;

update fabric.nj_lib
set fiber = 0
where downspeed_tier < 10 AND transtech IS NULL;

update fabric.nj_lib
set fiber = 0
where downspeed_tier IS NULL AND transtech IS NULL;

select fiber, count(*)
from fabric.nj_lib
group by fiber;

--MISSOURI
alter table fabric.mo_lib
add column fiber int;

update fabric.mo_lib
set fiber = 1
where mb13_14 >= 100;

update fabric.mo_lib
set fiber = 0
where mb13_14 < 100;