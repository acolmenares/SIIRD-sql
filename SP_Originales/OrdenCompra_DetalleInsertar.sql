USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[OrdenCompra_DetalleInsertar]    Script Date: 07/mar/2016 01:47:21 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[OrdenCompra_DetalleInsertar]
@Id_OrdenCompra int, @Id_Producto int, @Id_Unidad_Medida int, @Cantidad numeric(18, 2), @Valor_Unitario numeric(18, 2), @Activo bit, @Motivo_Cancelacion nvarchar(100), @Id_Usuario_Inactivo int, @Fecha_Creacion datetime, @Id_Usuario_Creacion int, @Fecha_Modificacion datetime, @Id_Usuario_Modificacion int, @Id_Nivel int, @Descripcion_General nvarchar(1200),
@Codigo_Proyecto nvarchar(10), @Fecha_Cierre datetime, @Cierre bit
AS

INSERT OrdenCompra_Detalle
(
Id_OrdenCompra, Id_Producto, Id_Unidad_Medida, Cantidad, Valor_Unitario, Activo, Motivo_Cancelacion, Id_Usuario_Inactivo, Fecha_Creacion, Id_Usuario_Creacion, Fecha_Modificacion, Id_Usuario_Modificacion, Id_Nivel,  Descripcion_General, Codigo_Proyecto, Fecha_Cierre , Cierre
)
VALUES
(
@Id_OrdenCompra, @Id_Producto, @Id_Unidad_Medida, @Cantidad, @Valor_Unitario, @Activo, @Motivo_Cancelacion, @Id_Usuario_Inactivo, @Fecha_Creacion, @Id_Usuario_Creacion, @Fecha_Modificacion, @Id_Usuario_Modificacion, @Id_Nivel ,  @Descripcion_General , @Codigo_Proyecto, @Fecha_Cierre , @Cierre 
)
SELECT SCOPE_IDENTITY()
