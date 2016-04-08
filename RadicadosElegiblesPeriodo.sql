-- tomado de registro inicial (Declaracion Ingreso)
use IRDCOL
declare @fechaRadicacionInicial varchar(8) = '20131001'
declare @fechaRadicacionFinal varchar(8) = '20160315'
declare @fechaCorte varchar(8) = @fechaRadicacionFinal
-- 118 Pendiente por Atender
-- 1117 Pogramado que no Asistió
-- 1392 Pendiente por programar

select  
detalle.LugarAtencion,
detalle.MesRadicacion,
Detalle.*
/*COUNT(detalle.Id) as Declaraciones_Radicados,
--SUM( case when  Detalle.Elegible='Si' and (Detalle.Id_Motivo_Noatender is null or Detalle.Id_Motivo_Noatender=1117) then 1 else 0 end) as Declaraciones_Elegibles,
--sum( case when  Detalle.Elegible='Si' and (Detalle.Id_Motivo_Noatender is null or Detalle.Id_Motivo_Noatender=1117) then Detalle.TFR else Detalle.TFE end ) as Personas_Radicadas,
--SUM( case when  Detalle.Elegible='Si' and (Detalle.Id_Motivo_Noatender is null or Detalle.Id_Motivo_Noatender=1117) then Detalle.TFR else 0 end) as Personas_Elegibles
SUM( case when  (Detalle.Id_Motivo_Noatender is null or Detalle.Id_Motivo_Noatender=1117) then 1 else 0 end) as Declaraciones_Elegibles,
sum( case when  (Detalle.Id_Motivo_Noatender is null or Detalle.Id_Motivo_Noatender=1117) then Detalle.TFR else Detalle.TFE end ) as Personas_Radicadas,
SUM( case when  (Detalle.Id_Motivo_Noatender is null or Detalle.Id_Motivo_Noatender=1117) then Detalle.TFR else 0 end) as Personas_Elegibles
*/
from 
(
select 
d.Id,
d.Fecha_Radicacion,
d.Fecha_Declaracion,
CONVERT(CHAR(6),D.Fecha_Radicacion,112)  as MesRadicacion,
CONVERT(CHAR(6),D.Fecha_Valoracion,112)  as MesValoracion,
d.Id_Regional, 
d.Id_lugar_fuente,
LugarAtencion.Descripcion as LugarAtencion,
elegible.Descripcion as Elegible,
Atender.Descripcion as Atender, 
d.Id_Motivo_Noatender,
NoAtender.Descripcion as MotivoNoAtender,
d.Fecha_Valoracion as Fecha_Atencion,
isnull(d.Menores_Ninas,0) + ISNULL(d.Menores_Ninos,0) + ISNULL(d.Lactantes,0)+ISNULL(d.Recien_Nacidos,0)+
ISNULL(d.Gestantes,0) + ISNULL(d.Resto_Nucleo,0) as TFE,
PerCount.TotalPersonas as TFR 
from Declaracion d
left join (
    select Personas.Id_Declaracion, COUNT(Id) as TotalPersonas 
    from Personas 
    group by Personas.Id_Declaracion 
) as PerCount on PerCount.Id_Declaracion=d.Id

left join Declaracion_Estados de
	on   de.Id= ( 
	select top 1 Declaracion_Estados.Id  
	from Declaracion_Estados
	where Declaracion_Estados.Id_Declaracion=d.Id 
	and Declaracion_Estados.Id_Tipo_Estado=4036  --elegible
	and Declaracion_Estados.Fecha<=@FechaCorte
	order by Declaracion_Estados.Fecha desc, Declaracion_estados.Id desc
)
left join SubTablas Elegible on Elegible.Id= de.Id_Como_Estado
left join SubTablas Atender on Atender.Id= d.Id_atender
left join SubTablas LugarAtencion on LugarAtencion.Id = d.Id_lugar_fuente
left join SubTablas NoAtender on NoAtender.Id= d.Id_Motivo_Noatender

where 
d.Fecha_Radicacion>=@fechaRadicacionInicial
and
d.Fecha_Radicacion<=@fechaRadicacionFinal
and
d.Tipo_Declaracion=921
and 
(d.Id_Regional = 1637 ) --4521   )
and 
(d.Id_lugar_fuente = 1645 ) -- 4095  )
 -- and d.Id_Motivo_Noatender=1117
 -- and Elegible.Descripcion='Si' and Atender.Descripcion='No'
) as Detalle
--group by Detalle.LugarAtencion, Detalle.MesRadicacion 
where (Detalle.Elegible='No' or Detalle.Elegible is null ) and ( Detalle.Id_Motivo_Noatender is null or Detalle.Id_Motivo_Noatender=1117)
order by Detalle.MesRadicacion 