USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[PersonasConsultarPorFiltroEducacion]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[PersonasConsultarPorFiltroEducacion]

@id_grupo int = null, 
@identificacion nvarchar(100) = null,
@nombre nvarchar(100) =  null, 
@id_regional int = null,
@Fecha_Inicial_Entrega nvarchar(11) = null,
@Fecha_Final_Entrega nvarchar(11) = null,
@wdeclarante int = null,
@Id_LugarEntrega int = null,
@Pendiente bit
As

Declare @Squery varchar(8000);
SET NOCOUNT ON;
SET Dateformat DMY;

declare @FecIniEnt varchar(20);
declare @FecFinEnt varchar(20);


Set @FecIniEnt = @Fecha_Inicial_Entrega + ' 00:00:00'
Set @FecFinEnt = @Fecha_Final_Entrega + ' 23:59:59'



Set @Squery = '
SELECT Personas.*
FROM Declaracion
LEFT OUTER JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion
LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.id
Where personas.edad >=6 and personas.edad <= 17 ';


if @id_Grupo is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.id_grupo = ' + cast(@id_Grupo as varchar) ;
End

If @identificacion is not null
Begin
Set @Squery = @Squery + 'AND Personas.identificacion like ''%' + cast(@identificacion as varchar(100)) + '%''';
End

If @nombre is not null
Begin
Set @Squery = @Squery + 'AND (Personas.Primer_Nombre like ''%' + cast(@nombre as varchar(100)) + '%''
   or Personas.Primer_Apellido like ''%' + cast(@nombre as varchar(100)) + '%'')';
End

if @id_Regional is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.id_regional = ' + cast(@id_Regional as varchar) ;
End

If (@Fecha_Inicial_Entrega is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniEnt as varchar) + ''''
End

If (@Fecha_Final_Entrega is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinEnt as varchar) + ''''
End

if @wdeclarante is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.tipo_declaracion  = ' + cast(@wdeclarante as varchar) ;
End

if @Id_LugarEntrega  is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Lugar_Fuente = ' + cast(@Id_LugarEntrega as varchar) ;
End

if @Pendiente = 1
Begin


Set @Squery = @Squery + ' and personas.Id not in ( select Pers.id
  from Personas pers where Id_Motivo_NoEstudio = 1693 and pers.id = personas.Id) '
  
Set @Squery = @Squery + ' and personas.Id not in ( select Pers.id
  from Personas pers where Id_Estudia_Actualmente = 19
  and Id_Certificado = 19 and pers.id = personas.Id) '

Set @Squery = @Squery + ' and personas.id not in ( Select id_persona from
	Personas_Educacion where Id_Motivo_NoEstudia  = 1693 and Id_Tipo_Entrega = 918 
	and Id_Certificado_Matricula = 19 and Id_Persona = personas.id)'
	 
Set @Squery = @Squery + ' and personas.id not in ( Select id_persona from
	Personas_Educacion where Id_Motivo_NoEstudia  = 1693 and Id_Tipo_Entrega = 919
	and Id_Certificado_Matricula = 19 and Id_Persona = personas.id)'

Set @Squery = @Squery + ' and personas.id not in ( Select id_persona from
	Personas_Educacion where Id_Estudia_Actualmente = 19 and Id_Tipo_Entrega = 918
	and Id_Certificado_Matricula = 19 and Id_Persona = personas.id)'

Set @Squery = @Squery + ' and personas.id not in ( Select id_persona from
	Personas_Educacion where Id_Estudia_Actualmente = 19 and Id_Tipo_Entrega = 919
	and Id_Certificado_Matricula = 19 and Id_Persona = personas.id)'

Set @Squery = @Squery + ' and personas.id not in ( Select id_persona from
	Personas_Educacion where Id_Estudia_Actualmente = 19 and Id_Tipo_Entrega = 919
	and verificado_entidad = 1 and Id_Persona = personas.id)'

End


--print(@Squery)
exec (@Squery)
