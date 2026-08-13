# ============================================================
# CRYPTOGRAPHY TOOL - v2.0.0
# Author  : PUTRA
# Rewrite : Fixed case-sensitivity bug (Caesar & Vigenere) + UI
# ============================================================

$Host.UI.RawUI.WindowTitle = "Cryptography Tool v2.0.0"

# ------------------------------------------------------------
# UI HELPERS
# ------------------------------------------------------------

function Write-Box {
    param(
        [string]$Title,
        [string]$Color = "Cyan",
        [int]$Width = 44
    )

    $line = "=" * ($Width - 2)
    Write-Host "+$line+" -ForegroundColor $Color
    $pad = [Math]::Max(0, $Width - 2 - $Title.Length)
    $left = [Math]::Floor($pad / 2)
    $right = $pad - $left
    Write-Host ("|" + (" " * $left) + $Title + (" " * $right) + "|") -ForegroundColor $Color
    Write-Host "+$line+" -ForegroundColor $Color
}

function Write-Menu {
    param(
        [string[]]$Items,
        [string]$Color = "White"
    )
    Write-Host ""
    foreach ($item in $Items) {
        Write-Host "  $item" -ForegroundColor $Color
    }
    Write-Host ""
}

function Read-Choice {
    param([string]$Prompt = "Pilih menu")
    Write-Host -NoNewline "  $Prompt > " -ForegroundColor Yellow
    return Read-Host
}

function Write-Result {
    param(
        [string]$Label,
        [string]$Value,
        [string]$Color = "Green"
    )
    Write-Host ""
    Write-Host "  +- $Label" -ForegroundColor $Color
    Write-Host "  |  $Value" -ForegroundColor White
    Write-Host "  +-------------------------------------" -ForegroundColor $Color
}

function Write-ErrorMsg {
    param([string]$Message)
    Write-Host ""
    Write-Host "  [X] $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host ""
    Write-Host "  [i] $Message" -ForegroundColor DarkYellow
}

function Pause-Continue {
    Write-Host ""
    Write-Host -NoNewline "  Tekan Enter untuk melanjutkan..." -ForegroundColor DarkGray
    Read-Host | Out-Null
}


# ============================================================
# CAESAR CIPHER
# ============================================================

function Caesar-Cipher {

    while ($true) {

        Clear-Host
        Write-Box -Title "CAESAR CIPHER" -Color Cyan
        Write-Menu -Items @("[1] Encrypt", "[2] Decrypt", "[3] Back")

        $operation = Read-Choice "Select operation"

        if ($operation -eq "3") { return }

        if ($operation -ne "1" -and $operation -ne "2") {
            Write-ErrorMsg "Invalid selection."
            Pause-Continue
            continue
        }

        Write-Host ""
        Write-Host -NoNewline "  Enter text : " -ForegroundColor Yellow
        $text = Read-Host
        Write-Host -NoNewline "  Enter key  : " -ForegroundColor Yellow
        $key = Read-Host

        $shift = 0

        if (-not [int]::TryParse($key, [ref]$shift)) {
            Write-ErrorMsg "Key must be a number."
            Pause-Continue
            continue
        }

        if ($operation -eq "2") {
            $shift = -$shift
        }

        $shift = (($shift % 26) + 26) % 26

        $result = ""

        foreach ($char in $text.ToCharArray()) {

            # FIX: -match is case-insensitive in PowerShell, which made
            # lowercase letters always match '[A-Z]' first and lose their
            # case. -cmatch forces a case-sensitive comparison so upper
            # and lower case letters are handled by the correct branch.
            if ($char -cmatch '[A-Z]') {

                $code = [int][char]$char
                $newCode = (($code - 65 + $shift) % 26 + 26) % 26 + 65
                $result += [char]$newCode
            }
            elseif ($char -cmatch '[a-z]') {

                $code = [int][char]$char
                $newCode = (($code - 97 + $shift) % 26 + 26) % 26 + 97
                $result += [char]$newCode
            }
            else {
                $result += $char
            }
        }

        Write-Result -Label "Result" -Value $result
        Pause-Continue
    }
}


