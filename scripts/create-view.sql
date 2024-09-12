create view vw_foco_por_municipio as
select cd_municipio, count(*) qt_foco
from foco_queimada_municipio fqm 
group by cd_municipio;

create view vw_foco_queimada_por_data as
select cast(dt_foco as date) dt_foco, count(*) qt_foco
from foco_queimada_municipio fqm 
group by cast(dt_foco as date)

