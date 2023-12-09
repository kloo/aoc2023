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
    $currLine = $line.Split(":")
    $trash,$gameNum = $currLine[0].Split(" ")

    $reveals = $currLine[1].Split(" ")

    $validGame = $true
    for ($i = 1;$i -lt $reveals.Length;$i += 2) {
        $count = [int64] $reveals[$i]
        $color = $reveals[$i + 1]

        if ($color.Contains("red")) {
            if ($count -gt 12) {
                $validGame = $false
            }
        } elseif ($color.Contains("blue")) {
            if ($count -gt 14) {
                $validGame = $false
            }
        } else { #Green
            if ($count -gt 13) {
                $validGame = $false
            }
        }
        
    }

    if ($validGame) {
        $answer += [int64] $gameNum
    }

}

Write-Host $answer