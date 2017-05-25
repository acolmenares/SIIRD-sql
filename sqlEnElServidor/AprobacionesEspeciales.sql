
use IRDCOL;
declare @Numero varchar(25);
--set @Numero= 'OCBOG9009';--
--set @Numero= 'OCBOG9019';--
--set @Numero= 'OCBOG9020';--
set @Numero= 'OCBOG9064';--

update 
OrdenCompra set 
Aprobacion_CooLogistica=1, 
Aprobacion_Coordinacion=1,
Aprobacion_Logistica_Ofc=1,
Aprobacion_Finanzas_Ofc=1
where Numero=@Numero

select * from OrdenCompra oc where oc.Numero=@Numero

--select * from SubTablas b where b.Descripcion='La Caqueteña'
/*
select * from Entradas where ID in  (1854, 1859)
select * from Entradas_Detalle ed where ed.Id_Entrada in (1854, 1859)
select * from Entradas_Distribucion where Id_Entrada_Detalle in (
select Id from Entradas_Detalle ed where ed.Id_Entrada in (1854, 1859)

)
*/