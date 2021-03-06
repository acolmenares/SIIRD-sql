USE [IRDCOL]
GO
/****** Object:  UserDefinedFunction [dbo].[MR_Personas_Educacion]    Script Date: 02/mar/2016 09:25:09 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<918 segunda, >
-- =============================================
ALTER FUNCTION [dbo].[MR_Personas_Educacion]
(
	@Id_Persona int,
	@Id_Tipo_Entrega int,
	@FechaCorte date
	
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	
	
	if( @FechaCorte is null) SET @FechaCorte=(CONVERT(VARCHAR(10),GETDATE(),103))

	-- Add the T-SQL statements to compute the return value here
	return ( 
	select top 1 Personas_Educacion.Id  from Personas_Educacion
	where Personas_Educacion.Id_Persona=@Id_Persona
	and Personas_Educacion.Id_Tipo_Entrega= @Id_Tipo_Entrega --918 -- segunda
	and Personas_Educacion.Fecha<=@FechaCorte
	order by Personas_Educacion.Fecha desc, Personas_Educacion.Id desc
	)

	
	

END
