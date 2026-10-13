# Practica4-ADBD

## Diagrama Entidad/Relación

![diagrama1](media/Practica2-ADBD.drawio.png)

## Diagrama Relacional

![diagrama2](media/Practica4.drawio.png)

## Salidas de SELECT

![salida](media/salidas_select.png)

## Demostración DELETE

```sql
SELECT COUNT(*) FROM pedidos;

DELETE FROM tareas WHERE id_empleado = 3;
DELETE FROM empleados WHERE id_empleado = 3;

SELECT * FROM pedidos;
SELECT COUNT(*) FROM pedidos; 
```

![salidaDelete](media/demostracion_delete.png)

## Autores
- Andrés David Riera Rivera
- Alejandro Feo Martín