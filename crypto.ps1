Clear-Host

# ============================================================
# CRYPTOGRAPHY TOOL
# ============================================================


# ============================================================
# CAESAR CIPHER
# ============================================================

function Caesar-Cipher {

    while ($true) {

        Clear-Host

        Write-Host "========================================"
        Write-Host "          CAESAR CIPHER"
        Write-Host "========================================"
        Write-Host ""
        Write-Host "[1] Encrypt"
        Write-Host "[2] Decrypt"
        Write-Host "[3] Back"
        Write-Host ""

        $operation = Read-Host "Select operation"

        if ($operation -eq "3") {
            return
        }

        if ($operation -ne "1" -and $operation -ne "2") {
            Write-Host ""
            Write-Host "Invalid selection."
            Read-Host "Press Enter to continue"
            continue
        }

        Write-Host ""

        $text = Read-Host "Enter text"
        $key = Read-Host "Enter key"

        $shift = 0

        if (-not [int]::TryParse($key, [ref]$shift)) {
            Write-Host ""
            Write-Host "Key must be a number."
            Read-Host "Press Enter to continue"
            continue
        }

        if ($operation -eq "2") {
            $shift = -$shift
        }

        $shift = $shift % 26

        $result = ""

        foreach ($char in $text.ToCharArray()) {

            if ($char -match '[A-Z]') {

                $code = [int][char]$char

                $newCode =
                    (($code - 65 + $shift) % 26 + 26) % 26 + 65

                $result += [char]$newCode
            }

            elseif ($char -match '[a-z]') {

                $code = [int][char]$char

                $newCode =
                    (($code - 97 + $shift) % 26 + 26) % 26 + 97

                $result += [char]$newCode
            }

            else {

                $result += $char
            }
        }

        Write-Host ""
        Write-Host "Result : $result"
        Write-Host ""

        Read-Host "Press Enter to continue"
    }
}


# ============================================================
# VIGENERE CIPHER
# ============================================================

function Vigenere-Cipher {

    while ($true) {

        Clear-Host

        Write-Host "========================================"
        Write-Host "          VIGENERE CIPHER"
        Write-Host "========================================"
        Write-Host ""
        Write-Host "[1] Encrypt"
        Write-Host "[2] Decrypt"
        Write-Host "[3] Back"
        Write-Host ""

        $operation = Read-Host "Select operation"

        if ($operation -eq "3") {
            return
        }

        if ($operation -ne "1" -and $operation -ne "2") {
            Write-Host ""
            Write-Host "Invalid selection."
            Read-Host "Press Enter to continue"
            continue
        }

        Write-Host ""

        $text = Read-Host "Enter text"
        $key = Read-Host "Enter key"

        if ($key -notmatch '^[A-Za-z]+$') {

            Write-Host ""
            Write-Host "Key must contain letters only."
            Read-Host "Press Enter to continue"
            continue
        }

        $keyChars = $key.ToCharArray()

        for ($i = 0; $i -lt $keyChars.Length; $i++) {

            $ascii = [int][char]$keyChars[$i]

            if ($ascii -ge 97 -and $ascii -le 122) {

                $keyChars[$i] = [char]($ascii - 32)
            }
        }

        $result = ""
        $keyIndex = 0

        foreach ($char in $text.ToCharArray()) {

            if ($char -match '[A-Z]') {

                $plainValue = [int][char]$char - 65

                $keyPosition =
                    $keyIndex % $keyChars.Length

                $keyValue =
                    [int][char]$keyChars[$keyPosition] - 65

                if ($operation -eq "1") {

                    $newValue =
                        ($plainValue + $keyValue) % 26
                }
                else {

                    $newValue =
                        ($plainValue - $keyValue + 26) % 26
                }

                $result += [char]($newValue + 65)

                $keyIndex++
            }

            elseif ($char -match '[a-z]') {

                $plainValue = [int][char]$char - 97

                $keyPosition =
                    $keyIndex % $keyChars.Length

                $keyValue =
                    [int][char]$keyChars[$keyPosition] - 65

                if ($operation -eq "1") {

                    $newValue =
                        ($plainValue + $keyValue) % 26
                }
                else {

                    $newValue =
                        ($plainValue - $keyValue + 26) % 26
                }

                $result += [char]($newValue + 97)

                $keyIndex++
            }

            else {

                $result += $char
            }
        }

        Write-Host ""
        Write-Host "Result : $result"
        Write-Host ""

        Read-Host "Press Enter to continue"
    }
}


