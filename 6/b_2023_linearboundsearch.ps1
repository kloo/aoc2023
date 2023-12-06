<#

#>

$strarray = Get-Content ina.txt

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

$answer = 0
$lowerBound = 0
$upperBound = 0
#Get Lower Bound
for ($j = 1;$j -lt $currTime;$j++) {
        $moveTime = $currTime - $j
        $currDistance = $j * $moveTime

        if ( ($j * $moveTime) -gt $recordDistance ) {
            $lowerBound = $j
            break;
        }
}

for ($j = $currTime - 1;$j -gt $lowerBound;$j--) {
        $moveTime = $currTime - $j
        $currDistance = $j * $moveTime

        if ( ($j * $moveTime) -gt $recordDistance ) {
            $upperBound = $j
            break;
        }
}

$answer = $upperBound - $lowerBound + 1

Write-Host $answer