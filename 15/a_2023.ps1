<#

#>

$strarray = Get-Content ina.txt
$answer = 0

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Test-Func {
    Param (
        [System.Collections.Specialized.OrderedDictionary] $playerOneDeck,
        [System.Collections.Specialized.OrderedDictionary] $playerTwoDeck
    )
    
}

foreach ($line in $strarray) {
    $commands = $line.Split(",")

    foreach ($entry in $commands) {
        $tempAnswer = 0
        for ($i = 0;$i -lt $entry.Length;$i++) {
            $tempAnswer += [byte][char] $entry[$i]
            $tempAnswer *= 17
            $tempAnswer = $tempAnswer % 256
        }

        $answer += $tempAnswer
    }
}

Write-Host $answer