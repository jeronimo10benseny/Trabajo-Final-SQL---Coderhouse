-- ==============================================================================
-- PROYECTO FINAL INTEGRADOR -- MATERIA: SQL -- CODERHOUSE 
-- ARCHIVO: estructura.sql 
-- AUTOR: Jerónimo Diez Benseny 
-- ==============================================================================

-- 1. CREACIÓN DE ENTORNO
DROP DATABASE IF EXISTS capstone_project;
CREATE DATABASE capstone_project;

-- 2. DDL
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    ciudad VARCHAR(50) NOT NULL
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL CHECK (precio > 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    descuento_aplicado NUMERIC(10, 2), -- Contiene nulos intencionales
    fecha_pedido TIMESTAMP NOT NULL,
    CONSTRAINT fk_pedidos_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE,
    CONSTRAINT fk_pedidos_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT
);

-- 3. DML
BEGIN;

INSERT INTO clientes (nombre, email, ciudad) VALUES
('Martín Rossi', 'm.rossi@email.com', 'Córdoba'),
('Lucía Beltrán', 'l.beltran@email.com', 'Buenos Aires'),
('Gonzalo Paz', 'g.paz@email.com', 'Rosario'),
('Elena Morales', 'e.morales@email.com', 'Mendoza'),
('Santiago Giménez', 's.gimenez@email.com', 'Salta'),
('Valeria Rivas', 'v.rivas@email.com', 'Neuquén');

INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Amortiguador Nitro Reforzado', 'Suspension', 450.00, 25),
('Kit Snorkel Todo Terreno', 'Accesorios', 280.00, 15),
('Malacate 12000lb Sintetico', 'Rescate', 920.00, 8),
('Cubierta All-Terrain 31x10.5', 'Neumaticos', 310.00, 40),
('Compresor Aire Portatil 150PSI', 'Accesorios', 140.00, 30),
('Placa Desatasco Aluminio', 'Rescate', 190.00, 0);

INSERT INTO pedidos (id_cliente, id_producto, cantidad, descuento_aplicado, fecha_pedido) VALUES
(1, 1, 2, 50.00, '2026-01-15 10:30:00'),
(2, 3, 1, NULL,  '2026-01-22 14:10:00'),
(3, 4, 4, 100.00,'2026-02-05 16:45:00'),
(4, 2, 1, NULL,  '2026-02-18 11:20:00'),
(1, 5, 2, 20.00, '2026-02-27 18:00:00'),
(5, 1, 1, NULL,  '2026-03-02 09:15:00'),
(2, 4, 2, 40.00, '2026-03-12 15:30:00'),
(3, 3, 1, 50.00, '2026-03-25 17:00:00'),
(6, 2, 1, NULL,  '2026-04-03 13:40:00'),
(1, 4, 2, NULL,  '2026-04-14 10:00:00'),
(4, 5, 3, 30.00, '2026-05-10 12:50:00'),
(5, 3, 1, NULL,  '2026-05-22 16:15:00');

COMMIT;