package beans;

public class Libro {

    private int idLibro;
    private String titulo;
    private String isbn;
    private int anio;
    private String descripcion;
    private int stock;
    private int idAutor;
    private int idCategoria;
    private String nombreAutor;
    private String nombreCategoria;
    private String imagenPortada;
    private Autor autor;
    private Categoria categoria;

    public Libro() {
    }

    public Libro(int idLibro, String titulo, String isbn, int anio,
                 String descripcion, int stock) {
        this.idLibro = idLibro;
        this.titulo = titulo;
        this.isbn = isbn;
        this.anio = anio;
        this.descripcion = descripcion;
        this.stock = stock;
    }

    public Libro(int idLibro, String titulo, String isbn, int anio,
                 String descripcion, int stock, int idAutor, String nombreAutor,
                 int idCategoria, String nombreCategoria) {
        this(idLibro, titulo, isbn, anio, descripcion, stock, idAutor, nombreAutor, idCategoria, nombreCategoria, null);
    }

    public Libro(int idLibro, String titulo, String isbn, int anio,
                 String descripcion, int stock, int idAutor, String nombreAutor,
                 int idCategoria, String nombreCategoria, String imagenPortada) {
        this.idLibro = idLibro;
        this.titulo = titulo;
        this.isbn = isbn;
        this.anio = anio;
        this.descripcion = descripcion;
        this.stock = stock;
        this.idAutor = idAutor;
        this.nombreAutor = nombreAutor;
        this.idCategoria = idCategoria;
        this.nombreCategoria = nombreCategoria;
        this.imagenPortada = imagenPortada;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public int getAnio() {
        return anio;
    }

    public void setAnio(int anio) {
        this.anio = anio;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getIdAutor() {
        return idAutor;
    }

    public void setIdAutor(int idAutor) {
        this.idAutor = idAutor;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombreAutor() {
        return (nombreAutor != null && !nombreAutor.isEmpty())
                ? nombreAutor
                : (autor != null ? autor.getNombre() : "Autor General");
    }

    public void setNombreAutor(String nombreAutor) {
        this.nombreAutor = nombreAutor;
    }

    public String getNombreCategoria() {
        return (nombreCategoria != null && !nombreCategoria.isEmpty())
                ? nombreCategoria
                : (categoria != null ? categoria.getNombre() : "General");
    }

    public void setNombreCategoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }

    public String getImagenPortada() {
        if (imagenPortada != null && !imagenPortada.trim().isEmpty()) {
            return imagenPortada.trim();
        }
        if (idLibro >= 1 && idLibro <= 6) {
            return "img/portadas/libro" + idLibro + ".svg";
        }
        return "img/portadas/default.svg";
    }

    public void setImagenPortada(String imagenPortada) {
        this.imagenPortada = imagenPortada;
    }

    public Autor getAutor() {
        return autor;
    }

    public void setAutor(Autor autor) {
        this.autor = autor;
        if (autor != null) {
            this.idAutor = autor.getIdAutor();
            this.nombreAutor = autor.getNombre();
        }
    }

    public Categoria getCategoria() {
        return categoria;
    }

    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
        if (categoria != null) {
            this.idCategoria = categoria.getIdCategoria();
            this.nombreCategoria = categoria.getNombre();
        }
    }
}