# ============================================================
# VIGENERE CIPHER
# ============================================================

function Vigenere-Cipher {

    while ($true) {

        Clear-Host
        Write-Box -Title "VIGENERE CIPHER" -Color Cyan
        Write-Menu -Items @("[1] Encrypt", "[2] Decrypt", "[3] Back")

        $operation = Read-Choice "Select operation"

        if ($operation -eq "3") { return }

        if ($operation -ne "1" -and $operation -ne "2") {
            Write-ErrorMsg "Invalid selection."
            Pause-Continue
            continue
        }

        Write-Host ""
        Write-Host -NoNewline "  Enter text : " -ForegroundColor Yellow
        $text = Read-Host
        Write-Host -NoNewline "  Enter key  : " -ForegroundColor Yellow
        $key = Read-Host

        if ($key -notmatch '^[A-Za-z]+$') {
            Write-ErrorMsg "Key must contain letters only."
            Pause-Continue
            continue
        }

        $keyChars = $key.ToUpperInvariant().ToCharArray()

        $result = ""
        $keyIndex = 0

        foreach ($char in $text.ToCharArray()) {

            # FIX: -cmatch instead of -match so lowercase letters are
            # no longer swallowed by the uppercase branch and vice versa.
            if ($char -cmatch '[A-Z]') {

                $plainValue = [int][char]$char - 65
                $keyPosition = $keyIndex % $keyChars.Length
                $keyValue = [int][char]$keyChars[$keyPosition] - 65

                if ($operation -eq "1") {
                    $newValue = ($plainValue + $keyValue) % 26
                }
                else {
                    $newValue = ($plainValue - $keyValue + 26) % 26
                }

                $result += [char]($newValue + 65)
                $keyIndex++
            }
            elseif ($char -cmatch '[a-z]') {

                $plainValue = [int][char]$char - 97
                $keyPosition = $keyIndex % $keyChars.Length
                $keyValue = [int][char]$keyChars[$keyPosition] - 65

                if ($operation -eq "1") {
                    $newValue = ($plainValue + $keyValue) % 26
                }
                else {
                    $newValue = ($plainValue - $keyValue + 26) % 26
                }

                $result += [char]($newValue + 97)
                $keyIndex++
            }
            else {
                $result += $char
            }
        }

        Write-Result -Label "Result" -Value $result
        Pause-Continue
    }
}


# ============================================================
# XOR CIPHER
# ============================================================

function XOR-Cipher {

    while ($true) {

        Clear-Host
        Write-Box -Title "XOR CIPHER" -Color Cyan
        Write-Menu -Items @("[1] Encrypt", "[2] Decrypt", "[3] Back")

        $operation = Read-Choice "Select operation"

        if ($operation -eq "3") { return }

        if ($operation -ne "1" -and $operation -ne "2") {
            Write-ErrorMsg "Invalid selection."
            Pause-Continue
            continue
        }

        if ($operation -eq "1") {

            Write-Host ""
            Write-Host -NoNewline "  Enter text : " -ForegroundColor Yellow
            $text = Read-Host
            Write-Host -NoNewline "  Enter key  : " -ForegroundColor Yellow
            $key = Read-Host

            if ([string]::IsNullOrEmpty($key)) {
                Write-ErrorMsg "Key cannot be empty."
                Pause-Continue
                continue
            }

            $textBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
            $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($key)
            $resultBytes = New-Object byte[] $textBytes.Length

            for ($i = 0; $i -lt $textBytes.Length; $i++) {
                $resultBytes[$i] = $textBytes[$i] -bxor $keyBytes[$i % $keyBytes.Length]
            }

            $result = [BitConverter]::ToString($resultBytes).Replace("-", "")
            Write-Result -Label "Result (HEX)" -Value $result
        }
        else {

            Write-Host ""
            Write-Host -NoNewline "  Enter HEX ciphertext : " -ForegroundColor Yellow
            $hex = Read-Host
            Write-Host -NoNewline "  Enter key             : " -ForegroundColor Yellow
            $key = Read-Host

            if ([string]::IsNullOrEmpty($key)) {
                Write-ErrorMsg "Key cannot be empty."
                Pause-Continue
                continue
            }

            if ($hex -notmatch '^[0-9A-Fa-f]+$' -or $hex.Length % 2 -ne 0) {
                Write-ErrorMsg "Invalid HEX ciphertext."
                Pause-Continue
                continue
            }

            $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($key)
            $cipherBytes = New-Object byte[] ($hex.Length / 2)

            for ($i = 0; $i -lt $cipherBytes.Length; $i++) {
                $cipherBytes[$i] = [Convert]::ToByte($hex.Substring($i * 2, 2), 16)
            }

            $resultBytes = New-Object byte[] $cipherBytes.Length

            for ($i = 0; $i -lt $cipherBytes.Length; $i++) {
                $resultBytes[$i] = $cipherBytes[$i] -bxor $keyBytes[$i % $keyBytes.Length]
            }

            try {
                $result = [System.Text.Encoding]::UTF8.GetString($resultBytes)
                Write-Result -Label "Result" -Value $result
            }
            catch {
                Write-ErrorMsg "Wrong key or invalid ciphertext (result is not valid text)."
            }
        }

        Pause-Continue
    }
}


