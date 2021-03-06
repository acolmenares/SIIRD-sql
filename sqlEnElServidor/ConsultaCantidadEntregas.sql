use IRDCOL
/*select * from Personas_Entregas where Id_Programa in 
(
*/
SELECT * FROM
(
   SELECT   Programacion.*, 'x' as x,
    --Regional.id,
      grupo.Descripcion,
      lentrega.id as id2, 
             Regional.Descripcion AS Regional, 
             Lentrega.Descripcion AS LugarEntrega,
             Programacion.Id_TipoEntrega as Cantidad, 
             Tentrega.descripcion as DesTE
   FROM      Programacion 
                        LEFT OUTER JOIN SubTablas  Regional ON Programacion.Id_Regional = Regional.Id
                        LEFT OUTER JOIN SubTablas  Lentrega ON Programacion.Id_lugarEntrega = Lentrega.Id
                        LEFT OUTER JOIN Subtablas Tentrega  ON Programacion.Id_TipoEntrega = Tentrega.id
                        left join SubTablas grupo on grupo.Id= Programacion.Id_Grupo
					    WHERE  Programacion.Id_TipoEntrega is not NUll
					    And Programacion.Fecha >='20160901'
					    And Programacion.Fecha <='20160930'
) t
where Regional='Florencia'
order by DesTE
/*
)
*/