-- del PRCC CYRConsultaxCantidadEntregas
use IRDCOL
SELECT * FROM
(
   SELECT    Programacion.Fecha, Programacion.Id_Estado, Programacion.Numero, Programacion.Id as ProgramaID,
   Regional.id, lentrega.id as id2, Regional.Descripcion AS Regional, Lentrega.Descripcion AS LugarEntrega,
   Programacion.Id_TipoEntrega as Cantidad, Tentrega.descripcion as DesTE
              
   FROM         Programacion 
                        LEFT OUTER JOIN SubTablas  Regional ON Programacion.Id_Regional = Regional.Id
                        LEFT OUTER JOIN SubTablas  Lentrega ON Programacion.Id_lugarEntrega = Lentrega.Id
                        LEFT OUTER JOIN Subtablas Tentrega  ON Programacion.Id_TipoEntrega = Tentrega.id
					    WHERE  Programacion.Id_TipoEntrega is not NUll
                       
 And Programacion.Fecha >= '20161001' And Programacion.Fecha <= '20161130'
  and Programacion.Id_TipoEntrega=918
) t 

--PIVOT (count(cantidad) FOR desTE
--IN ([Entrega Especial ],[Entrega Vulnerables],[Primera entrega],[Segunda entrega])) AS pvt

order by Regional, LugarEntrega


--update Programacion set Fecha='20161212' where Id=1044