# ============================================================
# AES
# ============================================================

function AES-Tool {

    while ($true) {

        Clear-Host
        Write-Box -Title "AES" -Color Cyan
        Write-Menu -Items @("[1] AES-128", "[2] AES-192", "[3] AES-256", "[4] Back")

        $aesChoice = Read-Choice "Select AES"

        if ($aesChoice -eq "4") { return }

        switch ($aesChoice) {
            "1" { $keySize = 128 }
            "2" { $keySize = 192 }
            "3" { $keySize = 256 }
            default {
                Write-ErrorMsg "Invalid selection."
                Pause-Continue
                continue
            }
        }

        Clear-Host
        Write-Box -Title "AES-$keySize" -Color Cyan
        Write-Menu -Items @("[1] Encrypt", "[2] Decrypt", "[3] Back")

        $operation = Read-Choice "Select operation"

        if ($operation -eq "3") { continue }

        if ($operation -ne "1" -and $operation -ne "2") {
            Write-ErrorMsg "Invalid selection."
            Pause-Continue
            continue
        }

        # ----------------------------------------------------
        # AES ENCRYPT
        # ----------------------------------------------------

        if ($operation -eq "1") {

            Write-Host ""
            Write-Host -NoNewline "  Enter text : " -ForegroundColor Yellow
            $plaintext = Read-Host
            $password = Read-Host "  Enter key" -AsSecureString

            $passwordPtr = [IntPtr]::Zero
            $derive = $null
            $aes = $null

            try {
                $passwordPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
                $passwordText = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPtr)

                $salt = New-Object byte[] 16
                $rng = [Security.Cryptography.RandomNumberGenerator]::Create()
                $rng.GetBytes($salt)
                $rng.Dispose()

                $derive = New-Object System.Security.Cryptography.Rfc2898DeriveBytes(
                    $passwordText, $salt, 100000, [Security.Cryptography.HashAlgorithmName]::SHA256
                )

                $aes = [Security.Cryptography.Aes]::Create()
                $aes.KeySize = $keySize
                $aes.BlockSize = 128
                $aes.Mode = [Security.Cryptography.CipherMode]::CBC
                $aes.Padding = [Security.Cryptography.PaddingMode]::PKCS7
                $aes.Key = $derive.GetBytes($keySize / 8)
                $aes.GenerateIV()

                $plainBytes = [System.Text.Encoding]::UTF8.GetBytes($plaintext)
                $encryptor = $aes.CreateEncryptor()
                $cipherBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)

                # FORMAT: SALT + IV + CIPHERTEXT
                $combinedLength = $salt.Length + $aes.IV.Length + $cipherBytes.Length
                $combined = New-Object byte[] $combinedLength

                [Array]::Copy($salt, 0, $combined, 0, $salt.Length)
                [Array]::Copy($aes.IV, 0, $combined, $salt.Length, $aes.IV.Length)
                [Array]::Copy($cipherBytes, 0, $combined, $salt.Length + $aes.IV.Length, $cipherBytes.Length)

                $result = [BitConverter]::ToString($combined).Replace("-", "")
                Write-Result -Label "Ciphertext (HEX)" -Value $result
            }
            catch {
                Write-ErrorMsg "Encryption failed: $($_.Exception.Message)"
            }
            finally {
                if ($passwordPtr -ne [IntPtr]::Zero) {
                    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($passwordPtr)
                }
                if ($derive) { $derive.Dispose() }
                if ($aes) { $aes.Dispose() }
            }

            Pause-Continue
        }

        # ----------------------------------------------------
        # AES DECRYPT
        # ----------------------------------------------------

        else {

            Write-Host ""
            Write-Host -NoNewline "  Enter HEX ciphertext : " -ForegroundColor Yellow
            $hex = Read-Host
            $password = Read-Host "  Enter key" -AsSecureString

            $passwordPtr = [IntPtr]::Zero
            $derive = $null
            $aes = $null

            try {
                if ($hex -notmatch '^[0-9A-Fa-f]+$' -or $hex.Length % 2 -ne 0) {
                    throw "Invalid HEX ciphertext."
                }

                $combined = New-Object byte[] ($hex.Length / 2)

                for ($i = 0; $i -lt $combined.Length; $i++) {
                    $combined[$i] = [Convert]::ToByte($hex.Substring($i * 2, 2), 16)
                }

                if ($combined.Length -lt 33) {
                    throw "Invalid ciphertext."
                }

                $passwordPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
                $passwordText = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPtr)

                $salt = New-Object byte[] 16
                [Array]::Copy($combined, 0, $salt, 0, 16)

                $iv = New-Object byte[] 16
                [Array]::Copy($combined, 16, $iv, 0, 16)

                $cipherLength = $combined.Length - 32
                $cipherBytes = New-Object byte[] $cipherLength
                [Array]::Copy($combined, 32, $cipherBytes, 0, $cipherLength)

                $derive = New-Object System.Security.Cryptography.Rfc2898DeriveBytes(
                    $passwordText, $salt, 100000, [Security.Cryptography.HashAlgorithmName]::SHA256
                )

                $aes = [Security.Cryptography.Aes]::Create()
                $aes.KeySize = $keySize
                $aes.BlockSize = 128
                $aes.Mode = [Security.Cryptography.CipherMode]::CBC
                $aes.Padding = [Security.Cryptography.PaddingMode]::PKCS7
                $aes.Key = $derive.GetBytes($keySize / 8)
                $aes.IV = $iv

                $decryptor = $aes.CreateDecryptor()
                $plainBytes = $decryptor.TransformFinalBlock($cipherBytes, 0, $cipherBytes.Length)
                $result = [System.Text.Encoding]::UTF8.GetString($plainBytes)

                Write-Result -Label "Plaintext" -Value $result
            }
            catch {
                Write-ErrorMsg "Decryption failed. Wrong key or invalid ciphertext."
            }
            finally {
                if ($passwordPtr -ne [IntPtr]::Zero) {
                    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($passwordPtr)
                }
                if ($derive) { $derive.Dispose() }
                if ($aes) { $aes.Dispose() }
            }

            Pause-Continue
        }
    }
}


