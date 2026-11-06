<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>BOOKHUB | Crear cuenta de lector</title>

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
                                Registro de nuevo lector
                            </p>

                        </div>


                        <!-- MENSAJE DE ERROR -->

                        <%
                            String error = (String) request.getAttribute("error");
                            String nombreIngresado = (String) request.getAttribute("nombreIngresado");
                            String correoIngresado = (String) request.getAttribute("correoIngresado");

                            if (error != null) {
                        %>

                        <div class="alert alert-danger">
                            <%= error %>
                        </div>

                        <%
                            }
                        %>


                        <form action="RegistroServlet"
                              method="post">


                            <!-- NOMBRE -->

                            <div class="mb-3">

                                <label class="form-label">
                                    Nombre completo
                                </label>

                                <input type="text"
                                       name="nombre"
                                       class="form-control"
                                       placeholder="Ej. Pedro López"
                                       value="<%= nombreIngresado != null ? nombreIngresado : "" %>"
                                       required>

                            </div>


                            <!-- CORREO -->

                            <div class="mb-3">

                                <label class="form-label">
                                    Correo electrónico
                                </label>

                                <input type="email"
                                       name="correo"
                                       class="form-control"
                                       placeholder="Ej. pedro@bookhub.com"
                                       value="<%= correoIngresado != null ? correoIngresado : "" %>"
                                       required>

                            </div>


                            <!-- CONTRASEÑA -->

                            <div class="mb-3">

                                <label class="form-label">
                                    Contraseña
                                </label>

                                <input type="password"
                                       name="password"
                                       class="form-control"
                                       placeholder="Mínimo 4 caracteres"
                                       minlength="4"
                                       required>

                            </div>


                            <!-- CONFIRMAR CONTRASEÑA -->

                            <div class="mb-4">

                                <label class="form-label">
                                    Confirmar contraseña
                                </label>

                                <input type="password"
                                       name="confirmarPassword"
                                       class="form-control"
                                       placeholder="Repite tu contraseña"
                                       minlength="4"
                                       required>

                            </div>


                            <!-- BOTÓN -->

                            <div class="d-grid">

                                <button type="submit"
                                        class="btn btn-primary">
                                    Crear cuenta de lector
                                </button>

                            </div>


                        </form>


                        <div class="text-center mt-4 pt-2 border-top">

                            <span class="text-muted">
                                ¿Ya tienes una cuenta?
                            </span>

                            <a href="login.jsp"
                               class="text-decoration-none fw-bold">
                                Iniciar sesión
                            </a>

                        </div>

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

</body>

</html>
