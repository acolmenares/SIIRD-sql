use IRDCOL

declare @fud varchar(25);
declare @identificacion varchar(25);
declare @Id_Declaracion int;

select @Id_Declaracion = d.Id 
from Declaracion d
join Personas P on p.Id_Declaracion= d.Id and p.Identificacion= @identificacion
where d.Numero_Declaracion=@fud 



if( not  @identificacion is null)
select 1
else
select 2
