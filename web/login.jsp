<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>BOOKHUB | Iniciar sesión</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">
    </head>

    <body class="bg-light">

        <div class="container py-4">

            <div class="row justify-content-center align-items-center"
                 style="min-height: 95vh;">

                <div class="col-md-5">

                    <div class="card shadow">

                        <div class="card-body p-4 p-md-5">

                            <div class="text-center mb-4">

                                <h2 class="fw-bold">
                                    📚 BOOKHUB
                                </h2>

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
                                                onclick="togglePassword()">
                                            👁️
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


                            <!-- USUARIOS PRE-CREADOS (1 ADMIN Y 2 LECTORES) -->

                            <div class="card bg-light border mt-4">
                                <div class="card-body p-3">
                                    <p class="small fw-bold text-secondary mb-2 text-center">
                                        🔑 Usuarios ya creados (clic para autocompletar):
                                    </p>

                                    <div class="d-grid gap-2">
                                        <button type="button"
                                                class="btn btn-sm btn-outline-danger text-start"
                                                onclick="completarCredenciales('admin@bookhub.com', '123456')">
                                            🛡️ <strong>Admin:</strong> admin@bookhub.com <span class="float-end badge bg-danger">123456</span>
                                        </button>

                                        <button type="button"
                                                class="btn btn-sm btn-outline-primary text-start"
                                                onclick="completarCredenciales('juan@bookhub.com', '123456')">
                                            📖 <strong>Lector 1 (Juan Pérez):</strong> juan@bookhub.com <span class="float-end badge bg-primary">123456</span>
                                        </button>

                                        <button type="button"
                                                class="btn btn-sm btn-outline-primary text-start"
                                                onclick="completarCredenciales('maria@bookhub.com', '123456')">
                                            📖 <strong>Lector 2 (María López):</strong> maria@bookhub.com <span class="float-end badge bg-primary">123456</span>
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
                                    ✍️ Crear una cuenta nueva
                                </a>

                            </div>


                            <!-- VOLVER AL INICIO -->

                            <div class="text-center mt-3">

                                <a href="index.html"
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

    </body>
</html>
