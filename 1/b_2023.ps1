<#

#>

$strarray = Get-Content ina.txt
$answer = 0

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Find-FirstNum {
    Param (
        [String] $inputLine
    )

    for ($i = 0; $i -lt $inputLine.Length;$i++) {
        $inputString = [String] $inputLine[$i]
        if ($inputString -like "[0-9]") {
            return [int[]] @($i,$inputString)
        }
    }
    
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

    $firstNumCharPos,$firstNumChar = Find-FirstNum $line

    $firstNumStrPos = $line.Length
    $currNum = 1
    foreach ($num in $numStrArray) {
        $pos = $line.IndexOf($num)
        if ( ($pos -gt -1) -and ($pos-lt $firstNumStrPos)) {
            $firstNumStrPos = $pos
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
    $revLine = $line[-1..(-$line.Length)] -join ''
    
    $lastNumCharPos,$lastNumChar = Find-FirstNum $revLine
    
    $lastNumStrPos = $line.Length
    $currNum = 1
    foreach ($num in $revNumStrArray) {
        $pos = $revLine.IndexOf($num)
        if (($pos -gt -1) -and ($pos -lt $lastNumStrPos)) {
            $lastNumStrPos = $pos
            $lastNumStr = $currNum
            #Write-Host "$pos $currNum"
        }
        $currNum++
    }

    if ($lastNumCharPos -lt $lastNumStrPos) {
        $lastNum = $lastNumChar
    } else {
        $lastNum = $lastNumStr
    }


    Write-Host "$line ... $firstNumCharPos : $firstNumChar , $firstNumStrPos : $firstNumStr , $lastNumCharPos : $lastNumChar , $lastNumStrPos : $lastNumStr"
    $currNum = (10*$firstNum) + $lastNum
    #Write-Host $currNum
    $answer += $currNum
}

Write-Host $answer