use [IRDCOL]
update Declaracion set Resto_Nucleo=3 where Id=
(select 
d.Id
from
Personas p
join Declaracion d
on d.Id= p.Id_Declaracion
where
p.Identificacion='1060207787'
and d.Resto_Nucleo=4