# ============================================================
# RSA
# ============================================================

function RSA-Tool {

    $keyDirectory = Join-Path $PSScriptRoot "keys"

    if (-not (Test-Path $keyDirectory)) {
        New-Item -ItemType Directory -Path $keyDirectory -Force | Out-Null
    }

    $privateKeyFile = Join-Path $keyDirectory "private_key.xml"
    $publicKeyFile = Join-Path $keyDirectory "public_key.xml"

    while ($true) {

        Clear-Host
        Write-Box -Title "RSA" -Color Cyan
        Write-Menu -Items @(
            "[1] Generate Key Pair",
            "[2] Encrypt",
            "[3] Decrypt",
            "[4] Key Information",
            "[5] Back"
        )

        $choice = Read-Choice "Select operation"

        # ----------------------------------------------------
        # GENERATE KEY
        # ----------------------------------------------------

        if ($choice -eq "1") {

            Clear-Host
            Write-Box -Title "RSA KEY GENERATOR" -Color Cyan
            Write-Menu -Items @("[1] RSA-2048", "[2] RSA-3072", "[3] RSA-4096", "[4] Back")

            $sizeChoice = Read-Choice "Select key size"

            switch ($sizeChoice) {
                "1" { $rsaSize = 2048 }
                "2" { $rsaSize = 3072 }
                "3" { $rsaSize = 4096 }
                "4" { continue }
                default {
                    Write-ErrorMsg "Invalid selection."
                    Pause-Continue
                    continue
                }
            }

            try {
                Write-Info "Generating RSA-$rsaSize key pair..."

                $rsa = [Security.Cryptography.RSA]::Create($rsaSize)
                $privateXml = $rsa.ToXmlString($true)
                $publicXml = $rsa.ToXmlString($false)

                [System.IO.File]::WriteAllText($privateKeyFile, $privateXml)
                [System.IO.File]::WriteAllText($publicKeyFile, $publicXml)

                $rsa.Dispose()

                Write-Host ""
                Write-Host "  [OK] Key pair generated successfully." -ForegroundColor Green
                Write-Host "    Public Key : $publicKeyFile" -ForegroundColor White
                Write-Host "    Private Key: $privateKeyFile" -ForegroundColor White
            }
            catch {
                Write-ErrorMsg "Key generation failed: $($_.Exception.Message)"
            }

            Pause-Continue
        }

        # ----------------------------------------------------
        # RSA ENCRYPT
        # ----------------------------------------------------

        elseif ($choice -eq "2") {

            if (-not (Test-Path $publicKeyFile)) {
                Write-ErrorMsg "Public key not found. Generate a key pair first."
                Pause-Continue
                continue
            }

            Clear-Host
            Write-Box -Title "RSA ENCRYPT" -Color Cyan

            Write-Host ""
            Write-Host -NoNewline "  Enter text : " -ForegroundColor Yellow
            $plaintext = Read-Host

            try {
                $publicXml = [System.IO.File]::ReadAllText($publicKeyFile)
                $rsa = [Security.Cryptography.RSA]::Create()
                $rsa.FromXmlString($publicXml)

                $plainBytes = [System.Text.Encoding]::UTF8.GetBytes($plaintext)
                $cipherBytes = $rsa.Encrypt($plainBytes, [Security.Cryptography.RSAEncryptionPadding]::OaepSHA256)

                $result = [BitConverter]::ToString($cipherBytes).Replace("-", "")
                Write-Result -Label "Ciphertext (HEX)" -Value $result

                $rsa.Dispose()
            }
            catch {
                Write-ErrorMsg "Encryption failed: $($_.Exception.Message)"
            }

            Pause-Continue
        }

        # ----------------------------------------------------
        # RSA DECRYPT
        # ----------------------------------------------------

        elseif ($choice -eq "3") {

            if (-not (Test-Path $privateKeyFile)) {
                Write-ErrorMsg "Private key not found. Generate a key pair first."
                Pause-Continue
                continue
            }

            Clear-Host
            Write-Box -Title "RSA DECRYPT" -Color Cyan

            Write-Host ""
            Write-Host -NoNewline "  Enter HEX ciphertext : " -ForegroundColor Yellow
            $hex = Read-Host

            try {
                if ($hex -notmatch '^[0-9A-Fa-f]+$' -or $hex.Length % 2 -ne 0) {
                    throw "Invalid HEX ciphertext."
                }

                $cipherBytes = New-Object byte[] ($hex.Length / 2)

                for ($i = 0; $i -lt $cipherBytes.Length; $i++) {
                    $cipherBytes[$i] = [Convert]::ToByte($hex.Substring($i * 2, 2), 16)
                }

                $privateXml = [System.IO.File]::ReadAllText($privateKeyFile)
                $rsa = [Security.Cryptography.RSA]::Create()
                $rsa.FromXmlString($privateXml)

                $plainBytes = $rsa.Decrypt($cipherBytes, [Security.Cryptography.RSAEncryptionPadding]::OaepSHA256)
                $result = [System.Text.Encoding]::UTF8.GetString($plainBytes)

                Write-Result -Label "Plaintext" -Value $result

                $rsa.Dispose()
            }
            catch {
                Write-ErrorMsg "Decryption failed. Wrong private key or invalid ciphertext."
            }

            Pause-Continue
        }

        # ----------------------------------------------------
        # KEY INFORMATION
        # ----------------------------------------------------

        elseif ($choice -eq "4") {

            Clear-Host
            Write-Box -Title "RSA KEY INFORMATION" -Color Cyan
            Write-Host ""

            if (Test-Path $publicKeyFile) {
                Write-Host "  Public Key : " -NoNewline -ForegroundColor White
                Write-Host "FOUND" -ForegroundColor Green
                Write-Host "  Location   : $publicKeyFile" -ForegroundColor DarkGray
            }
            else {
                Write-Host "  Public Key : " -NoNewline -ForegroundColor White
                Write-Host "NOT FOUND" -ForegroundColor Red
            }

            Write-Host ""

            if (Test-Path $privateKeyFile) {
                Write-Host "  Private Key: " -NoNewline -ForegroundColor White
                Write-Host "FOUND" -ForegroundColor Green
                Write-Host "  Location   : $privateKeyFile" -ForegroundColor DarkGray
            }
            else {
                Write-Host "  Private Key: " -NoNewline -ForegroundColor White
                Write-Host "NOT FOUND" -ForegroundColor Red
            }

            Pause-Continue
        }

        # ----------------------------------------------------
        # BACK
        # ----------------------------------------------------

        elseif ($choice -eq "5") {
            return
        }

        else {
            Write-ErrorMsg "Invalid selection."
            Start-Sleep -Seconds 1
        }
    }
}


