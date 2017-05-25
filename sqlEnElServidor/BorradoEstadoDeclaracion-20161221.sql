use IRDCOL

declare @documento varchar(20)  = '1077852810';
declare @grupo varchar(20) = 'REGFF9-009(2)'

declare @declaracionId int ;
declare @programacionId int ;

set @declaracionId= (select top 1 p.Id_Declaracion from Personas p where  p.Identificacion= @documento order by p.Id desc);


set @programacionId= (select top 1 p.Id from Programacion p where p.Numero=@grupo);

select @declaracionId as DeclaracionId, @programacionId as ProgamaId;

select p.*  from Programacion p where p.Numero=@grupo

select 
* from Declaracion_Estados de 
where de.Id_Declaracion=@declaracionId and de.Id_Programa=@programacionId
order by de.Fecha desc, de.Id desc


--delete from Declaracion_Estados where Id=79418
--delete from Declaracion_Estados where Id=79466
--delete from Declaracion_Estados where Id=79420
--delete from Declaracion_Estados where Id=79468
--79419
--delete from Declaracion_Estados where Id=79467
--idusuari=157