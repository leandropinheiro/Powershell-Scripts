Write-Output "Create Large Randon Content Files"

# Set file size
$intendedSize = Read-Host -Prompt "Enter Desired File Size with KB,MB,GB,TB All together | Default 1GB)"

if ($intendedSize -eq "") {$intendedSize = "1GB"}

# Set number of files
$files = Read-Host -Prompt "Enter Desired Files quantity (Default 1 file)"

if ($files -eq "") {$files = 1}

# Set File name
$filename = Read-Host -Prompt "Enter Desired File Name (Default test) without extension"

if ($filename -eq "") {$filename = "test"}

Write-Output "The file extension will be auto generated with file number in format .###"

# Set Directory

$dir = Read-Host -Prompt "Enter Desired path to files (default current directory)"

if ($dir -eq "") {$dir = (Get-Location).Path}
if (!(test-path $dir)) {New-Item -ItemType Directory -Path $dir}

for (($i =0); $i -lt $files; $i++)
{
# Create output buffer
$buffer = [byte[]]::new(4KB)

# Create RNG
$rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()

# Create temp file, open writable filestrem
$tempFile = [System.IO.Path]::GetTempFileName() |Get-Item
$fileStream = $tempFile.OpenWrite()

# Create final file name

$finalfilename = $dir+"\"+$filename+"."+('{0:d3}' -f $i)

Write-Output $i 
Write-Output $finalfilename

do {
    # Fill buffer, write to disk, rinse-repeat
    $rng.GetBytes($buffer)
    $fileStream.Write($buffer, 0, $buffer.Length)
} while($fileStream.Length -lt $intendedSize)
 
$fileStream.Close()
if (test-path $finalfilename) {Remove-item $finalfilename}
$tempfile.MoveTo($finalfilename)

# Dispose if filestream + RNG

$fileStream.Dispose()
$rng.Dispose()
}
