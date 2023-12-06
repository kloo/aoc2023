<#

#>

$strarray = Get-Content ina.txt
$answer = 1

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Test-Func {
    Param (
        [System.Collections.Specialized.OrderedDictionary] $playerOneDeck,
        [System.Collections.Specialized.OrderedDictionary] $playerTwoDeck
    )
    
}

$times = [int[]] $strarray[0].Split(" ")
$distances = [int[]] $strarray[1].Split(" ")


for($i = 0; $i -lt $times.Length;$i++) {
    $count = 0
    $currTime = $times[$i]
    $recordDistance = $distances[$i]

    for ($j = 1;$j -lt $currTime;$j++) {
        $moveTime = $currTime - $j
        $currDistance = $j * $moveTime

        if ( ($j * $moveTime) -gt $recordDistance ) {
            $count++
        }
    }

    $answer *= $count
}

Write-Host $answer