USE [IRDCOL]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[CYRConsultaxIndicadorEducacion]
		@Fecha_Atencion_Inicial = N'01.12.2015',
		@Fecha_Atencion_Final = N'31.12.2015',
		@Id_Regional = 1637,
		@Fecha_Corte = N'31.12.2015'

SELECT	'Return Value' = @return_value

GO
