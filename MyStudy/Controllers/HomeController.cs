using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MyStudy.Logica;
using MyStudy.Models;
using System.Diagnostics;
using System.Security.Claims;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using MyStudy.Models;
using System.Diagnostics;

using System.Data.SqlClient;
using MyStudy.Logica;


using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;





namespace MyStudy.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        private readonly string DefaultConnectionString;
        public readonly IWebHostEnvironment webHostEnvironment;

        LoUsuario _LoUser = new LoUsuario();

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }


        // LOGIN
        [HttpPost]
        public async Task<IActionResult> Login2(string Email, string Contraseña)
        {
            string email = Email.Trim();
            string contraseña = Contraseña.Trim();

            bool res = new LoUsuario().Findusers(email, contraseña);

            var userData = GetUserByEmail(email); // Cambié el nombre de la variable a userData para evitar conflictos

            if (res==false)
            {
                TempData["SuccessMessage4"] = "Credentials Incorrect";
                return RedirectToAction("Login", "Home");
            }
            else
            {


                ViewData["LoginExitoso"] = true;
                HttpContext.Session.SetString("Nombre", userData.Nombre);
                HttpContext.Session.SetString("Contraseña", userData.Contraseña);
                HttpContext.Session.SetString("Matricula", userData.Matricula);
                HttpContext.Session.SetString("Email", userData.Email);
                TempData["SuccessMessage3"] = "You have joined : " + userData.Nombre;
                return RedirectToAction("Index", "Home");
            }
        }







        public Users GetUserByEmail(string Email)
        {
            string email = Email.Trim();
            bool nulll = false;
            try
            {
                using (SqlConnection connection = new SqlConnection("Data Source=DESKTOP-20PBO5J;Initial Catalog=Educational;Integrated Security=True"))
                {
                    connection.Open();

                    string query = "Select * from Usuarios Where Email = @pEmail";
                    SqlCommand command = new SqlCommand(query, connection);
                    command.Parameters.AddWithValue("@pEmail", email);

                    using (SqlDataReader dr = command.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            Users user = new Users
                            {
                                Id = Convert.ToInt32(dr["Id"]),
                                Cellphone = dr["Cellphone"].ToString(),
                                Nombre = dr["Nombre"].ToString(),
                                Apellido = dr["Apellido"].ToString(),
                                Matricula = dr["Matricula"].ToString(),
                                Email = dr["Email"].ToString(),
                                Contraseña = dr["Contraseña"].ToString(),

                            };
                            return user;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Maneja cualquier excepción aquí, por ejemplo, registra el error o lanza una excepción personalizada.
                // No dejes el bloque catch vacío.
                throw ex;
            }
            return null;
        }


        [HttpPost]
        public IActionResult Signup2(Users ousers)
        {

            var result = _LoUser.AddU(ousers); // Método para agregar el usuario a la base de datos
            if (result)
            {
                TempData["SuccessMessage1"] = "User Created Succesfully ";
                return RedirectToAction("Login", "Home");

            }
            else
            {
                TempData["SuccessMessage2"] = "Enrollment or email already exists ";
                return RedirectToAction("Signup", "Home");
            }

        }



        public async Task<ActionResult> LogOut()
        {
            HttpContext.Session.Clear();

            TempData["SuccessMessage5"] = "You have logged out";

            // Redirecciona al inicio de sesión u otra página
            return RedirectToAction("Login", "Home");
        }



        public IActionResult Signup()
        {
            return View();
        }


        public IActionResult Login()
        {
            return View();
        }




        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}