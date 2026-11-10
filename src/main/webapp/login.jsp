<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
    <head>
    <!-- Favicon / Logo oficial de la ventana y pestañas -->
    <link rel="icon" type="image/x-icon" href="favicon.ico">
    <link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
    <link rel="icon" type="image/png" sizes="32x32" href="favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="favicon-16x16.png">
    <link rel="icon" type="image/svg+xml" href="img/logo.svg">
    <link rel="apple-touch-icon" href="favicon-180x180.png">

    <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>BOOKHUB | Iniciar sesión</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
                min-height: 100vh;
            }
            .login-card {
                border-radius: 16px;
                border: 1px solid rgba(255, 255, 255, 0.1);
                background: #ffffff;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.25);
            }
            .form-control {
                border-radius: 8px;
                padding: 10px 14px;
            }
            .btn-primary {
                border-radius: 8px;
                padding: 10px;
                font-weight: 600;
            }
        </style>
    </head>

    <body>

        <div class="container py-4">

            <div class="row justify-content-center align-items-center"
                 style="min-height: 95vh;">

                <div class="col-md-5">

                    <div class="card login-card">

                        <div class="card-body p-4 p-md-5">

                            <div class="text-center mb-4">
                                <div class="d-flex align-items-center justify-content-center gap-2 mb-2">
                                    <img src="img/logo.svg" alt="BookHub Logo" width="44" height="44">
                                    <h2 class="fw-bold mb-0">BookHub</h2>
                                </div>
                                <p class="text-muted mb-0">
                                    Iniciar sesión en la biblioteca
                                </p>
                            </div>


                            <!-- MENSAJE DE ERROR -->

                            <%
                                String error =
                                        (String) request.getAttribute("error");

                                String correoIngresado =
                                        (String) request.getAttribute("correoIngresado");

                                if (error != null) {
                            %>

                            <div class="alert alert-danger">
                                <%= error %>
                            </div>

                            <%
                                }
                            %>


                            <!-- REGISTRO EXITOSO -->

                            <%
                                String registro =
                                        request.getParameter("registro");

                                if ("exitoso".equals(registro)) {
                            %>

                            <div class="alert alert-success">
                                ¡Cuenta de lector creada correctamente!
                                Ya puedes iniciar sesión con tu correo y contraseña.
                            </div>

                            <%
                                }
                            %>


                            <!-- FORMULARIO LOGIN -->

                            <form action="LoginServlet" method="POST" id="formLogin">

                                <div class="mb-3">

                                    <label class="form-label">
                                        Correo electrónico
                                    </label>

                                    <input type="email"
                                           id="correoInput"
                                           name="correo"
                                           class="form-control"
                                           placeholder="correo@bookhub.com"
                                           value="<%= correoIngresado != null ? correoIngresado : "" %>"
                                           required>

                                </div>


                                <div class="mb-3">

                                    <label class="form-label">
                                        Contraseña
                                    </label>

                                    <div class="input-group">
                                        <input type="password"
                                               id="passwordInput"
                                               name="password"
                                               class="form-control"
                                               placeholder="Ingrese su contraseña"
                                               required>
                                        <button class="btn btn-outline-secondary"
                                                type="button"
                                                onclick="togglePassword()"
                                                aria-label="Mostrar u ocultar contraseña">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>

                                </div>


                                <div class="d-grid mt-4">

                                    <button type="submit"
                                            class="btn btn-primary">
                                        Iniciar sesión
                                    </button>

                                </div>

                            </form>


                            <!-- ACCESOS RÁPIDOS DE PRUEBA -->

                            <div class="card bg-light border mt-4">
                                <div class="card-body p-3">
                                    <p class="small fw-semibold text-secondary mb-2 text-center">
                                        <i class="bi bi-key me-1"></i> Cuentas demostrativas (clic para autocompletar):
                                    </p>

                                    <div class="d-grid gap-2">
                                        <button type="button"
                                                class="btn btn-sm btn-outline-danger text-start"
                                                onclick="completarCredenciales('admin@bookhub.com', '123456')">
                                            <i class="bi bi-shield-lock-fill text-danger me-1"></i> <strong>Administrador:</strong> admin@bookhub.com <span class="float-end badge bg-danger">123456</span>
                                        </button>

                                        <button type="button"
                                                class="btn btn-sm btn-outline-primary text-start"
                                                onclick="completarCredenciales('juan@bookhub.com', '123456')">
                                            <i class="bi bi-person-fill text-primary me-1"></i> <strong>Juan Pérez:</strong> juan@bookhub.com <span class="float-end badge bg-primary">123456</span>
                                        </button>

                                        <button type="button"
                                                class="btn btn-sm btn-outline-primary text-start"
                                                onclick="completarCredenciales('maria@bookhub.com', '123456')">
                                            <i class="bi bi-person-fill text-primary me-1"></i> <strong>María López:</strong> maria@bookhub.com <span class="float-end badge bg-primary">123456</span>
                                        </button>
                                    </div>
                                </div>
                            </div>


                            <!-- APARTADO PARA REGISTRARSE -->

                            <div class="text-center mt-4 pt-2 border-top">

                                <span class="text-muted d-block mb-2">
                                    ¿Eres un nuevo lector y no tienes cuenta?
                                </span>

                                <a href="registro.jsp"
                                   class="btn btn-outline-success btn-sm w-100">
                                    <i class="bi bi-person-plus me-1"></i> Crear una cuenta nueva
                                </a>

                            </div>


                            <!-- VOLVER AL INICIO -->

                            <div class="text-center mt-3">

                                <a href="index.jsp"
                                   class="text-decoration-none">
                                    ← Volver al inicio
                                </a>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>

        <script>
            function completarCredenciales(correo, password) {
                document.getElementById('correoInput').value = correo;
                document.getElementById('passwordInput').value = password;
            }

            function togglePassword() {
                var input = document.getElementById('passwordInput');
                input.type = (input.type === 'password') ? 'text' : 'password';
            }
        </script>

        <%@include file="a11y-panel.jsp"%>

    </body>
</html>
