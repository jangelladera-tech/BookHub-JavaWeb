package beans;

public class Donacion {

    private int idDonacion;
    private String tituloLibro;
    private String autor;
    private String categoria;
    private int anio;
    private String estadoConservacion; // 'NUEVO', 'BUENO', 'REGULAR'
    private String nombreDonante;
    private String correoDonante;
    private String telefonoDonante;
    private String motivoMensaje;
    private String fechaSolicitud;
    private String estadoRevision; // 'PENDIENTE', 'APROBADO', 'RECHAZADO'

    public Donacion() {
    }

    public Donacion(int idDonacion, String tituloLibro, String autor, String categoria,
                    int anio, String estadoConservacion, String nombreDonante,
                    String correoDonante, String telefonoDonante, String motivoMensaje,
                    String fechaSolicitud, String estadoRevision) {
        this.idDonacion = idDonacion;
        this.tituloLibro = tituloLibro;
        this.autor = autor;
        this.categoria = categoria;
        this.anio = anio;
        this.estadoConservacion = estadoConservacion;
        this.nombreDonante = nombreDonante;
        this.correoDonante = correoDonante;
        this.telefonoDonante = telefonoDonante;
        this.motivoMensaje = motivoMensaje;
        this.fechaSolicitud = fechaSolicitud;
        this.estadoRevision = estadoRevision;
    }

    public int getIdDonacion() {
        return idDonacion;
    }

    public void setIdDonacion(int idDonacion) {
        this.idDonacion = idDonacion;
    }

    public String getTituloLibro() {
        return tituloLibro;
    }

    public void setTituloLibro(String tituloLibro) {
        this.tituloLibro = tituloLibro;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public int getAnio() {
        return anio;
    }

    public void setAnio(int anio) {
        this.anio = anio;
    }

    public String getEstadoConservacion() {
        return estadoConservacion;
    }

    public void setEstadoConservacion(String estadoConservacion) {
        this.estadoConservacion = estadoConservacion;
    }

    public String getNombreDonante() {
        return nombreDonante;
    }

    public void setNombreDonante(String nombreDonante) {
        this.nombreDonante = nombreDonante;
    }

    public String getCorreoDonante() {
        return correoDonante;
    }

    public void setCorreoDonante(String correoDonante) {
        this.correoDonante = correoDonante;
    }

    public String getTelefonoDonante() {
        return telefonoDonante;
    }

    public void setTelefonoDonante(String telefonoDonante) {
        this.telefonoDonante = telefonoDonante;
    }

    public String getMotivoMensaje() {
        return motivoMensaje;
    }

    public void setMotivoMensaje(String motivoMensaje) {
        this.motivoMensaje = motivoMensaje;
    }

    public String getFechaSolicitud() {
        return fechaSolicitud;
    }

    public void setFechaSolicitud(String fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }

    public String getEstadoRevision() {
        return estadoRevision;
    }

    public void setEstadoRevision(String estadoRevision) {
        this.estadoRevision = estadoRevision;
    }
}
