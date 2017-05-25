use IRDCOL
--select * from OrdenCompra where Numero='OCFLA8092'
--SELECT * FROM OrdenCompra_Detalle de WHERE de.Id_OrdenCompra=2381
DECLARE @ID_OC_ORIGEN INT = 2459
DECLARE @ID_OC_DESTINO INT = 2472

SELECT 
'INSERT INTO [IRDCOL].[dbo].[OrdenCompra_Detalle]
           ([Id_OrdenCompra]
           ,[Id_Producto]
           ,[Id_Unidad_Medida]
           ,[Cantidad]
           ,[Valor_Unitario]
           ,[Activo]
           ,[Motivo_Cancelacion]
           ,[Id_Usuario_Inactivo]
           ,[Id_Nivel]
           ,[Descripcion_General]
           ,[Codigo_Proyecto]
           ,[Fecha_Creacion]
           ,[Id_Usuario_Creacion]
           ,[Fecha_Modificacion]
           ,[Id_Usuario_Modificacion]
           ,[Fecha_Cierre]
           ,[Cierre])
     VALUES (',
     @ID_OC_DESTINO, ',', 
     de.Id_Producto, ',',
     de.Id_Unidad_Medida, ',',
     de.Cantidad, ',',
     de.Valor_Unitario, ',',
     de.Activo, ',',
     de.Motivo_Cancelacion, ',',
     de.Id_Usuario_Inactivo, ',',
     de.Id_Nivel, ',',
     '''', de.Descripcion_General, ''',',
     de.Codigo_Proyecto, ',',
     '''20160729''', ',',
     de.Id_Usuario_Creacion, ',',
     null, ',',
     de.Id_Usuario_Modificacion,',',
     null,',',
     de.Cierre, ');'
     
      
  FROM OrdenCompra_Detalle de WHERE de.Id_OrdenCompra=@ID_OC_ORIGEN   
/*           (<Id_OrdenCompra, int,>
     de.Id_Producto, int,>
     de.Id_Unidad_Medida, int,>
     de.Cantidad, numeric(18,2),>
     de.Valor_Unitario, numeric(18,2),>
     de.Activo, bit,>
     de.Motivo_Cancelacion, nvarchar(100),>
     de.Id_Usuario_Inactivo, int,>
     de.Id_Nivel, int,>
     de.Descripcion_General, nvarchar(1200),>
     de.Codigo_Proyecto, nvarchar(10),>
     de.Fecha_Creacion, datetime,>
     de.Id_Usuario_Creacion, int,>
     de.Fecha_Modificacion, datetime,>
     de.Id_Usuario_Modificacion, int,>
     de.Fecha_Cierre, datetime,>
     de.Cierre, bit,>)
           */
GO

