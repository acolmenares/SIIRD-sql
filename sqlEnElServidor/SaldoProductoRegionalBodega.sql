--Select id, Descripcion from subtablas where id_tabla = 32  and id  in    (select distinct Entradas_Detalle.Id_Producto     from Entradas_Detalle)
USE IRDCOL

declare @IdRegional int = 1637 --Florencia
declare @IdBodega int = 2084 -- la Caqueteña
declare @IdProducto int =  7707  --Kit de alimentos tipo B caja 1   --10233 -- Bienestarina

SELECT 
    --Entradas_Distribucion.*
    Isnull(SUM(Entradas_Distribucion.Cantidad),0) as totcantidad
	FROM Entradas_Distribucion INNER JOIN
	Entradas_Detalle ON Entradas_Distribucion.Id_Entrada_Detalle = Entradas_Detalle.Id INNER JOIN
	Entradas ON Entradas_Detalle.Id_Entrada = Entradas.Id
	WHERE Entradas.Id_Regional = @IdRegional
	AND (Entradas_Distribucion.Id_Bodega = @IdBodega)  
	 AND Entradas_Detalle.Id_Producto = @IdProducto
	--And Entradas.Fecha >= '20160930'
	
	
SELECT 
    --Salidas_Detalle.*
    isnull(sum(Salidas_Detalle.Cantidad),0) as totcantidad
	FROM         Salidas INNER JOIN
	Salidas_Detalle ON Salidas.Id = Salidas_Detalle.Id_Salida
	WHERE     Salidas.Id_Regional = @IdRegional
	and (Salidas.Id_Bodega = @IdBodega) 
	AND Salidas_Detalle.Id_Producto = @IdProducto
	--And Salidas.Fecha >= '20160930'
	
select * from Entradas_Detalle where Id= 7920
select * from Entradas where ID IN (select Id_Entrada from Entradas_Detalle where Id= 7920) 
select * from Salidas where Id in ( 3622	)
--select * from Entradas where ID= 1854

