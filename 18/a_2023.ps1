<#
124052 - too high
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

$xTable = @{}
$yTable = @{}

$currentX = 1000
$currentY = 1000

$trash = $xTable.Add($currentX, [System.Collections.ArrayList]@($currentY))
$trash = $yTable.Add($currentY, [System.Collections.ArrayList]@($currentX))

foreach ($line in $strarray) { #draw borders
    $command = $line.Split(" ")

    $direction = $command[0]
    $distance = [int] [String] $command[1]

    for ($i = 1;$i -le $distance;$i++) {
        $newX = $currentX
        $newY = $currentY
        
        if ($direction -eq 'U') {
            $newY = $currentY - $i
        } elseif ($direction -eq 'D') {
            $newY = $currentY + $i
        } elseif ($direction -eq 'L') {
            $newX = $currentX - $i
        } elseif ($direction -eq 'R') {
            $newX = $currentX + $i
        }

        if ($xTable[$newX] -eq $null) {
            $trash = $xTable.Add($newX, [System.Collections.ArrayList]@($newY))
            
        } elseif ( -not $xTable[$newX].Contains($newY) ) { #Add new coordinate in
            $trash = $xTable[$newX].Add($newY)
        }

        if ($yTable[$newY] -eq $null) {
            $trash = $yTable.Add($newY, [System.Collections.ArrayList]@($newX))
        } elseif ( -not $yTable[$newY].Contains($newX) ) { #Add new coordinate in
            $trash = $yTable[$newY].Add($newX)
        }
    }

    $currentX = $newX
    $currentY = $newY
}

$xVals = $xTable.Keys | measure -Maximum -Minimum
$minX = $xVals.Minimum
$maxX = $xVals.Maximum

$yVals = $yTable.Keys | measure -Maximum -Minimum
$minY = $yVals.Minimum
$maxY = $yVals.Maximum

$fillXTable = @{}
#$fillYTable = @{}

for ($currX = [int] $minX + 1;$currX -lt $maxX;$currX++) {
    for ($currY = [int] $minY + 1;$currY -lt $maxY;$currY++) {
        
        $xVals = $xTable[$currX] | measure -Maximum -Minimum
        $yVals = $yTable[$currY] | measure -Maximum -Minimum

        #Write-Host "Range: $($yVals.Minimum) $currX $($yVals.Maximum) --- $($xVals.Minimum) $currY $($xVals.Maximum)" -NoNewline

        if (($xVals.Minimum -lt $currY) -and ($xVals.Maximum -gt $currY)) {
            if (($yVals.Minimum -lt $currX) -and ($yVals.Maximum -gt $currX)) {
                

                if ($fillXTable[$currX] -eq $null) {
                    #Write-Host " Hit" -NoNewline
                    $trash = $fillXTable.Add($currX, [System.Collections.ArrayList]@($currY))
            
                } elseif ( -not $xTable[$currX].Contains($currY) ) { #Add new coordinate in
                    #Write-Host " Hit" -NoNewline
                    $trash = $fillXTable[$currX].Add($currY)
                }
                <#
                #....#.#.
                ...######
                #######..
                .
                
                
                #....#...
                #....###.

                #>
                <#if ($yTable[$currY] -eq $null) {
                    $trash = $fillYTable.Add($currY, [System.Collections.ArrayList]@($currX))
                } else { #Add new coordinate in
                    $trash = $fillYTable[$currY].Add($currX)
                }#>
            }
        }
        #Write-Host ""
    }
}

foreach ($key in $xTable.Keys) {
    $answer += $xTable[$key].Count
}

foreach ($key in $fillXTable.Keys) {
    $answer += $fillXTable[$key].Count
}

Write-Host $answer