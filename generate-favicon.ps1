Add-Type -AssemblyName System.Drawing

$bmp = New-Object System.Drawing.Bitmap 48, 48
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.Clear([System.Drawing.Color]::Transparent)

# Fondo azul redondeado
$rect = New-Object System.Drawing.Rectangle 2, 2, 44, 44
$c1 = [System.Drawing.Color]::FromArgb(30, 58, 138)
$c2 = [System.Drawing.Color]::FromArgb(37, 99, 235)
$brushBack = New-Object System.Drawing.Drawing2D.LinearGradientBrush ($rect, $c1, $c2, [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal)
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$d = 14
$path.AddArc(2, 2, $d, $d, 180, 90)
$path.AddArc(46 - $d, 2, $d, $d, 270, 90)
$path.AddArc(46 - $d, 46 - $d, $d, $d, 0, 90)
$path.AddArc(2, 46 - $d, $d, $d, 90, 90)
$path.CloseFigure()
$g.FillPath($brushBack, $path)

# Libro abierto (páginas blancas / claras)
$brushLeft = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(224, 231, 255))
$brushRight = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 255))

# Hoja izquierda
$pLeft = [System.Drawing.Point[]]@(
    (New-Object System.Drawing.Point 9, 16),
    (New-Object System.Drawing.Point 23, 14),
    (New-Object System.Drawing.Point 23, 33),
    (New-Object System.Drawing.Point 9, 35)
)
$g.FillPolygon($brushLeft, $pLeft)

# Hoja derecha
$pRight = [System.Drawing.Point[]]@(
    (New-Object System.Drawing.Point 25, 14),
    (New-Object System.Drawing.Point 39, 16),
    (New-Object System.Drawing.Point 39, 35),
    (New-Object System.Drawing.Point 25, 33)
)
$g.FillPolygon($brushRight, $pRight)

# Marcador dorado en el medio
$brushGold = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(245, 158, 11))
$pMark = [System.Drawing.Point[]]@(
    (New-Object System.Drawing.Point 23, 14),
    (New-Object System.Drawing.Point 25, 14),
    (New-Object System.Drawing.Point 25, 26),
    (New-Object System.Drawing.Point 24, 24),
    (New-Object System.Drawing.Point 23, 26)
)
$g.FillPolygon($brushGold, $pMark)

# Estrella dorada arriba derecha
$brushStar = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(251, 191, 36))
$g.FillEllipse($brushStar, 34, 8, 6, 6)

$ms = New-Object System.IO.MemoryStream
$bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
$pngBytes = $ms.ToArray()
$ms.Close()

# Construir archivo .ICO con encabezado ICO y PNG payload
$icoStream = New-Object System.IO.MemoryStream
$w = New-Object System.IO.BinaryWriter $icoStream

# ICO Header
$w.Write([uint16]0) # Reserved
$w.Write([uint16]1) # ICO type
$w.Write([uint16]1) # 1 image

# Entry
$w.Write([byte]48) # Width
$w.Write([byte]48) # Height
$w.Write([byte]0)  # Colors
$w.Write([byte]0)  # Reserved
$w.Write([uint16]1) # Color planes
$w.Write([uint16]32) # Bits per pixel
$w.Write([uint32]$pngBytes.Length) # Image size
$w.Write([uint32]22) # Offset (6 header + 16 entry = 22)

# Write PNG bytes
$w.Write($pngBytes)
$w.Flush()

[System.IO.File]::WriteAllBytes("favicon.ico", $icoStream.ToArray())
[System.IO.File]::WriteAllBytes("src/main/webapp/favicon.ico", $icoStream.ToArray())
Copy-Item "img/logo.svg" "favicon.svg" -Force
Copy-Item "img/logo.svg" "src/main/webapp/favicon.svg" -Force
$bmp.Dispose()
$g.Dispose()
Write-Host "Favicons generados con exito. Bytes:" $icoStream.Length
