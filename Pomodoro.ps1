# --- LIMPIEZA DE MEMORIA ---
if ($script:timer) { $script:timer.Stop(); $script:timer.Dispose() }

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- VARIABLES ---
$script:minutes = 25
$script:seconds = 0
$script:timerRunning = $false
$script:sessions = 0
$script:isMini = $false

# [ARREGLO DEL ICONO] Generamos el tomate por código para evitar errores de texto
$iconTomato = [System.Char]::ConvertFromUtf32(0x1F345) 

# --- COLORES ---
$c_bg = [System.Drawing.ColorTranslator]::FromHtml("#121212")
$c_panel = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")
$c_text = [System.Drawing.ColorTranslator]::FromHtml("#E0E0E0")
$c_accent = [System.Drawing.ColorTranslator]::FromHtml("#4CAF50") # Verde
$c_warn = [System.Drawing.ColorTranslator]::FromHtml("#FF9800")   # Naranja
$c_danger = [System.Drawing.ColorTranslator]::FromHtml("#F44336") # Rojo

# --- FORMULARIO ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Pomodoro Ultimate"
$form.Size = New-Object System.Drawing.Size(360, 600)
$form.StartPosition = "CenterScreen"
$form.BackColor = $c_bg
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.KeyPreview = $true 

# --- BOTÓN MODO MINI ---
$btnMini = New-Object System.Windows.Forms.Button
$btnMini.Text = "↗" 
$btnMini.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnMini.Size = New-Object System.Drawing.Size(35, 30)
$btnMini.Location = New-Object System.Drawing.Point(300, 10)
$btnMini.BackColor = "#333"
$btnMini.ForeColor = "White"
$btnMini.FlatStyle = "Flat"
$btnMini.FlatAppearance.BorderSize = 0
$btnMini.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnMini.Add_Click({
    if ($script:isMini) {
        # RESTAURAR
        $form.Size = New-Object System.Drawing.Size(360, 600)
        $btnMini.Location = New-Object System.Drawing.Point(300, 10) 
        $btnMini.Text = "↗"
        $panel.Visible = $true; $txtTask.Visible = $true; $lblOpacity.Visible = $true; $trackOpacity.Visible = $true; $lblSessions.Visible = $true
        $script:isMini = $false
    } else {
        # MINIMIZAR
        $form.Size = New-Object System.Drawing.Size(300, 250)
        $btnMini.Location = New-Object System.Drawing.Point(240, 10) 
        $btnMini.Text = "□"
        $panel.Visible = $false; $txtTask.Visible = $false; $lblOpacity.Visible = $false; $trackOpacity.Visible = $false; $lblSessions.Visible = $false
        $script:isMini = $true
    }
})

# --- RELOJ ---
$lblTimer = New-Object System.Windows.Forms.Label
$lblTimer.Text = "{0:00}:{1:00}" -f $script:minutes, $script:seconds
$lblTimer.Font = New-Object System.Drawing.Font("Consolas", 55, [System.Drawing.FontStyle]::Bold)
$lblTimer.ForeColor = $c_text
$lblTimer.TextAlign = "MiddleCenter"
$lblTimer.Dock = "Top"
$lblTimer.Height = 130
$lblTimer.Padding = New-Object System.Windows.Forms.Padding(0, 30, 0, 0)

# --- FUNCIÓN SET TIME ---
function Set-Time($m) {
    $script:timer.Stop(); $script:timerRunning = $false
    $script:minutes = $m; $script:seconds = 0
    $lblTimer.Text = "{0:00}:{1:00}" -f $script:minutes, 0
    $lblTimer.ForeColor = $c_text
    $btnStart.Text = "INICIAR"; $btnStart.BackColor = $c_accent; $btnStart.ForeColor = "White"
}

# --- PANEL BOTONES ---
$panel = New-Object System.Windows.Forms.Panel
$panel.Size = New-Object System.Drawing.Size(340, 50)
$panel.Location = New-Object System.Drawing.Point(10, 140)

function Crear-Boton($txt, $x, $accion) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $txt; $btn.Location = New-Object System.Drawing.Point($x, 0)
    $btn.Size = New-Object System.Drawing.Size(60, 40); $btn.BackColor = $c_panel; $btn.ForeColor = $c_text
    $btn.FlatStyle = "Flat"; $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn.Add_Click($accion)
    return $btn
}

$b10 = Crear-Boton "10m" 0 { Set-Time 10 }
$b25 = Crear-Boton "25m" 70 { Set-Time 25 }
$b30 = Crear-Boton "30m" 140 { Set-Time 30 }

$txtCustom = New-Object System.Windows.Forms.TextBox
$txtCustom.Location = New-Object System.Drawing.Point(210, 5); $txtCustom.Size = New-Object System.Drawing.Size(50, 30)
$txtCustom.Font = New-Object System.Drawing.Font("Segoe UI", 14); $txtCustom.BackColor = $c_panel; $txtCustom.ForeColor = "White"
$txtCustom.BorderStyle = "None"; $txtCustom.TextAlign = "Center"

$bOk = Crear-Boton "OK" 270 {
    $val = 0
    if ([int]::TryParse($txtCustom.Text, [ref]$val) -and $val -gt 0) { Set-Time $val }
}
$bOk.Size = New-Object System.Drawing.Size(40, 40)
$panel.Controls.AddRange(@($b10, $b25, $b30, $txtCustom, $bOk))

