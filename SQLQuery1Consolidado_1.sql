use [IRDCOL]

declare @FechaRadicacionInicial varchar(8)
declare @FechaRadicacionFinal varchar(8)
declare @FechaCorte varchar(8)

set @FechaRadicacionInicial = '20151001'
set @FechaRadicacionFinal =   '20160131'
set @FechaCorte = @FechaRadicacionFinal

select 
Declaracion.Id_Regional, 
CONVERT(CHAR(6),Declaracion.Fecha_Radicacion,112)  as Mes,
count(Declaracion.Id) as Radicado_Periodo,
sum( case when de.Id_Como_Estado=19 and  (Declaracion.Id_Atender=19 or Declaracion.Id_Atender is null)  then 1 else 0 end) as Elegible,
sum( case when de.Id_Como_Estado<>19 or Declaracion.Id_Atender=20 then 1 else 0 end) as NoElegible,
sum ( case when ( de.Id_Como_Estado=19 and  (Declaracion.Id_Atender=19 or Declaracion.Id_Atender is null) and CONVERT(CHAR(6),Declaracion.Fecha_Radicacion,112)= CONVERT(CHAR(6),Declaracion.Fecha_Valoracion,112)) then 1 else 0 end ) as Atendido_Mes,
sum ( case when ( de.Id_Como_Estado=19 and  (Declaracion.Id_Atender=19 or Declaracion.Id_Atender is null) and ( Declaracion.Fecha_valoracion is not null and  CONVERT(CHAR(6),Declaracion.Fecha_Radicacion,112)<> CONVERT(CHAR(6),Declaracion.Fecha_Valoracion,112)) ) then 1 else 0 end ) as Atendido_Otro_Mes,
sum ( case when ( de.Id_Como_Estado=19 and  (Declaracion.Id_Atender=19 or Declaracion.Id_Atender is null) and  Declaracion.Fecha_valoracion is null  ) then 1 else 0 end ) as PorAtender

from
Declaracion
left join Declaracion_Estados de
	on   de.Id= ( 
	select top 1 Declaracion_Estados.Id  
	from Declaracion_Estados
	where Declaracion_Estados.Id_Declaracion=Declaracion.Id 
	and Declaracion_Estados.Id_Tipo_Estado=4036
	and Declaracion_Estados.Fecha<=@FechaCorte
	order by Declaracion_Estados.Fecha, Declaracion_estados.Id desc
	)

where
Declaracion.Tipo_Declaracion=921
and  Declaracion.Fecha_Radicacion>=@FechaRadicacionInicial  
and Declaracion.Fecha_Radicacion<=@FechaRadicacionFinal
group by Declaracion.Id_Regional, CONVERT(CHAR(6),Declaracion.Fecha_Radicacion,112) 
order by Declaracion.Id_Regional, CONVERT(CHAR(6),Declaracion.Fecha_Radicacion,112)
