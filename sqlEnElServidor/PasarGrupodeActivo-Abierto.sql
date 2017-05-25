
/* reabrir programacion: pasarlo de activado 214  a abietro 213 */
use [IRDCOL]

--select * from SubTablas s where s.Id=213
declare @Id_Programa int;
declare @Id_Salida int;
declare @Grupo_Programacion varchar(16);
declare @Id_Activado int;
declare @Id_Abierto int;
declare @Id_Asignado int;
declare @Id_Cerrado int;

set @Grupo_Programacion=  'REGPP9-008(1)'  --   'REGPP9-007(2)' --'REGFF9-008(E)' --'RegFF8-040(2)'

set @Id_Cerrado = 217;
set @Id_Asignado = 215;
set @Id_Activado=214;
set @Id_Abierto=213;


set @Id_Programa=
(
select 
pr.Id 
from 
Programacion pr 
where 
pr.Numero=@Grupo_Programacion and pr.Id_Estado=@Id_Activado -- activado
)
select @Id_Programa

delete from Personas_Entregas  where Id_Programa= @Id_Programa;

set @Id_Salida=
(
select 
s.Id 
from 
Salidas s 
where 
s.Id_Programa= @Id_Programa
)


delete  from Salidas_Detalle_Entradas where Id_Salida_Detalle in
(
select sd.Id from Salidas_Detalle sd where sd.Id_Salida= @Id_Salida
)

-- Borra de Salidad_Detalle los registros asociados a la salida ....
delete  from Salidas_Detalle where Id_Salida= @Id_Salida;


--select * from Salidas s where s.Id=@Id_Salida and s.Id_Programa=@Id_Programa
delete  from Salidas  where Id=@Id_Salida and Id_Programa=@Id_Programa

Update Programacion set Id_Estado=@Id_Abierto where Numero=@Grupo_Programacion and Id_Estado=@Id_Activado

