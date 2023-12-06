<#

#>

$strarray = Get-Content ina.txt
#$answer = 1

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Test-Func {
    Param (
        [System.Collections.Specialized.OrderedDictionary] $playerOneDeck,
        [System.Collections.Specialized.OrderedDictionary] $playerTwoDeck
    )
    
}

$currTime = [int64] ($strarray[0] -replace '\s','')
$recordDistance = [int64] ($strarray[1] -replace '\s','')


<#for($i = 0; $i -lt $times.Length;$i++) {
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
} #>

$answer = 0
for ($j = 1;$j -lt $currTime;$j++) {
        $moveTime = $currTime - $j
        $currDistance = $j * $moveTime

        if ( ($j * $moveTime) -gt $recordDistance ) {
            $answer++
        } elseif ($answer -gt 0) {
            break;
        }
}

Write-Host $answer