# ============================================================
# XOR CIPHER
# ============================================================

function XOR-Cipher {

    while ($true) {

        Clear-Host

        Write-Host "========================================"
        Write-Host "             XOR CIPHER"
        Write-Host "========================================"
        Write-Host ""
        Write-Host "[1] Encrypt"
        Write-Host "[2] Decrypt"
        Write-Host "[3] Back"
        Write-Host ""

        $operation = Read-Host "Select operation"

        if ($operation -eq "3") {
            return
        }

        if ($operation -ne "1" -and $operation -ne "2") {
            Write-Host ""
            Write-Host "Invalid selection."
            Read-Host "Press Enter to continue"
            continue
        }

        Write-Host ""

        if ($operation -eq "1") {

            $text = Read-Host "Enter text"
            $key = Read-Host "Enter key"

            if ([string]::IsNullOrEmpty($key)) {

                Write-Host ""
                Write-Host "Key cannot be empty."
                Read-Host "Press Enter to continue"
                continue
            }

            $textBytes =
                [System.Text.Encoding]::UTF8.GetBytes($text)

            $keyBytes =
                [System.Text.Encoding]::UTF8.GetBytes($key)

            $resultBytes =
                New-Object byte[] $textBytes.Length

            for ($i = 0; $i -lt $textBytes.Length; $i++) {

                $resultBytes[$i] =
                    $textBytes[$i] -bxor
                    $keyBytes[$i % $keyBytes.Length]
            }

            $result =
                [BitConverter]::ToString($resultBytes).Replace("-", "")

            Write-Host ""
            Write-Host "Result (HEX) : $result"
        }

        else {

            $hex = Read-Host "Enter HEX ciphertext"
            $key = Read-Host "Enter key"

            if ([string]::IsNullOrEmpty($key)) {

                Write-Host ""
                Write-Host "Key cannot be empty."
                Read-Host "Press Enter to continue"
                continue
            }

            if ($hex -notmatch '^[0-9A-Fa-f]+$' -or
                $hex.Length % 2 -ne 0) {

                Write-Host ""
                Write-Host "Invalid HEX ciphertext."
                Read-Host "Press Enter to continue"
                continue
            }

            $keyBytes =
                [System.Text.Encoding]::UTF8.GetBytes($key)

            $cipherBytes =
                New-Object byte[] ($hex.Length / 2)

            for ($i = 0; $i -lt $cipherBytes.Length; $i++) {

                $cipherBytes[$i] =
                    [Convert]::ToByte(
                        $hex.Substring($i * 2, 2),
                        16
                    )
            }

            $resultBytes =
                New-Object byte[] $cipherBytes.Length

            for ($i = 0; $i -lt $cipherBytes.Length; $i++) {

                $resultBytes[$i] =
                    $cipherBytes[$i] -bxor
                    $keyBytes[$i % $keyBytes.Length]
            }

            $result =
                [System.Text.Encoding]::UTF8.GetString($resultBytes)

            Write-Host ""
            Write-Host "Result : $result"
        }

        Write-Host ""

        Read-Host "Press Enter to continue"
    }
}


# ============================================================
# AES
# ============================================================

