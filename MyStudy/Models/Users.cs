using System.ComponentModel.DataAnnotations.Schema;

namespace MyStudy.Models
{
    public class Users
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Matricula { get; set; }
        public string Email { get; set; }
        public string Contraseña { get; set; }
        public string Rol_Id { get; set; }
        public string Cellphone { get; set; }

    }
}
