Add-Type -AssemblyName System.Drawing

$width = 1200
$height = 630
$bmp = New-Object System.Drawing.Bitmap($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Background Gradient
$rect = New-Object System.Drawing.Rectangle(0, 0, $width, $height)
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, [System.Drawing.ColorTranslator]::FromHtml('#080a13'), [System.Drawing.ColorTranslator]::FromHtml('#121526'), 45.0)
$g.FillRectangle($bgBrush, $rect)

# Ambient orange glow in top right and bottom left
$glowBrush1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 255, 121, 0))
$g.FillEllipse($glowBrush1, 750, -100, 550, 550)
$g.FillEllipse($glowBrush1, -120, 380, 450, 450)

# Outer frame border
$borderPen = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#262a42'), 2)
$g.DrawRectangle($borderPen, 20, 20, $width - 40, $height - 40)

# Orange accent line
$orangePen = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#ff7900'), 3)
$g.DrawLine($orangePen, 60, 60, 160, 60)

# Fonts
$fEyebrow = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
$fTitle = New-Object System.Drawing.Font('Segoe UI', 38, [System.Drawing.FontStyle]::Bold)
$fSub = New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Bold)
$fBody = New-Object System.Drawing.Font('Segoe UI', 13, [System.Drawing.FontStyle]::Regular)
$fPill = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
$fFooter = New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Regular)

# Brushes
$bOrange = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#ff7900'))
$bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#ffffff'))
$bMuted = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#a6a3b8'))
$bDim = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#6b6880'))
$bPillBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 255, 255, 255))
$bPillBorder = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#2d324d'), 1)

# Draw Left Content
$g.DrawString('PERSONAL PORTFOLIO / 2026', $fEyebrow, $bOrange, 60, 75)
$g.DrawString('MOHAMED AHMED ISSA', $fTitle, $bWhite, 56, 105)
$g.DrawString('Retail Operations & AI-Powered Web Applications', $fSub, $bMuted, 60, 180)
$g.DrawString('Turning real-world branch friction into high-impact digital tools.', $fBody, $bDim, 60, 220)

# Draw 4 System Badges
$systems = @(
  '01  Orange SR Encyclopedia · PWA & AI Assistant',
  '02  Orange Boutique Q-Matic · 80mm Print & HDMI TV',
  '03  Orange Retail Card Studio · Automated Imposition',
  '04  Orange SmartConnect · DSL/VDSL Self-Care Portal'
)

$sy = 275
foreach ($s in $systems) {
  $pillRect = New-Object System.Drawing.Rectangle(60, $sy, 530, 36)
  $g.FillRectangle($bPillBg, $pillRect)
  $g.DrawRectangle($bPillBorder, $pillRect)
  $g.FillRectangle($bOrange, 60, $sy, 4, 36)
  $g.DrawString($s, $fPill, $bWhite, 76, ($sy + 8))
  $sy += 46
}

# Footer info
$g.DrawString('WhatsApp: 01205979779  ·  LinkedIn: /in/mohamed-issa-885321181  ·  Cairo, Egypt', $fFooter, $bOrange, 60, 565)

# Right Side Composite Screenshot
$thumbPath = Join-Path (Get-Location) 'images\sr-bento-dashboard.jpg'
if (Test-Path $thumbPath) {
  $thumb = [System.Drawing.Image]::FromFile($thumbPath)
  $tRect = New-Object System.Drawing.Rectangle(640, 80, 500, 460)
  
  $shadowRect = New-Object System.Drawing.Rectangle(650, 90, 500, 460)
  $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(140, 0, 0, 0))
  $g.FillRectangle($shadowBrush, $shadowRect)
  
  $g.DrawImage($thumb, $tRect)
  $screenBorder = New-Object System.Drawing.Pen([System.Drawing.ColorTranslator]::FromHtml('#ff7900'), 2)
  $g.DrawRectangle($screenBorder, $tRect)
  $thumb.Dispose()
}

$outPath = Join-Path (Get-Location) 'images\og-preview.jpg'
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$g.Dispose()
$bmp.Dispose()

Write-Output "Successfully generated: $outPath"
