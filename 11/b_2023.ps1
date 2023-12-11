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

$Ymax = $strarray.Length - 1
$Xmax = $strarray[0].Length - 1

$emptyRows = @()
$emptyCols = @()

for ($i = 0;$i -le $Ymax;$i++) {
    for ($j = 0;$j -le $Xmax;$j++) {
        $currChar = $strarray[$i][$j]
        if ($currChar -eq '.') {
            if ($j -eq $Xmax) {
                $emptyRows += $i
                break
            }
        } else {
            break
        }
    }
}

for ($i = 0;$i -le $Xmax;$i++) {
    for ($j = 0;$j -le $Ymax;$j++) {
        $currChar = $strarray[$j][$i]
        if ($currChar -eq '.') {
            if ($j -eq $Ymax) {
                $emptyCols += $i
                break
            }
        } else {
            break
        }
    }
}

$galaxyTable = @{}

for ($i = 0;$i -le $Ymax;$i++) {
    for ($j = 0;$j -le $Xmax;$j++) {
        $currChar = $strarray[$i][$j]
        if ($currChar -eq '#') {
            $trueX = [int64] $j
            $trueY = $i
            
            for ($k = 0;$k -lt $emptyCols.Length;$k++) {
                if ($emptyCols[$k] -lt $j) {
                    $trueX += 999999
                } else {
                    break
                }

                
            }
            for ($k = 0;$k -lt $emptyRows.Length;$k++) {
                if ($emptyRows[$k] -lt $i) {
                    $trueY += 999999
                } else {
                    break
                }

                
            }

            $galaxyTable.Add("$trueX,$trueY","$j,$i")
        }
    }
}

$keyArray = [String[]] $galaxyTable.Keys
$keyCount = $keyArray.Length

$maxDistance = $Ymax + $Xmax

for ($i = 0;$i -lt ($keyCount - 1);$i++) {
    $currCoordStr = $keyArray[$i]

    $currCoord = [int[]] $currCoordStr.Split(",")
  
    #Find pair
    for ($j = $i + 1;$j -lt $keyCount;$j++) {
        $pairCoordStr = $keyArray[$j]
        $pairCoord = [int[]] $pairCoordStr.Split(",")

        $distance = [Math]::Abs($currCoord[0] - $pairCoord[0]) + [Math]::Abs($currCoord[1] - $pairCoord[1])

        $answer += $distance

        #Write-Host "$i $j - $currCoordStr - $pairCoordStr - $distance"
    }
}

Write-Host $answer