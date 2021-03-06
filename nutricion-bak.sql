USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[CYRConsultaxIndicadorNutricion]    Script Date: 04/01/2016 15:51:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -- exec CYRConsultaxIndicadorNutricion '01/Jan/2014','01/Mar/2014',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,72,NULL, '31/Jul/2014'

ALTER Procedure [dbo].[CYRConsultaxIndicadorNutricion]
@Fecha_Atencion_Inicial nvarchar(11) = null,
@Fecha_Atencion_Final nvarchar(11)= null,

@Fecha_Declaracion_Inicial nvarchar(11)= null,
@Fecha_Declaracion_Final nvarchar(11)= null, 

@Fecha_Radicacion_Inicial nvarchar(11)= null,
@Fecha_Radicacion_Final nvarchar(11)= null,

@Fecha_Desplazamiento_Inicial nvarchar(11)= null,
@Fecha_Desplazamiento_Final nvarchar(11)= null,

@Id_Regional int = null,
@Id_Lugar_Entrega int= null,
@Id_Tipo_Entrega int= null,
@Grupos nvarchar(2000) = null,
@Fecha_Corte nvarchar(11)= null

As 
Begin
Delete from Tmp_Indicador_Nutricion  ;

--
--  Insercion de regionales y lugares de entrega
--

Declare @Squery varchar(8000);
SET NOCOUNT ON;
SET Dateformat DMY;


declare @FecIniAte varchar(20);
declare @FecFinAte varchar(20);

Set @FecIniAte = @Fecha_Atencion_Inicial + ' 00:00:00'
Set @FecFinAte = @Fecha_Atencion_Final + ' 23:59:59'

declare @FecIniDec varchar(20);
declare @FecFinDec varchar(20);

Set @FecIniDec = @Fecha_Declaracion_Inicial + ' 00:00:00'
Set @FecFinDec = @Fecha_Declaracion_Final + ' 23:59:59'

declare @FecIniRad varchar(20);
declare @FecFinRad varchar(20);

Set @FecIniRad = @Fecha_Radicacion_Inicial + ' 00:00:00'
Set @FecFinRad = @Fecha_Radicacion_Final + ' 23:59:59'

declare @FecIniDes varchar(20);
declare @FecFinDes varchar(20);

Set @FecIniDes = @Fecha_Desplazamiento_Inicial + ' 00:00:00'
Set @FecFinDes = @Fecha_Desplazamiento_Final + ' 23:59:59'

declare @FecCorte varchar(20);
Set @FecCorte = @Fecha_Corte + ' 23:59:59'


