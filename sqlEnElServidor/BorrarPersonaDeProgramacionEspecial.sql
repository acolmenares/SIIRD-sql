use IRDCOL;

declare @documento varchar(25) ='16365973' --'36382499'  --'1075307801' --'96357409';

select p.* from Declaracion_Estados p 
where p.Id_Declaracion=(
   select  top  1 id_declaracion from  personas where identificacion=@documento order by Id desc
   )
  and
  p.Id_Tipo_Estado=4038 -- programado
  and   not p.Id_Programa is null


select * from
-- delete from 
Declaracion_Estados where Id= 
(
select p.Id from Declaracion_Estados p 
where p.Id_Declaracion=(
   select  top  1 id_declaracion from  personas where identificacion=@documento order by Id desc
   )
  and
  p.Id_Tipo_Estado=4038 -- programado
  and   not p.Id_Programa is null
) 
--x


select p.* from Declaracion_Estados p 
where p.Id_Declaracion=(
   select  top  1 id_declaracion from  personas where identificacion=@documento order by Id desc
   )
  and
  p.Id_Tipo_Estado=4038 -- programado
  and   not p.Id_Programa is null



--select * from SubTablas s where s.Id in (4036,4037,4038)

--select 