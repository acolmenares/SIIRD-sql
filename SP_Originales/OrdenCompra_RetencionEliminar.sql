USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[OrdenCompra_RetencionEliminar]    Script Date: 07/mar/2016 01:57:04 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[OrdenCompra_RetencionEliminar]
@Id int
AS
Delete
FROM OrdenCompra_Retencion
WHERE Id = @Id