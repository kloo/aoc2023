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

    $redCount = 0
    $blueCount = 0
    $greenCount = 0


    for ($i = 1;$i -lt $reveals.Length;$i += 2) {
        $count = [int64] $reveals[$i]
        $color = $reveals[$i + 1]

        if ($color.Contains("red")) {
            if ($count -gt $redCount) {
                $redCount = $count
            }
        } elseif ($color.Contains("blue")) {
            if ($count -gt $blueCount) {
                $blueCount = $count
            }
        } else { #Green
            if ($count -gt $greenCount) {
                $greenCount = $count
            }
        }
        
    }

    $power = $redCount * $blueCount * $greenCount
    $answer += $power

}

Write-Host $answer