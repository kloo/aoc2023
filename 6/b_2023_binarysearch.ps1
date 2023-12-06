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
$notFound = $true
[int64] $currPressTime = $currTime/2
$prevPressTime = 0
$tempUpperBound = $currTime
$tempLowerBound = 1

While ($notFound) {
        $currMoveTime = $currTime - $currPressTime
        $currDistance = $currPressTime * $currMoveTime
        
        $belowMoveTime = $currmoveTime + 1
        $belowPressTime = $currPressTime - 1

        $currRecordBreak = ($currPressTime * $currMoveTime) -gt $recordDistance
        $belowNotRecordBreak = ($belowPressTime * $belowMoveTime) -lt $recordDistance

        if ( $currRecordBreak -and $belowNotRecordBreak ) {
            $lowerBound = $currPressTime
            $notFound = $false
        } elseif ($currRecordBreak) { #Go lower
            $nextPressTime = ($currPressTime + $tempLowerBound)/2
            $prevPressTime = $currPressTime
            $tempUpperBound = $currPressTime
        } else { #Go higher
            $nextPressTime = ($currPressTime + $tempUpperBound) / 2
            $prevPressTime = $currPressTime
            $tempLowerBound = $currPressTime
        }
        $currPressTime = $nextPressTime
}

#Get Upper Bound
$notFound = $true
$currPressTime = $currTime/2
$prevPressTime = $currPressTime
$tempUpperBound = $currTime
$tempLowerBound = 1

While ($notFound) {
        $currMoveTime = $currTime - $currPressTime
        $currDistance = $currPressTime * $currMoveTime
        
        $nextMoveTime = $currmoveTime - 1
        $nextPressTime = $currPressTime + 1

        $currRecordBreak = ($currPressTime * $currMoveTime) -gt $recordDistance
        $nextNotRecordBreak = ($nextPressTime * $nextMoveTime) -lt $recordDistance

        if ( $currRecordBreak -and $nextNotRecordBreak ) {
            $upperBound = $currPressTime
            $notFound = $false
        } elseif ($currRecordBreak) { #Go higher
            $nextPressTime = ($currPressTime + $tempUpperBound) / 2
            $prevPressTime = $currPressTime
            $tempLowerBound = $currPressTime
        } else { #Go lower
            $nextPressTime = ($currPressTime + $tempLowerBound)/2
            $prevPressTime = $currPressTime
            $tempUpperBound = $currPressTime
        }
        $currPressTime = $nextPressTime
}

$answer = $upperBound - $lowerBound + 1
Write-Host $answer