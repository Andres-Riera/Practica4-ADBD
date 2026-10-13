SELECT 'CREATE ROLE admin_viveros LOGIN'
WHERE NOT EXISTS (
    SELECT 1
    FROM pg_roles
    WHERE rolname = 'admin_viveros'
)
\gexec

ALTER ROLE admin_viveros WITH LOGIN PASSWORD '1234567890';

SELECT 'CREATE DATABASE viveros OWNER admin_viveros'
WHERE NOT EXISTS (
    SELECT 1
    FROM pg_database
    WHERE datname = 'viveros'
)
\gexec

ALTER DATABASE viveros OWNER TO admin_viveros;

\connect viveros

ALTER SCHEMA public OWNER TO admin_viveros;
SET ROLE admin_viveros;

DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS tajinaste_plus;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS tareas;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS asignados;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS zonas;
DROP TABLE IF EXISTS viveros;

CREATE TABLE viveros (
    id_vivero SERIAL PRIMARY KEY,
    latitud NUMERIC(9, 6) CHECK (latitud BETWEEN -90 AND 90),
    longitud NUMERIC(9, 6) CHECK (longitud BETWEEN -180 AND 180)
);

CREATE TABLE zonas (
    id_zona SERIAL PRIMARY KEY,
    id_vivero INT,
    nombre_zona VARCHAR(50) NOT NULL,
    latitud NUMERIC(9, 6) CHECK (latitud BETWEEN -90 AND 90),
    longitud NUMERIC(9, 6) CHECK (longitud BETWEEN -180 AND 180),
    CONSTRAINT fk_vivero
        FOREIGN KEY (id_vivero)
        REFERENCES viveros (id_vivero)
        ON DELETE CASCADE
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY
);

CREATE TABLE asignados (
    id_producto INT NOT NULL,
    id_zona INT NOT NULL,
    cantidad_disponible INT CHECK (cantidad_disponible >= 0),
    CONSTRAINT pk_asignado PRIMARY KEY (id_zona, id_producto),
    CONSTRAINT fk_asignado_zona
        FOREIGN KEY (id_zona)
        REFERENCES zonas (id_zona)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_asignado_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos (id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    id_vivero INT NOT NULL,
    CONSTRAINT fk_vivero
        FOREIGN KEY (id_vivero)
        REFERENCES viveros (id_vivero)
        ON DELETE RESTRICT
);

CREATE TABLE tareas (
    id_tarea SERIAL PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_zona INT NOT NULL,
    CONSTRAINT fk_empleado
        FOREIGN KEY (id_empleado)
        REFERENCES empleados (id_empleado)
        ON DELETE RESTRICT,
    CONSTRAINT fk_zona
        FOREIGN KEY (id_zona)
        REFERENCES zonas (id_zona)
        ON DELETE RESTRICT
);

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY
);

CREATE TABLE tajinaste_plus (
    id_cliente INT PRIMARY KEY,
    ventajas VARCHAR(60),
    fecha_ingreso DATE NOT NULL,
    CONSTRAINT fk_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente)
        ON DELETE CASCADE
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    importe NUMERIC(10, 2) NOT NULL CHECK (importe >= 0),
    fecha DATE NOT NULL,
    CONSTRAINT fk_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente)
        ON DELETE CASCADE,
    CONSTRAINT fk_empleado
        FOREIGN KEY (id_empleado)
        REFERENCES empleados (id_empleado)
        ON DELETE CASCADE
);

INSERT INTO viveros (latitud, longitud) VALUES
    (28.463629, -16.251846),
    (28.123546, -15.436257),
    (28.683512, -17.764321),
    (29.046854, -13.589973),
    (28.500421, -13.862738);

INSERT INTO zonas (id_vivero, nombre_zona, latitud, longitud) VALUES
    (1, 'Zona exterior', 28.463700, -16.251900),
    (1, 'Invernadero', 28.463800, -16.252000),
    (2, 'Semilleros', 28.123600, -15.436300),
    (2, 'Plantas tropicales', 28.123700, -15.436400),
    (3, 'Plantas aromaticas', 28.683600, -17.764400),
    (4, 'Cactus y suculentas', 29.046900, -13.590000),
    (5, 'Jardin ornamental', 28.500500, -13.862800),
    (NULL, 'Zona pendiente', NULL, NULL);

INSERT INTO productos DEFAULT VALUES;
INSERT INTO productos DEFAULT VALUES;
INSERT INTO productos DEFAULT VALUES;
INSERT INTO productos DEFAULT VALUES;
INSERT INTO productos DEFAULT VALUES;
INSERT INTO productos DEFAULT VALUES;

INSERT INTO asignados (id_producto, id_zona, cantidad_disponible) VALUES
    (1, 1, 100),
    (2, 1, 50),
    (3, 2, 75),
    (1, 2, 20),
    (4, 3, 150),
    (5, 4, 0),
    (6, 5, 80),
    (2, 6, 40),
    (3, 7, 200),
    (1, 8, 0);

INSERT INTO empleados (id_vivero) VALUES
    (1),
    (1),
    (2),
    (3),
    (4),
    (5),
    (2);

INSERT INTO tareas (id_empleado, id_zona) VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (3, 3),
    (3, 4),
    (4, 5),
    (5, 6),
    (6, 7),
    (7, 4);

INSERT INTO clientes DEFAULT VALUES;
INSERT INTO clientes DEFAULT VALUES;
INSERT INTO clientes DEFAULT VALUES;
INSERT INTO clientes DEFAULT VALUES;
INSERT INTO clientes DEFAULT VALUES;
INSERT INTO clientes DEFAULT VALUES;
INSERT INTO clientes DEFAULT VALUES;

INSERT INTO tajinaste_plus (id_cliente, ventajas, fecha_ingreso) VALUES
    (1, 'Descuento del 10%', CURRENT_DATE - 365),
    (2, 'Envio gratuito', CURRENT_DATE - 180),
    (3, 'Descuento del 15%', CURRENT_DATE - 90),
    (4, 'Acceso a promociones', CURRENT_DATE - 30),
    (5, 'Puntos por compra', CURRENT_DATE);

INSERT INTO pedidos (id_cliente, id_empleado, importe, fecha) VALUES
    (1, 1, 150.50, CURRENT_DATE - 60),
    (2, 2, 200.00, CURRENT_DATE - 45),
    (3, 3, 75.25, CURRENT_DATE - 30),
    (4, 4, 300.00, CURRENT_DATE - 20),
    (5, 5, 50.00, CURRENT_DATE - 15),
    (6, 6, 0.00, CURRENT_DATE - 10),
    (7, 7, 125.75, CURRENT_DATE - 5),
    (1, 2, 90.00, CURRENT_DATE - 3),
    (2, 3, 450.99, CURRENT_DATE - 1),
    (3, 1, 25.50, CURRENT_DATE);

SELECT * FROM viveros;
SELECT * FROM zonas;
SELECT * FROM productos;
SELECT * FROM empleados;
SELECT * FROM asignados;
SELECT * FROM clientes;
SELECT * FROM tajinaste_plus;
SELECT * FROM pedidos;
SELECT * FROM tareas;

SELECT COUNT(*) FROM pedidos;

DELETE FROM tareas WHERE id_empleado = 3;
DELETE FROM empleados WHERE id_empleado = 3;

SELECT * FROM pedidos;
SELECT COUNT(*) FROM pedidos;


