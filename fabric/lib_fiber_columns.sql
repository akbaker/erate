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

select fiber, count(*)
from fabric.imls_cai
group by fiber;