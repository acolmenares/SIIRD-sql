/* Pasar de Cerrado -> Legalizado -> Asignado -> activado -> Abierto ????????????????*/
/*
Cerrar: 
Buscar programaciones con Estado Legalizado (216)
Actualizar a estado Cerrado = 217
ProgramacionDAL.CargarPorResumenPrograma(objprograma.Id_Grupo, objprograma.ID, objprograma.Id_TipoEntrega)
Verificar si alguna fila de CargarPorResumenProgram tiene saldo y Crea la devolucion de la mercancia
en las tablas Entradas, EntradasDetalles y EntradasDetallesDistribucion

(CierreProgramacionList.aspx.vb)

Legalizar: 
Bucar progrmaciones con estado Asignado (215) 
Actualizar a estado Legalizado = 216
 --
 Grabar Proceso
    objpersonaentrega = Personas_EntregasBrl.CargarPorID(lblid.Text) ("dbo.Personas_EntregasConsultarPorID")
    objpersonaentrega.Cantidad_Legalizada = CType(dataItem.FindControl("txt_legalizado"), TextBox).Text
    objpersonaentrega.Guardar()
 
--
(LegalizacionLista.aspx.vb)


*/
Use IRDCOL

declare @TipoEntradaDevolucion int;
declare @TipoSalidaEntrega int;
declare @Grupo_Programacion varchar(25);
declare @Id_Activado int;
declare @Id_Abierto int;
declare @Id_Asignado int;
declare @Id_Legalizado int;
declare @Id_Cerrado int;

declare @Id_Programa int;
declare @Id_Salida int;
declare @Id_Entrada int;
declare @Id_Grupo int;

set @Grupo_Programacion=  'REGFF9-016(1)'  --'REGFF9-006(1)' -- 'REGFF9-001(1)----'
set @Id_Cerrado = 217;
set @Id_Legalizado = 216
set @Id_Asignado = 215;
set @Id_Activado=214;
set @Id_Abierto=213;
set @TipoEntradaDevolucion= 158;
set @TipoSalidaEntrega = 3274;

set @Id_Programa=
(
select pr.Id from Programacion pr where pr.Numero=@Grupo_Programacion and pr.Id_Estado=@Id_Cerrado
)

set @Id_Grupo=
(
select pr.Id_Grupo from Programacion pr where pr.Id=@Id_Programa
)


set @Id_Entrada =
(select  e.Id from Entradas e where e.Numero_Entrada=@Grupo_Programacion and e.Id_Tipo_Entrada=@TipoEntradaDevolucion);

select @Id_Programa as Id_Programa, @Id_Entrada as Id_Entrada, @Id_Grupo as Id_Grupo;

update Entradas_Detalle set Cantidad=0 where Id_Entrada=@Id_Entrada;

Update Entradas_Distribucion set Cantidad=0 where Id_Entrada_Detalle In (
  select ed.Id from Entradas_Detalle ed where ed.Id_Entrada=@Id_Entrada
)

UPdate Programacion set Id_Estado=@Id_Legalizado where Id= @Id_Programa