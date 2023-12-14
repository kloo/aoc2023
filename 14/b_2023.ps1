<#
 > 99836
#>

$strarray = Get-Content testin.txt
$answer = 0

$Ymax = $strarray.Length
$Xmax = $strarray[0].Length

<#Function Rotate-West {
    Param (
        [String[]] $rockarray
    )

    $rotatedArray = [String[]] @()
    for ($j = 0;$j -lt $Xmax;$j++) {
        $newLine = ""
        for ($k = $Ymax - 1;$k -ge 0;$k--) {
            $newLine += $rockarray[$k][$j]
        }

        $rotatedArray += $newLine
    }

    return $rotatedArray
}#>

Function Roll-RocksUp {
    Param (
        [String[]] $rockarray
    )

    for ($i = 1;$i -lt $Ymax;$i++) {
        for ($j = 0;$j -lt $Xmax;$j++) {

            if ($rockarray[$i][$j] -eq 'O') { #roll it north
                $rockarray[$i] = $rockarray[$i].Remove($j,1).Insert($j,'.') #Temporarily remove rock

                for ($k = $i - 1;$k -ge 0;$k--) {
                    if (($rockarray[$k][$j] -eq '.') -and ($k -gt 0)) {
                        continue
                    } elseif (($rockarray[$k][$j] -eq '.') -and ($k -eq 0)) { #Remove rock at $j,$i and put at $j,$k because rock reached the edge
                        $rockarray[$k] = $rockarray[$k].Remove($j,1).Insert($j,'O')
                    
                    } else { #Remove rock at $j,$i and put at $j,($k + 1) because $k is the blocking object
                        #Write-Host "$j,$i to $j,$k for $($rockarray.Length - ($k))"
                        $rockarray[$k + 1] = $rockarray[$k + 1].Remove($j,1).Insert($j,'O')
                    
                        break
                    }
                }
            }

        }
    }

    return $rockarray
}

#Roll North then rotate

$stateTable = @{}
$iterTable = @{}
$direction = 0 #N0,W1,S2,E3
for ($iter = 0;$iter -lt 1000000000;$iter++) {
    $strarray = Roll-RocksUp $strarray
    
    if ($stateTable[$strarray] -ne $null) { #found cycle
        break
    } else {
        $stateTable.Add($strarray,$iter)
        $iterTable.Add($iter,$strarray)
    }

    $strarray = Rotate-West $strarray

    $direction = ($direction + 1) % 4
}

#Break down cycle and find cycle 1B

$startOfCycle = $stateTable[$strarray]
$endPosition = 1000000000 - $startOfCycle

$cycleLength = $iter - $startOfCycle

$cyclePosition = $endPosition % $cycleLength

$strarray = $iterTable[$startOfCycle + $cyclePosition]

for ($i = $cyclePosition;($i % 4) -ne 0;$i++) {
    $strarray = Rotate-West $strarray
}


for ($i = 0;$i -lt $Ymax;$i++) {
    for ($j = 0;$j -lt $Xmax;$j++) {
        if ($strarray[$i][$j] -eq 'O') {
            $answer += $Ymax - $i
        }
    }
}


Write-Host $answer