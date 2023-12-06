<#

#>

$strarray = Get-Content ina.txt
$answer = 0

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

foreach ($line in $strarray) {
    $firstNum = 0
    $lastNum = 0

    #Find first num
    $notFound = $true
    $pos = 0
    while ($notFound) {
        $currChar = $line[$pos]
        if ($currChar -like "[0-9]") {
            $firstNum = [int] [String] $currChar
            $notFound = $false
        }
        $pos++
    }

    #Find last num
    $notFound = $true
    $pos = $line.Length - 1
    while ($notFound) {
        $currChar = $line[$pos]
        if ($currChar -like "[0-9]") {
            $lastNum = [int] [String] $currChar
            $notFound = $false
        }
        $pos--
    }

    $currNum = (10*$firstNum) + $lastNum
    $answer += $currNum
}

Write-Host $answer