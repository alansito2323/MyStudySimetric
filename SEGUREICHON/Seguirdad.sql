
drop table  Usuarios
CREATE TABLE Usuarios (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(255),
    Apellido NVARCHAR(255),
    Matricula NVARCHAR(50) UNIQUE, -- Asegura que la matr�cula sea �nica
    Email NVARCHAR(255) UNIQUE ,
    Contrase�a NVARCHAR(255),
	Cellphone NVARCHAR(255) UNIQUE 
);



delete from Usuarios


select * from Usuarios