# --- TAREA ---
$txtTask = New-Object System.Windows.Forms.TextBox
$txtTask.Text = "Escribe tu tarea aquí..."
$txtTask.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Italic)
$txtTask.ForeColor = "Gray"; $txtTask.BackColor = "#1A1A1A"; $txtTask.BorderStyle = "FixedSingle"
$txtTask.TextAlign = "Center"; $txtTask.Location = New-Object System.Drawing.Point(50, 200); $txtTask.Size = New-Object System.Drawing.Size(230, 30)
$txtTask.Add_GotFocus({ if ($txtTask.Text -eq "Escribe tu tarea aquí...") { $txtTask.Text = ""; $txtTask.ForeColor = "White"; $txtTask.Font = New-Object System.Drawing.Font("Segoe UI", 12) }})

# --- BOTÓN INICIAR ---
$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Text = "INICIAR"; $btnStart.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$btnStart.Location = New-Object System.Drawing.Point(50, 250); $btnStart.Size = New-Object System.Drawing.Size(230, 60)
$btnStart.BackColor = $c_accent; $btnStart.ForeColor = "White"; $btnStart.FlatStyle = "Flat"; $btnStart.FlatAppearance.BorderSize = 0

# --- CONTADOR (CON FUENTE EMOJI) ---
$lblSessions = New-Object System.Windows.Forms.Label
$lblSessions.Text = "Sesiones completadas: 0"
# Aquí usamos Segoe UI Emoji para asegurar que el tomate se vea bien
$lblSessions.Font = New-Object System.Drawing.Font("Segoe UI Emoji", 11) 
$lblSessions.ForeColor = "#888888"
$lblSessions.AutoSize = $false; $lblSessions.TextAlign = "MiddleCenter"
$lblSessions.Location = New-Object System.Drawing.Point(0, 320); $lblSessions.Size = New-Object System.Drawing.Size(360, 30)

# --- OPACIDAD ---
$lblOpacity = New-Object System.Windows.Forms.Label; $lblOpacity.Text = "Opacidad"
$lblOpacity.ForeColor = "Gray"; $lblOpacity.Location = New-Object System.Drawing.Point(20, 370); $lblOpacity.AutoSize = $true
$trackOpacity = New-Object System.Windows.Forms.TrackBar; $trackOpacity.Location = New-Object System.Drawing.Point(20, 390)
$trackOpacity.Size = New-Object System.Drawing.Size(300, 45); $trackOpacity.Minimum = 20; $trackOpacity.Maximum = 100; $trackOpacity.Value = 100
$trackOpacity.TickFrequency = 10; $trackOpacity.Add_Scroll({ $form.Opacity = $trackOpacity.Value / 100 })

# --- TIMER ---
$script:timer = New-Object System.Windows.Forms.Timer; $script:timer.Interval = 1000
$script:timer.Add_Tick({
    if ($script:seconds -eq 0 -and $script:minutes -eq 0) {
        $script:timer.Stop(); $script:timerRunning = $false
        $script:sessions++
        
        # ACTUALIZACIÓN DEL TEXTO CON LA VARIABLE SEGURA
        $lblSessions.Text = "Sesiones completadas: $script:sessions $iconTomato"
        $lblSessions.ForeColor = "#FF6347"
        
        $btnStart.Text = "FIN"; $btnStart.BackColor = $c_danger
        [System.Media.SystemSounds]::Exclamation.Play()
        [System.Windows.Forms.MessageBox]::Show("¡Sesión completada!", "Felicidades")
        return
    }
    if ($script:seconds -eq 0) { $script:minutes--; $script:seconds = 59 } else { $script:seconds-- }
    if ($script:minutes -eq 0) {
        if ($script:seconds -lt 10) { $lblTimer.ForeColor = $c_danger } else { $lblTimer.ForeColor = $c_warn }   
    } else { $lblTimer.ForeColor = $c_text }
    $lblTimer.Text = "{0:00}:{1:00}" -f $script:minutes, $script:seconds
})

# --- EVENTOS ---
$btnStart.Add_Click({
    if ($script:timerRunning) {
        $script:timer.Stop(); $script:timerRunning = $false
        $btnStart.Text = "CONTINUAR"; $btnStart.BackColor = "#FFC107"; $btnStart.ForeColor = "Black"
    } else {
        if ($script:minutes -eq 0 -and $script:seconds -eq 0) { return }
        $script:timer.Start(); $script:timerRunning = $true
        $btnStart.Text = "PAUSAR"; $btnStart.BackColor = "#333333"; $btnStart.ForeColor = "White"
    }
})

$form.Add_KeyDown({
    if ($_.KeyCode -eq 'Space' -and -not $txtTask.Focused) { $btnStart.PerformClick() }
    if ($_.KeyCode -eq 'Escape') {
        $script:timer.Stop(); $script:timerRunning = $false
        $btnStart.Text = "INICIAR"; $btnStart.BackColor = $c_accent; $btnStart.ForeColor = "White"
    }
})

$form.Controls.AddRange(@($btnMini, $lblTimer, $panel, $txtTask, $btnStart, $lblSessions, $lblOpacity, $trackOpacity))
$form.ShowDialog() | Out-Null