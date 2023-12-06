<#

#>

$strarray = Get-Content testin.txt
$answer = 0

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Test-Func {
    Param (
        [System.Collections.Specialized.OrderedDictionary] $playerOneDeck,
        [System.Collections.Specialized.OrderedDictionary] $playerTwoDeck
    )
    
}

$numStrArray = @("one","two","three","four","five","six","seven","eight","nine")
$revNumStrArray = @()
foreach ($num in $numStrArray) {
    $numLength = $num.Length * -1
    $revNumStrArray += $num[-1..$numLength] -join ''
}


foreach ($line in $strarray) {
    $firstNum = 0
    $lastNum = 0

    #Find first num
    $notFound = $true
    $pos = 0
    while ($notFound) {
        $currChar = $line[$pos]
        if ($currChar -like "[0-9]") {
            $firstNumChar = [int] [String] $currChar
            $firstNumCharPos = $pos
            $notFound = $false
        }
        $pos++
    }

    $firstNumStrPos = $line.Length
    foreach ($num in $numStrArray) {
        $currNum = 1
        $pos = $line.IndexOf($num)
        if ( ($pos -gt -1) -and ($pos-lt $firstNumStrPos)) {
            $firstNumStrPos = $line.IndexOf($num)
            $firstNumStr = $currNum
        }
        $currNum++
    }

    if ($firstNumCharPos -lt $firstNumStrPos) {
        $firstNum = $firstNumChar
    } else {
        $firstNum = $firstNumStr
    }

    #Find last num
    $notFound = $true
    $pos = $line.Length - 1
    while ($notFound) {
        $currChar = $line[$pos]
        if ($currChar -like "[0-9]") {
            $lastNumChar = [int] [String] $currChar
            $lastNumCharPos = $pos
            $notFound = $false
        }
        $pos--
    }
    $lastNumCharPos = $line.Length - $lastNumCharPos

    $revLine += $line[-1..(-$line.Length)] -join ''

    $lastNumStrPos = $line.Length
    foreach ($num in $revNumStrArray) {
        $currNum = 1
        $pos = $revLine.IndexOf($num)
        if (($pos -gt -1) -and ($pos -lt $lastNumStrPos)) {
            $lastNumStrPos = $revLine.IndexOf($num)
            $lastNumStr = $currNum
        }
        $currNum++
    }

    if ($lastNumCharPos -lt $lastNumStrPos) {
        $lastNum = $lastNumChar
    } else {
        $lastNum = $lastNumStr
    }


    WRite-Host "$firstNumCharPos : $firstNumChar , $firstNumStrPos : $firstNumStr , $lastNumCharPos : $lastNumChar , $lastNumStrPos : $lastNumStr"
    $currNum = (10*$firstNum) + $lastNum
    Write-Host $currNum
    $answer += $currNum
}

Write-Host $answer