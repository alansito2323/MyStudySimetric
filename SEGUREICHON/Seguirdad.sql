
drop table  Usuarios
CREATE TABLE Usuarios (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(255),
    Apellido NVARCHAR(255),
    Matricula NVARCHAR(50) UNIQUE, -- Asegura que la matrícula sea única
    Email NVARCHAR(255) UNIQUE ,
    Contraseña NVARCHAR(255),
	Cellphone NVARCHAR(255) UNIQUE 
);



delete from Usuarios


select * from Usuarios






