use IRDSEG

select
pr.Descripcion as Perfil,
pg.Descripcion as Pagina,
pg.Url, 
pp.Pver,
pp.Pconsultar,
pp.Pcrear,
pp.Peditar,
pp.Peliminar,
pp.Pvertodo,
pp.Pexportarexcel,
pp.Pexportarcsv,
pp.Pexportarpdf,
pp.Pexportarword,
pp.Pcontrolvisible
from 
Permisos_Perfil pp
left join Perfiles pr on pr.Id= pp.Id_Perfil
left join Paginas  pg on pg.Id= pp.Id_Pagina
order by pr.Descripcion