function AES-Tool {

    while ($true) {

        Clear-Host

        Write-Host "========================================"
        Write-Host "                 AES"
        Write-Host "========================================"
        Write-Host ""
        Write-Host "[1] AES-128"
        Write-Host "[2] AES-192"
        Write-Host "[3] AES-256"
        Write-Host "[4] Back"
        Write-Host ""

        $aesChoice = Read-Host "Select AES"

        if ($aesChoice -eq "4") {
            return
        }

        switch ($aesChoice) {

            "1" {
                $keySize = 128
            }

            "2" {
                $keySize = 192
            }

            "3" {
                $keySize = 256
            }

            default {

                Write-Host ""
                Write-Host "Invalid selection."
                Read-Host "Press Enter to continue"
                continue
            }
        }

        Clear-Host

        Write-Host "========================================"
        Write-Host "              AES-$keySize"
        Write-Host "========================================"
        Write-Host ""
        Write-Host "[1] Encrypt"
        Write-Host "[2] Decrypt"
        Write-Host "[3] Back"
        Write-Host ""

        $operation = Read-Host "Select operation"

        if ($operation -eq "3") {
            continue
        }

        if ($operation -ne "1" -and $operation -ne "2") {

            Write-Host ""
            Write-Host "Invalid selection."
            Read-Host "Press Enter to continue"
            continue
        }

        # ----------------------------------------------------
        # AES ENCRYPT
        # ----------------------------------------------------

        if ($operation -eq "1") {

            Write-Host ""

            $plaintext = Read-Host "Enter text"

            $password =
                Read-Host "Enter key" -AsSecureString

            $passwordPtr = [IntPtr]::Zero
            $derive = $null
            $aes = $null

            try {

                $passwordPtr =
                    [Runtime.InteropServices.Marshal]::SecureStringToBSTR(
                        $password
                    )

                $passwordText =
                    [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
                        $passwordPtr
                    )

                # Random salt
                $salt = New-Object byte[] 16

                $rng =
                    [Security.Cryptography.RandomNumberGenerator]::Create()

                $rng.GetBytes($salt)

                $rng.Dispose()

                # PBKDF2
                $derive =
                    New-Object System.Security.Cryptography.Rfc2898DeriveBytes(
                        $passwordText,
                        $salt,
                        100000,
                        [Security.Cryptography.HashAlgorithmName]::SHA256
                    )

                $aes =
                    [Security.Cryptography.Aes]::Create()

                $aes.KeySize = $keySize
                $aes.BlockSize = 128
                $aes.Mode =
                    [Security.Cryptography.CipherMode]::CBC
                $aes.Padding =
                    [Security.Cryptography.PaddingMode]::PKCS7

                $aes.Key =
                    $derive.GetBytes($keySize / 8)

                # Random IV
                $aes.GenerateIV()

                $plainBytes =
                    [System.Text.Encoding]::UTF8.GetBytes(
                        $plaintext
                    )

                $encryptor =
                    $aes.CreateEncryptor()

                $cipherBytes =
                    $encryptor.TransformFinalBlock(
                        $plainBytes,
                        0,
                        $plainBytes.Length
                    )

                # ------------------------------------------------
                # FORMAT:
                #
                # SALT + IV + CIPHERTEXT
                # ------------------------------------------------

                $combinedLength =
                    $salt.Length +
                    $aes.IV.Length +
                    $cipherBytes.Length

                $combined =
                    New-Object byte[] $combinedLength

                [Array]::Copy(
                    $salt,
                    0,
                    $combined,
                    0,
                    $salt.Length
                )

                [Array]::Copy(
                    $aes.IV,
                    0,
                    $combined,
                    $salt.Length,
                    $aes.IV.Length
                )

                [Array]::Copy(
                    $cipherBytes,
                    0,
                    $combined,
                    $salt.Length + $aes.IV.Length,
                    $cipherBytes.Length
                )

                # HEX output
                $result =
                    [BitConverter]::ToString(
                        $combined
                    ).Replace("-", "")

                Write-Host ""
                Write-Host "Ciphertext (HEX):"
                Write-Host $result
            }

            catch {

                Write-Host ""
                Write-Host "Encryption failed."
                Write-Host $_.Exception.Message
            }

            finally {

                if ($passwordPtr -ne [IntPtr]::Zero) {

                    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR(
                        $passwordPtr
                    )
                }

                if ($derive) {
                    $derive.Dispose()
                }

                if ($aes) {
                    $aes.Dispose()
                }
            }

            Write-Host ""
            Read-Host "Press Enter to continue"
        }

        # ----------------------------------------------------
        # AES DECRYPT
        # ----------------------------------------------------

        else {

            Write-Host ""

            $hex =
                Read-Host "Enter HEX ciphertext"

            $password =
                Read-Host "Enter key" -AsSecureString

            $passwordPtr = [IntPtr]::Zero
            $derive = $null
            $aes = $null

            try {

                if ($hex -notmatch '^[0-9A-Fa-f]+$' -or
                    $hex.Length % 2 -ne 0) {

                    throw "Invalid HEX ciphertext."
                }

                $combined =
                    New-Object byte[] ($hex.Length / 2)

                for ($i = 0;
                     $i -lt $combined.Length;
                     $i++) {

                    $combined[$i] =
                        [Convert]::ToByte(
                            $hex.Substring($i * 2, 2),
                            16
                        )
                }

                # Salt = 16 bytes
                # IV   = 16 bytes
                if ($combined.Length -lt 33) {

                    throw "Invalid ciphertext."
                }

                # Password
                $passwordPtr =
                    [Runtime.InteropServices.Marshal]::SecureStringToBSTR(
                        $password
                    )

                $passwordText =
                    [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
                        $passwordPtr
                    )

                # Extract SALT
                $salt =
                    New-Object byte[] 16

                [Array]::Copy(
                    $combined,
                    0,
                    $salt,
                    0,
                    16
                )

                # Extract IV
                $iv =
                    New-Object byte[] 16

                [Array]::Copy(
                    $combined,
                    16,
                    $iv,
                    0,
                    16
                )

                # Extract ciphertext
                $cipherLength =
                    $combined.Length - 32

                $cipherBytes =
                    New-Object byte[] $cipherLength

                [Array]::Copy(
                    $combined,
                    32,
                    $cipherBytes,
                    0,
                    $cipherLength
                )

                # PBKDF2
                $derive =
                    New-Object System.Security.Cryptography.Rfc2898DeriveBytes(
                        $passwordText,
                        $salt,
                        100000,
                        [Security.Cryptography.HashAlgorithmName]::SHA256
                    )

                $aes =
                    [Security.Cryptography.Aes]::Create()

                $aes.KeySize = $keySize
                $aes.BlockSize = 128
                $aes.Mode =
                    [Security.Cryptography.CipherMode]::CBC
                $aes.Padding =
                    [Security.Cryptography.PaddingMode]::PKCS7

                $aes.Key =
                    $derive.GetBytes($keySize / 8)

                $aes.IV = $iv

                $decryptor =
                    $aes.CreateDecryptor()

                $plainBytes =
                    $decryptor.TransformFinalBlock(
                        $cipherBytes,
                        0,
                        $cipherBytes.Length
                    )

                $result =
                    [System.Text.Encoding]::UTF8.GetString(
                        $plainBytes
                    )

                Write-Host ""
                Write-Host "Plaintext:"
                Write-Host $result
            }

            catch {

                Write-Host ""
                Write-Host "Decryption failed."
                Write-Host "Wrong key or invalid ciphertext."
            }

            finally {

                if ($passwordPtr -ne [IntPtr]::Zero) {

                    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR(
                        $passwordPtr
                    )
                }

                if ($derive) {
                    $derive.Dispose()
                }

                if ($aes) {
                    $aes.Dispose()
                }
            }

            Write-Host ""
            Read-Host "Press Enter to continue"
        }
    }
}


