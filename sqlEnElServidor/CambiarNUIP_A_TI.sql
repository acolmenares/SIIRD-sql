use IRDCOL

declare @identificacion varchar(12) = '1117816701';
declare @nuip int = 3071
declare @ti int = 2
--select * from SubTablas s where s.Id_Tabla=1-- s.Descripcion like '%nuip%' 

--cambiarNuip_a_TI 
-- 3071 a 2

--select p.Id_Tipo_Identificacion from Personas p where p.Identificacion='1117816702'

Update Personas set Id_Tipo_Identificacion=@ti 
where Identificacion=@identificacion and Id_Tipo_Identificacion=@nuip