Set @Squery = '
Insert into Tmp_Indicador_Nutricion
Select regional.id, regional.descripcion, lentrega.id, lentrega.descripcion, 
    0,0,0,0,0,0,0,0,0,0   
	From SubTablas lentrega 
	LEFT OUTER JOIN Subtablas Regional ON lentrega.Id_padre = regional.Id
	where lentrega.Id_Tabla = 73
	  and lentrega.Activo = 1 ' 
	  
	 
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND regional.id = ' + cast(@Id_Regional as varchar)
End
-- Lugar de Entrega
if (@Id_Lugar_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND lentrega.id = ' + cast(@Id_Lugar_Entrega as varchar)
End


Set @Squery = @Squery + ' order by lentrega.orden'

exec(@Squery)

  ------Cursor para crear las columnas


Declare @IdLE  int

DECLARE indicadornutricion CURSOR FOR
    Select Id_Lugar_Entrega from Tmp_Indicador_Nutricion 
 
OPEN indicadornutricion
FETCH NEXT FROM indicadornutricion into @IdLE
WHILE @@FETCH_STATUS = 0
BEGIN

--
--  niños menores de 5
--
 
 Set @Squery = '
  Declare @Ninos  int
  Set @Ninos = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where Edad < 5 and tipo = ''B''
                            AND lentrega.id = '  + cast(@IdLE as varchar)
                            
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND lentrega.id_padre = ' + cast(@Id_Regional as varchar)
End 

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
                          
Set @Squery = @Squery + ')';
 
Set @Squery = @Squery + ' Update Tmp_Indicador_Nutricion
   Set Ninos = @Ninos
    where id_lugar_entrega = '  + cast(@IdLE as varchar)
exec (@Squery)

----  niños Peso Adecuado Primera Entrega y Segunda Entrega
----
 IF (@Id_Tipo_Entrega  = 72) or (@Id_Tipo_Entrega  = 918)
 BEGIN
  Set @Squery = '
 
  Declare @Ninos_Peso_Adecuado int
  Set @Ninos_Peso_Adecuado = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
                            LEFT OUTER JOIN Salud_valoracion ON Salud.Id = Salud_Valoracion.Id_salud
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
							where Estado_Nutricional = ''Adecuado''
							  and personas.Edad <5 and tipo = ''B''
                              and salud_valoracion.id_tipo_proceso = ' + cast(@Id_Tipo_Entrega as varchar) 
                            + ' and lentrega.id = '  + cast(@IdLE as varchar)

END
                      
--  niños Peso Adecuado Ultimo Seguimiento 
--
 IF (@Id_Tipo_Entrega  = 919)
 BEGIN
 
 Set @Squery = '
 
  Declare @Ninos_Peso_Adecuado int
  Set @Ninos_Peso_Adecuado = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where personas.Edad <5                    
                              and tipo =''B''
                              and (Select top 1 salud_valoracion.Estado_Nutricional 
                                                 from Salud_valoracion
                                                where Salud_valoracion.id_salud = salud.id ';
                                                
										If (@Fecha_Corte is not null)
										Begin
										set @sQuery = @sQuery + ' And Fecha_Valoracion <= ''' + cast(@FecCorte as varchar) + ''''
										End                                                
                                                
                                                
                                        set @sQuery = @sQuery + ' order by Fecha_valoracion desc) =  ''Adecuado''
                            AND lentrega.id = '  + cast(@IdLE as varchar)
END
                        
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND lentrega.id_padre = ' + cast(@Id_Regional as varchar)
End 

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
                          
Set @Squery = @Squery + ')';

Set @Squery = @Squery + ' Update Tmp_Indicador_Nutricion
   Set Ninos_Peso_Adecuado = @Ninos_Peso_Adecuado
    where id_lugar_entrega = '  + cast(@IdLE as varchar)

exec (@Squery)

----
----  Niños Con Sobrepeso Primera y Segunda Entrega
----
IF (@Id_Tipo_Entrega  = 72) or (@Id_Tipo_Entrega  = 918)
 BEGIN
 
 Set @Squery = '
  Declare @Ninos_Sobre_Peso int
  Set @Ninos_Sobre_Peso = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
                            LEFT OUTER JOIN Salud_valoracion ON Salud.Id = Salud_Valoracion.Id_salud
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where Estado_Nutricional = ''Sobrepeso''
                              and salud_valoracion.id_tipo_proceso = ' + cast(@Id_Tipo_Entrega as varchar)
                             + ' and personas.Edad <5 and tipo = ''B''
                              and lentrega.id = '  + cast(@IdLE as varchar)
END

--
--  Niños Con Sobrepeso Ultimo Seguimiento
--
 IF (@Id_Tipo_Entrega  = 919)
 BEGIN
  
 Set @Squery = '
  Declare @Ninos_Sobre_Peso int
  Set @Ninos_Sobre_Peso = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
							where personas.Edad < 5
                            and (Select top 1 salud_valoracion.Estado_Nutricional 
                                                 from Salud_valoracion
                                                where Salud_valoracion.id_salud = salud.id ';
                                                
										If (@Fecha_Corte is not null)
										Begin
										set @sQuery = @sQuery + ' And Fecha_Valoracion <= ''' + cast(@FecCorte as varchar) + ''''
										End                                                
                                                
                                                
                                        set @sQuery = @sQuery + ' order by Fecha_valoracion desc) =  ''Sobrepeso''
                                                
                            and lentrega.id = '  + cast(@IdLE as varchar)
END
                          
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND lentrega.id_padre = ' + cast(@Id_Regional as varchar)
End 

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
                          
Set @Squery = @Squery + ')';


Set @Squery = @Squery + ' Update Tmp_Indicador_Nutricion
   Set Ninos_Sobre_Peso = @Ninos_Sobre_Peso
    where id_lugar_entrega = '  + cast(@IdLE as varchar)

exec (@Squery)

----  niños Con Obesidad Primera y Segunda Entrega
----
IF (@Id_Tipo_Entrega  = 72) or (@Id_Tipo_Entrega  = 918)
 BEGIN
 
  Set @Squery = '
  Declare @Ninos_Obesos int
  Set @Ninos_Obesos = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
                            LEFT OUTER JOIN Salud_valoracion ON Salud.Id = Salud_Valoracion.Id_salud
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where Estado_Nutricional = ''Obesidad''
                              and salud_valoracion.id_tipo_proceso = ' + cast(@Id_Tipo_Entrega as varchar)
                          + ' and personas.Edad <5 and tipo = ''B'' 
                              and lentrega.id = '  + cast(@IdLE as varchar)
END      

--  Niños Con Obesidad Ultimo Seguimiento
--
IF (@Id_Tipo_Entrega  = 919)
 BEGIN
  
 Set @Squery = '
  Declare @Ninos_Obesos int
  Set @Ninos_Obesos = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where personas.Edad <5 and tipo = ''B''
                            and (Select top 1 salud_valoracion.Estado_Nutricional 
                                                 from Salud_valoracion
                                                where Salud_valoracion.id_salud = salud.id ';
                                                
										If (@Fecha_Corte is not null)
										Begin
										set @sQuery = @sQuery + ' And Fecha_Valoracion <= ''' + cast(@FecCorte as varchar) + ''''
										End                                                
                                                
                                                
                                        set @sQuery = @sQuery + ' order by Fecha_valoracion desc) =  ''Obesidad''
										                            and lentrega.id = '  + cast(@IdLE as varchar)
END   

-- Regional
if (@Id_Regional >0)
Begin
Set @Squery = @Squery + ' AND lentrega.id_padre = ' + cast(@Id_Regional as varchar)
End 

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
                          
Set @Squery = @Squery + ')';


Set @Squery = @Squery + ' Update Tmp_Indicador_Nutricion
   Set Ninos_Obesos = @Ninos_Obesos
    where id_lugar_entrega = '  + cast(@IdLE as varchar)

exec (@Squery)

----  Niños Con Riesgo de Desnutricion Primera y Segunda Entrega
----
IF (@Id_Tipo_Entrega  = 72) or (@Id_Tipo_Entrega  = 918)
 BEGIN
 
  Set @Squery = '
  Declare @Ninos_Riesgo_Desnutricion int
  Set @Ninos_Riesgo_Desnutricion = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
                            LEFT OUTER JOIN Salud_valoracion ON Salud.Id = Salud_Valoracion.Id_salud
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where salud_valoracion.id_tipo_proceso = ' + cast(@Id_Tipo_Entrega as varchar) 
                        +'    and ((Estado_Nutricional = ''RDNT global'') or (Estado_Nutricional = ''RDNT Aguda''))
                              and personas.Edad <5 and tipo = ''B''
                              and lentrega.id = '  + cast(@IdLE as varchar)
END 

--  Niños Con Riesgo de Desnutricion Ultimo Seguimiento
--
IF (@Id_Tipo_Entrega  = 919)
 BEGIN
  
 Set @Squery = '
  Declare @Ninos_Riesgo_Desnutricion int
  Set @Ninos_Riesgo_Desnutricion = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
							where personas.Edad <5 
							and tipo = ''B'' 
							and (Select top 1 salud_valoracion.Estado_Nutricional 
                                                 from Salud_valoracion
                                                where Salud_valoracion.id_salud = salud.id ';
                                                
										If (@Fecha_Corte is not null)
										Begin
										set @sQuery = @sQuery + ' And Fecha_Valoracion <= ''' + cast(@FecCorte as varchar) + ''''
										End                                                
                                                
                                                
                                        set @sQuery = @sQuery + ' order by Fecha_valoracion desc) in(''RDNT global'' , ''RDNT Aguda'')
																	and lentrega.id = '  + cast(@IdLE as varchar)
END     

-- Regional
if (@Id_Regional >0)
Begin
Set @Squery = @Squery + ' AND lentrega.id_padre = ' + cast(@Id_Regional as varchar)
End 

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
                          
Set @Squery = @Squery + ')';
Set @Squery = @Squery + ' Update Tmp_Indicador_Nutricion
   Set Ninos_Riesgo_Desnutricion = @Ninos_Riesgo_Desnutricion
    where id_lugar_entrega = '  + cast(@IdLE as varchar)

exec (@Squery)

------  niños Con Desnutricion Primera y Segunda Entrega
------
IF (@Id_Tipo_Entrega  = 72) or (@Id_Tipo_Entrega  = 918)
 BEGIN
 Set @Squery = '
  Declare @Ninos_Con_Desnutricion int
  Set @Ninos_Con_Desnutricion = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
                            LEFT OUTER JOIN Salud_valoracion ON Salud.Id = Salud_Valoracion.Id_salud
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where salud_valoracion.id_tipo_proceso = ' + cast(@Id_Tipo_Entrega as varchar)
                          +'  and ((Estado_Nutricional = ''Desnutrición Global'') or (Estado_Nutricional = ''Desnutrición Aguda''))
                              and personas.Edad <5 and tipo = ''B'' and lentrega.id = '  + cast(@IdLE as varchar)
 END  
 
 --  niños Con Desnutricion Segunda Entrega y/o Seguimiento
--
IF (@Id_Tipo_Entrega  = 919)
 BEGIN
 Set @Squery = '
  Declare @Ninos_Con_Desnutricion int
  Set @Ninos_Con_Desnutricion = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
							where personas.Edad <5 and tipo = ''B''
                            and (Select top 1 salud_valoracion.Estado_Nutricional 
                                                 from Salud_valoracion
                                                where Salud_valoracion.id_salud = salud.id ';
                                                
										If (@Fecha_Corte is not null)
										Begin
										set @sQuery = @sQuery + ' And Fecha_Valoracion <= ''' + cast(@FecCorte as varchar) + ''''
										End                                                
                                        set @sQuery = @sQuery + ' order by Fecha_valoracion desc) in  (''Desnutrición Global'' , ''Desnutrición Aguda'') 
								                             and lentrega.id = '  + cast(@IdLE as varchar)
 END                         

-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND lentrega.id_padre = ' + cast(@Id_Regional as varchar)
End 

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
                          
Set @Squery = @Squery + ')';
Set @Squery = @Squery + ' Update Tmp_Indicador_Nutricion
   Set Ninos_Con_Desnutricion = @Ninos_Con_Desnutricion
    where id_lugar_entrega = '  + cast(@IdLE as varchar)

exec (@Squery)

--  Total Niños Remitidos Primera Entrega
--
 Set @Squery = '
  Declare @Ninos_Remitidos int
  Set @Ninos_Remitidos = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
                            LEFT OUTER JOIN Salud_valoracion ON Salud.Id = Salud_Valoracion.Id_salud
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where salud_valoracion.id_tipo_proceso = 72
                              and personas.Edad < 5 and tipo = ''B''
                              and Estado_Nutricional <> ''Adecuado''
                              and salud.id in (Select salud_Remisiones.id_salud 
                                                 from salud_Remisiones
                                                 where Salud_Remisiones.id_entidad_informacion in (594,872,3696)
                                                 and salud_remisiones.id_salud = salud.id '
                                                 
										If (@Fecha_Corte is not null)
										Begin
										set @sQuery = @sQuery + ' And Fecha_Remision <= ''' + cast(@FecCorte as varchar) + ''''
										End                                                  
                            
	set @sQuery = @sQuery + ') and lentrega.id = '  + cast(@IdLE as varchar)
  

-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND lentrega.id_padre = ' + cast(@Id_Regional as varchar)
End 

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
                          
Set @Squery = @Squery + ')';

Set @Squery = @Squery + ' Update Tmp_Indicador_Nutricion
   Set Ninos_Remitidos = @Ninos_Remitidos
    where id_lugar_entrega = '  + cast(@IdLE as varchar)

exec  (@Squery)


----  Total Niños Sin Valorar Primera Entrega
----
IF (@Id_Tipo_Entrega  = 72) or (@Id_Tipo_Entrega  = 918)
 BEGIN
 Set @Squery = '
  Declare @Ninos_Sin_Valorar int
  Set @Ninos_Sin_Valorar = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
                            LEFT OUTER JOIN Salud_valoracion ON Salud.Id = Salud_Valoracion.Id_salud
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where salud_valoracion.id_tipo_proceso = ' + cast(@Id_Tipo_Entrega as varchar)
                         +'   and Salud_Valoracion.Estado_Nutricional IS NULL
                              and personas.edad <5 and tipo = ''B''
                              and lentrega.id = '  + cast(@IdLE as varchar)
END

--  Total Niños Sin Valorar Ultimo Seguimiento
--
IF (@Id_Tipo_Entrega  = 919)
 BEGIN
 Set @Squery = '
  Declare @Ninos_Sin_Valorar int
  Set @Ninos_Sin_Valorar = (Select COUNT(personas.id) 
							From Declaracion
							LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
							LEFT OUTER JOIN Salud ON Salud.Id_persona = Personas.Id
							LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
							LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
                            where salud.id in (Select top 1 salud_valoracion.id_salud 
                                                from Salud_valoracion
                                                where Salud_valoracion.id_salud = salud.id
                                                 and Salud_Valoracion.Estado_Nutricional IS NULL
                                                 order by Fecha_Valoracion desc  )
                            and Personas.Edad <5 and tipo = ''B''                                                                     
                            and lentrega.id = '  + cast(@IdLE as varchar)
END

-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND lentrega.id_padre = ' + cast(@Id_Regional as varchar)
End 

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
                          
Set @Squery = @Squery + ')';
     
Set @Squery = @Squery + ' Update Tmp_Indicador_Nutricion
   Set Ninos_Sin_Valorar = @Ninos_Sin_Valorar
    where id_lugar_entrega = '  + cast(@IdLE as varchar)

exec (@Squery)

  FETCH NEXT FROM indicadornutricion into @IdLE
END

CLOSE indicadornutricion
DEALLOCATE indicadornutricion

---
--- Procesos Adicionales
--- 

Update Tmp_Indicador_Nutricion
Set  Total_Problemas_Nutricion =  (Ninos_Sobre_Peso +  Ninos_Obesos +  Ninos_Riesgo_Desnutricion  + Ninos_Con_Desnutricion)

Update Tmp_Indicador_Nutricion
Set Porcentaje_Remision =  cast(Ninos_Remitidos as decimal(12,2)) / cast(isnull(nullif(Total_Problemas_Nutricion,0),1) as decimal(12,2)) * 100 




------  
-- Para revision
Select Id, Nombre_Regional as Regional,Id_Lugar_Entrega as ID2,Nombre_LUgar_Entrega as Entrega,ninos as [NIños],Ninos_Peso_Adecuado as [Adecuado],
Ninos_Sobre_Peso as [SobrePeso],Ninos_Obesos as [Obesidad],Ninos_Riesgo_Desnutricion as [RDNT], ninos_con_desnutricion as [Desnutrición],
Total_Problemas_Nutricion as [Total], Ninos_remitidos as Remitidos,Porcentaje_Remision as [Porc. %], Ninos_sin_valorar as [Sin Valorar]  
from Tmp_Indicador_Nutricion 
------
End


