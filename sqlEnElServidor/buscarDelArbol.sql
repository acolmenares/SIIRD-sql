/****** Script for SelectTopNRows command from SSMS  ******/
use IRDCOL

select 
a.Descripcion, ap.Descripcion as procedimiento
from CYR_Arbol a 
join CYR_Arbol_Procesos ap on a.Id= ap.Id_CYR_Arbol
where a.Descripcion='Cantidad de Entregas'

