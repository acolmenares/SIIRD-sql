USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[ProgramacionConsultarBusquedaPorEstado]    Script Date: 15/abr/2016 09:58:09 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
       
ALTER procedure [dbo].[ProgramacionConsultarBusquedaPorEstado]
@Id_Regional int = null,
@Id_Grupo int = null,
@Id_Lugar_Entrega int = null, 
@Id_Estado int = null

As

Declare @Squery nvarchar(4000);
SET NOCOUNT ON;
SET Dateformat DMY;


Set @Squery = '
SELECT     *
from Programacion where 1=1 ';

if @Id_Estado is not null
Begin
Set @Squery = @Squery + ' AND Id_Estado = ' + cast(@Id_Estado as varchar)
End

if @Id_Regional is not null
Begin
Set @Squery = @Squery + ' AND Id_Regional = ' + cast(@Id_Regional as varchar)
End

if @Id_Grupo is not null
Begin
Set @Squery = @Squery + ' AND Id_Grupo = ' + cast(@Id_Grupo as varchar)
End

if @Id_Lugar_Entrega is not null
Begin
Set @Squery = @Squery + ' AND Id_LugarEntrega = ' + cast(@Id_Lugar_Entrega as varchar)
End

Set @Squery = @Squery + ' Order by Numero '
--print(@Squery)
exec (@Squery)
