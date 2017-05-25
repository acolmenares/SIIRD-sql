use IRDCOL
declare @documento varchar(20)  = 1064676760  --'1006998100' --'1077852810';
declare  @Id_Elegible int = 4036
--declare @grupo varchar(20) = 'REGFF9-009(2)'

declare @declaracionId int ;
declare @programacionId int ;

set @declaracionId= (select top 1 p.Id_Declaracion from Personas p where  p.Identificacion= @documento order by p.Id desc);


select 
* from Declaracion_Estados de 
where de.Id_Declaracion=@declaracionId 
and de.Id_Tipo_Estado=@Id_Elegible
order by de.Fecha desc, de.Id desc



-- -- delete from Declaracion where id=81171
--delete from Declaracion_Estados where id= 81543   --81171