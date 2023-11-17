using Microsoft.AspNetCore.Mvc;
using MyStudy.Models;
using System.Diagnostics;
using System.Data;
using System.Data.SqlClient;
using System;
using Microsoft.AspNetCore.Components.Routing;
using System.Xml.Linq;

namespace MyStudy.Logica
{
    public class LoUsuario
    {
        // Find an user that the Username and Password 
        public bool Findusers(string Email, string Contraseña)
        {
            bool res = false; // Inicialmente, establecemos res en false

            try
            {
                using (SqlConnection conexion = new SqlConnection("Data Source=DESKTOP-8USN98H;Initial Catalog=Educational;Integrated Security=True"))
                {
                    conexion.Open();
                    SqlCommand cmd = new SqlCommand("sp_LoginUsuario", conexion);
                    cmd.Parameters.AddWithValue("Email", Email);
                    cmd.Parameters.AddWithValue("Contraseña", Contraseña);

                    cmd.CommandType = CommandType.StoredProcedure;

                    // Ejecuta el procedimiento almacenado y obtén el valor de retorno
                    string result = cmd.ExecuteScalar() as string;

                    if (result == "Si")
                    {
                        // Inicio de sesión exitoso
                        res = true;
                    }

                }
            }
            catch (SqlException exp)
            {
                throw new InvalidOperationException("Data could not be read", exp);
            }

            return res;
        }

        // CREATE USERS

        public bool AddU(Users ouser)
        {
            bool res = false; // Inicialmente, establecemos res en false

            try
            {
                using (SqlConnection conexion = new SqlConnection("Data Source=DESKTOP-8USN98H;Initial Catalog=Educational;Integrated Security=True"))
                {
                    conexion.Open();
                    SqlCommand cmd = new SqlCommand("sp_AltaUsuario", conexion);
                    cmd.Parameters.AddWithValue("@Nombre", ouser.Nombre);
                    cmd.Parameters.AddWithValue("@Apellido", ouser.Apellido);
                    cmd.Parameters.AddWithValue("@Matricula", ouser.Matricula);
                    cmd.Parameters.AddWithValue("@Email", ouser.Email);
                    cmd.Parameters.AddWithValue("@Contraseña", ouser.Contraseña);
                    cmd.Parameters.AddWithValue("@Cellphone", ouser.Cellphone);
                    cmd.CommandType = CommandType.StoredProcedure;

                    string result = cmd.ExecuteScalar() as string;

                    if (result == "Si")
                    {
                        res = true; // Usuario insertado con éxito
                    }
                    else if (result == "No")
                    {
                        res = false; // La matrícula o el correo electrónico ya existen
                    }
                }
            }
            catch (Exception e)
            {
                string error = e.Message;
                res = false;
            }
            return res;
        }

    }
}