# ============================================================
# MAIN MENU
# ============================================================

while ($true) {

    Clear-Host

    Write-Host ""
    Write-Host "   ____  _   _ _____ ____      _    " -ForegroundColor Magenta
    Write-Host "  |  _ \| | | |_   _|  _ \    / \   " -ForegroundColor Magenta
    Write-Host "  | |_) | | | | | | | |_) |  / _ \  " -ForegroundColor Magenta
    Write-Host "  |  __/| |_| | | | |  _ <  / ___ \ " -ForegroundColor Magenta
    Write-Host "  |_|    \___/  |_| |_| \_\/_/   \_\" -ForegroundColor Magenta
    Write-Host ""
    Write-Box -Title "CRYPTOGRAPHY TOOL" -Color Cyan -Width 44
    Write-Host "   Version : 2.0.0" -ForegroundColor DarkGray
    Write-Host "   Release : Bug Fix + UI Refresh" -ForegroundColor DarkGray
    Write-Host "   Author  : PUTRA" -ForegroundColor DarkGray
    Write-Host "   ----------------------------------" -ForegroundColor DarkGray
    Write-Host "   MAHASISWA BUKAN MAHA TAHU" -ForegroundColor DarkGray

    Write-Menu -Items @(
        "[1] Caesar Cipher",
        "[2] Vigenere Cipher",
        "[3] XOR Cipher",
        "[4] AES",
        "[5] RSA",
        "[6] Exit"
    )

    $choice = Read-Choice "Select algorithm"

    switch ($choice) {
        "1" { Caesar-Cipher }
        "2" { Vigenere-Cipher }
        "3" { XOR-Cipher }
        "4" { AES-Tool }
        "5" { RSA-Tool }
        "6" {
            Clear-Host
            Write-Host ""
            Write-Host "  Terima kasih sudah menggunakan Cryptography Tool!" -ForegroundColor Cyan
            Write-Host ""
            exit
        }
        default {
            Write-ErrorMsg "Invalid selection."
            Start-Sleep -Seconds 1
        }
    }
}