
use IRDCOL;
declare @identificacion varchar(15) = '40768488'
declare @grupo varchar(35) = 'RegFF8-023(01)UNIDAD'

delete  from Declaracion_Estados where Id= (

select p.Id from Declaracion_Estados p 
where p.Id_Declaracion=(
   select  top  1 id_declaracion from  personas where identificacion=@identificacion order by Id desc
   )
  and
  p.Id_Tipo_Estado=4039 -- reprogramado
  and   not p.Id_Programa is null
  and  p.Id_Programa = (select Id from Programacion p where p.Numero=@grupo)
)

--select * from SubTablas s where s.Id in (4036,4037,4038, 4039)
/*
select p.* from Declaracion_Estados p 
where p.Id_Declaracion=(
   select  top  1 id_declaracion from  personas where identificacion='40768488' order by Id desc
   )
  and
  p.Id_Tipo_Estado=4039 -- programado
  and   not p.Id_Programa is null
  and  p.Id_Programa = (select Id from Programacion p where p.Numero='RegFF8-023(01)UNIDAD')
*/
--select * from Programacion p where p.Numero='RegFF8-023(01)UNIDAD'
