<#
 > 99836
#>

$strarray = Get-Content ina.txt
$answer = 0

$Ymax = $strarray.Length
$Xmax = $strarray[0].Length

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

#Roll North
$strarray = Roll-RocksUp $strarray


for ($i = 0;$i -lt $Ymax;$i++) {
    for ($j = 0;$j -lt $Xmax;$j++) {
        if ($strarray[$i][$j] -eq 'O') {
            $answer += $Ymax - $i
        }
    }
}


Write-Host $answer