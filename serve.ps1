param(
    [int]$Port = 8321,
    [switch]$NoOpen
)

# Tiny static file server for the Finnish tutor worksheets.
# Only needed if the browser refuses microphone access on file:// pages --
# speech recognition always works over http://localhost.

$root = $PSScriptRoot
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
try {
    $listener.Start()
} catch {
    Write-Host "Could not start on port $Port (already running?). Try: .\serve.ps1 -Port 8322"
    exit 1
}

if (-not $NoOpen) {
    $ws = Get-ChildItem (Join-Path $root 'tutor\worksheets') -Filter *.html -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($ws) {
        $rel = $ws.FullName.Substring($root.Length + 1) -replace '\\', '/'
        Start-Process "http://localhost:$Port/$rel"
    } else {
        Start-Process "http://localhost:$Port/"
    }
}

Write-Host "Serving '$root' at http://localhost:$Port/ -- Ctrl+C to stop"

$mime = @{
    '.html' = 'text/html; charset=utf-8'
    '.json' = 'application/json; charset=utf-8'
    '.css'  = 'text/css; charset=utf-8'
    '.js'   = 'text/javascript; charset=utf-8'
    '.png'  = 'image/png'
    '.svg'  = 'image/svg+xml'
    '.ico'  = 'image/x-icon'
}

while ($listener.IsListening) {
    try {
        $ctx = $listener.GetContext()
    } catch {
        break
    }
    $res = $ctx.Response
    try {
        $path = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath)
        if ($path -eq '/' -or $path -eq '') {
            $links = Get-ChildItem (Join-Path $root 'tutor\worksheets') -Filter *.html -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending |
                ForEach-Object { "<li><a href=""/tutor/worksheets/$($_.Name)"">$($_.Name)</a></li>" }
            $html = "<!DOCTYPE html><html><head><meta charset='utf-8'><title>Harjoitukset</title></head><body style='font-family:sans-serif;max-width:40rem;margin:3rem auto'><h1>Worksheets</h1><ul>$($links -join '')</ul></body></html>"
            $bytes = [Text.Encoding]::UTF8.GetBytes($html)
            $res.ContentType = 'text/html; charset=utf-8'
            $res.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $file = Join-Path $root ($path.TrimStart('/') -replace '/', '\')
            $full = [IO.Path]::GetFullPath($file)
            if (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) {
                $res.StatusCode = 403
            } elseif (Test-Path $full -PathType Leaf) {
                $ext = [IO.Path]::GetExtension($full).ToLower()
                $res.ContentType = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { 'application/octet-stream' }
                $bytes = [IO.File]::ReadAllBytes($full)
                $res.OutputStream.Write($bytes, 0, $bytes.Length)
            } else {
                $res.StatusCode = 404
            }
        }
    } catch {
        try { $res.StatusCode = 500 } catch {}
    } finally {
        try { $res.Close() } catch {}
    }
}