# ============================================================
# RSA
# ============================================================

function RSA-Tool {

    $keyDirectory =
        Join-Path $PSScriptRoot "keys"

    if (-not (Test-Path $keyDirectory)) {

        New-Item `
            -ItemType Directory `
            -Path $keyDirectory `
            -Force |
            Out-Null
    }

    $privateKeyFile =
        Join-Path $keyDirectory "private_key.xml"

    $publicKeyFile =
        Join-Path $keyDirectory "public_key.xml"

    while ($true) {

        Clear-Host

        Write-Host "========================================"
        Write-Host "                 RSA"
        Write-Host "========================================"
        Write-Host ""
        Write-Host "[1] Generate Key Pair"
        Write-Host "[2] Encrypt"
        Write-Host "[3] Decrypt"
        Write-Host "[4] Key Information"
        Write-Host "[5] Back"
        Write-Host ""

        $choice = Read-Host "Select operation"

        # ----------------------------------------------------
        # GENERATE KEY
        # ----------------------------------------------------

        if ($choice -eq "1") {

            Clear-Host

            Write-Host "========================================"
            Write-Host "          RSA KEY GENERATOR"
            Write-Host "========================================"
            Write-Host ""
            Write-Host "[1] RSA-2048"
            Write-Host "[2] RSA-3072"
            Write-Host "[3] RSA-4096"
            Write-Host "[4] Back"
            Write-Host ""

            $sizeChoice =
                Read-Host "Select key size"

            switch ($sizeChoice) {

                "1" {
                    $rsaSize = 2048
                }

                "2" {
                    $rsaSize = 3072
                }

                "3" {
                    $rsaSize = 4096
                }

                "4" {
                    continue
                }

                default {

                    Write-Host ""
                    Write-Host "Invalid selection."
                    Read-Host "Press Enter to continue"
                    continue
                }
            }

            try {

                Write-Host ""
                Write-Host "Generating RSA-$rsaSize key pair..."
                Write-Host ""

                $rsa =
                    [Security.Cryptography.RSA]::Create(
                        $rsaSize
                    )

                $privateXml =
                    $rsa.ToXmlString($true)

                $publicXml =
                    $rsa.ToXmlString($false)

                [System.IO.File]::WriteAllText(
                    $privateKeyFile,
                    $privateXml
                )

                [System.IO.File]::WriteAllText(
                    $publicKeyFile,
                    $publicXml
                )

                $rsa.Dispose()

                Write-Host "Key pair generated successfully."
                Write-Host ""
                Write-Host "Public Key : $publicKeyFile"
                Write-Host "Private Key: $privateKeyFile"
            }

            catch {

                Write-Host ""
                Write-Host "Key generation failed."
                Write-Host $_.Exception.Message
            }

            Write-Host ""
            Read-Host "Press Enter to continue"
        }

        # ----------------------------------------------------
        # RSA ENCRYPT
        # ----------------------------------------------------

        elseif ($choice -eq "2") {

            if (-not (Test-Path $publicKeyFile)) {

                Write-Host ""
                Write-Host "Public key not found."
                Write-Host "Generate a key pair first."
                Read-Host "Press Enter to continue"
                continue
            }

            Clear-Host

            Write-Host "========================================"
            Write-Host "             RSA ENCRYPT"
            Write-Host "========================================"
            Write-Host ""

            $plaintext =
                Read-Host "Enter text"

            try {

                $publicXml =
                    [System.IO.File]::ReadAllText(
                        $publicKeyFile
                    )

                $rsa =
                    [Security.Cryptography.RSA]::Create()

                $rsa.FromXmlString($publicXml)

                $plainBytes =
                    [System.Text.Encoding]::UTF8.GetBytes(
                        $plaintext
                    )

                $cipherBytes =
                    $rsa.Encrypt(
                        $plainBytes,
                        [Security.Cryptography.RSAEncryptionPadding]::OaepSHA256
                    )

                $result =
                    [BitConverter]::ToString(
                        $cipherBytes
                    ).Replace("-", "")

                Write-Host ""
                Write-Host "Ciphertext (HEX):"
                Write-Host $result

                $rsa.Dispose()
            }

            catch {

                Write-Host ""
                Write-Host "Encryption failed."
                Write-Host $_.Exception.Message
            }

            Write-Host ""
            Read-Host "Press Enter to continue"
        }

        # ----------------------------------------------------
        # RSA DECRYPT
        # ----------------------------------------------------

        elseif ($choice -eq "3") {

            if (-not (Test-Path $privateKeyFile)) {

                Write-Host ""
                Write-Host "Private key not found."
                Write-Host "Generate a key pair first."
                Read-Host "Press Enter to continue"
                continue
            }

            Clear-Host

            Write-Host "========================================"
            Write-Host "             RSA DECRYPT"
            Write-Host "========================================"
            Write-Host ""

            $hex =
                Read-Host "Enter HEX ciphertext"

            try {

                if ($hex -notmatch '^[0-9A-Fa-f]+$' -or
                    $hex.Length % 2 -ne 0) {

                    throw "Invalid HEX ciphertext."
                }

                $cipherBytes =
                    New-Object byte[] ($hex.Length / 2)

                for ($i = 0;
                     $i -lt $cipherBytes.Length;
                     $i++) {

                    $cipherBytes[$i] =
                        [Convert]::ToByte(
                            $hex.Substring($i * 2, 2),
                            16
                        )
                }

                $privateXml =
                    [System.IO.File]::ReadAllText(
                        $privateKeyFile
                    )

                $rsa =
                    [Security.Cryptography.RSA]::Create()

                $rsa.FromXmlString($privateXml)

                $plainBytes =
                    $rsa.Decrypt(
                        $cipherBytes,
                        [Security.Cryptography.RSAEncryptionPadding]::OaepSHA256
                    )

                $result =
                    [System.Text.Encoding]::UTF8.GetString(
                        $plainBytes
                    )

                Write-Host ""
                Write-Host "Plaintext:"
                Write-Host $result

                $rsa.Dispose()
            }

            catch {

                Write-Host ""
                Write-Host "Decryption failed."
                Write-Host "Wrong private key or invalid ciphertext."
            }

            Write-Host ""
            Read-Host "Press Enter to continue"
        }

        # ----------------------------------------------------
        # KEY INFORMATION
        # ----------------------------------------------------

        elseif ($choice -eq "4") {

            Clear-Host

            Write-Host "========================================"
            Write-Host "           RSA KEY INFORMATION"
            Write-Host "========================================"
            Write-Host ""

            if (Test-Path $publicKeyFile) {

                Write-Host "Public Key : FOUND"
                Write-Host "Location   : $publicKeyFile"
            }
            else {

                Write-Host "Public Key : NOT FOUND"
            }

            Write-Host ""

            if (Test-Path $privateKeyFile) {

                Write-Host "Private Key: FOUND"
                Write-Host "Location   : $privateKeyFile"
            }
            else {

                Write-Host "Private Key: NOT FOUND"
            }

            Write-Host ""

            Read-Host "Press Enter to continue"
        }

        # ----------------------------------------------------
        # BACK
        # ----------------------------------------------------

        elseif ($choice -eq "5") {

            return
        }

        else {

            Write-Host ""
            Write-Host "Invalid selection."
            Start-Sleep -Seconds 1
        }
    }
}


# ============================================================
# MAIN MENU
# ============================================================

while ($true) {

    Clear-Host
    Write-Host "========================================"
    Write-Host @'
 ____  _   _ _____ ____      _    
|  _ \| | | |_   _|  _ \    / \   
| |_) | | | | | | | |_) |  / _ \  
|  __/| |_| | | | |  _ <  / ___ \ 
|_|    \___/  |_| |_| \_\/_/   \_\
CRYPTOGRAPHY TOOL
'@
    Write-Host "MAHASISWA BUKAN MAHA TAHU"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "[1] Caesar Cipher"
    Write-Host "[2] Vigenere Cipher"
    Write-Host "[3] XOR Cipher"
    Write-Host "[4] AES"
    Write-Host "[5] RSA"
    Write-Host "[6] Exit"
    Write-Host ""

    $choice =
        Read-Host "Select algorithm"

    switch ($choice) {

        "1" {
            Caesar-Cipher
        }

        "2" {
            Vigenere-Cipher
        }

        "3" {
            XOR-Cipher
        }

        "4" {
            AES-Tool
        }

        "5" {
            RSA-Tool
        }

        "6" {
            Clear-Host
            exit
        }

        default {

            Write-Host ""
            Write-Host "Invalid selection."
            Start-Sleep -Seconds 1
        }
    }
}