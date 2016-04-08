USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[OrdenCompra_DetalleActualizar]    Script Date: 07/mar/2016 11:38:26 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[OrdenCompra_DetalleActualizar]
@Id int, @Id_OrdenCompra int, @Id_Producto int,  @Id_Unidad_Medida int, @Cantidad numeric(18, 2), @Valor_Unitario numeric(18, 2), @Activo bit, @Motivo_Cancelacion nvarchar(100), @Id_Usuario_Inactivo int, @Fecha_Creacion datetime, @Id_Usuario_Creacion int, @Fecha_Modificacion datetime, @Id_Usuario_Modificacion int, @Id_Nivel int, @Descripcion_General nvarchar(1200), @Codigo_Proyecto nvarchar(10), @Fecha_Cierre datetime, @Cierre bit
AS
BEGIN
DECLARE @Aprobacion_Financiera bit;
SELECT 
@Aprobacion_Financiera= oc.Aprobacion_Financiera
FROM 
OrdenCompra oc 
where
oc.Id= @Id_OrdenCompra

if( @Aprobacion_Financiera=1)
begin
RAISERROR ('Eror : Registro Aprobado por Financiera !', 18,1);
return -1
end
else
UPDATE OrdenCompra_Detalle
SET Id_OrdenCompra = @Id_OrdenCompra, Id_Producto = @Id_Producto,  Id_Unidad_Medida = @Id_Unidad_Medida, Cantidad = @Cantidad, Valor_Unitario = @Valor_Unitario, Activo = @Activo, Motivo_Cancelacion = @Motivo_Cancelacion, Id_Usuario_Inactivo = @Id_Usuario_Inactivo, Fecha_Creacion = @Fecha_Creacion, Id_Usuario_Creacion = @Id_Usuario_Creacion, Fecha_Modificacion = @Fecha_Modificacion, Id_Usuario_Modificacion = @Id_Usuario_Modificacion
, Id_Nivel = @Id_Nivel , Descripcion_General = @Descripcion_General , Codigo_Proyecto = @Codigo_Proyecto , Fecha_Cierre =  @Fecha_Cierre ,Cierre =  @Cierre 
WHERE Id = @Id
END
