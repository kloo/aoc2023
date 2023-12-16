<#

#>

$strarray = Get-Content ina.txt
$answer = 0

$Ymax = $strarray.Length
$Xmax = $strarray[0].Length

Function Check-EnergizeTable {
    Param (
        [String] $inputCoords,
        [String] $inputDirection
    )

    if ($energizeTable[$inputCoords] -eq $null) { #Add new entry to energize list if not present
        $newArrayList = [System.Collections.ArrayList]::new()
        $trash = $newArrayList.Add($inputDirection)

        $energizeTable.Add($inputCoords,$newArrayList)
    } elseif (-not $energizeTable[$inputCoords].Contains($inputDirection)) {
        $trash = $energizeTable[$inputCoords].Add($inputDirection)
    } else { #Path has been run before
        return $false
    }

    return $true
}

#Directions: N E S W = 0 1 2 3

$beamQueue = [ordered] @{}
$beamQueue.Add("0,0,E",0)

$energizeTable = @{}

while ($beamQueue.Count -gt 0) {
    $currInstruction = $beamQueue.Keys | Select-Object -First 1
    
    $direction = $currInstruction[-1]
    $position = $currInstruction -replace ".{2}$" #Remove comma and direction

    $beamQueue.Remove($currInstruction)

    $currCoords = [int[]] [String[]] $position.Split(",")

    $fixedX = $currCoords[0]
    $fixedY = $currCoords[1]

    if ($direction -in ("N","S")) {
        $i = $fixedY
        $upperBound = $Ymax
    } else {
        $i = $fixedX
        $upperBound = $Xmax
    }

    while (($i -lt $upperBound) -and ($i -ge 0)) {
        
        if ($direction -in ("N","S")) {
            $currPoint = $strarray[$i][$fixedX]
        } else {
            $currPoint = $strarray[$fixedY][$i]
        }

        if ($currPoint -eq '.') { #Continue as normal tracking path

            if ($direction -in ("N","S")) {
                if (-not (Check-EnergizeTable "$fixedX,$i" $direction)) {
                    break
                }
            } else {
                if (-not (Check-EnergizeTable "$i,$fixedY" $direction)) {
                    break
                }
            }
                
        } elseif ($currPoint -eq '/') {
            if ($direction -eq "N") {
                $newDirection = "E"

                $check = Check-EnergizeTable "$fixedX,$i" $direction
                if ($check) {
                    $beamQueue.Add("$($fixedX + 1),$i,$newDirection",0)
                }
            } elseif ($direction -eq "S") {
                $newDirection = "W"

                $check = Check-EnergizeTable "$fixedX,$i" $direction
                if ($check) {
                    $beamQueue.Add("$($fixedX - 1),$i,$newDirection",0)
                }
            } elseif ($direction -eq "E") {
                $newDirection = "N"

                $check = Check-EnergizeTable "$i,$fixedY" $direction
                if ($check) {
                    $beamQueue.Add("$i,$($fixedY - 1),$newDirection",0)
                }
            } elseif ($direction -eq "W") {
                $newDirection = "S"

                $check = Check-EnergizeTable "$i,$fixedY" $direction
                if ($check) {
                    $beamQueue.Add("$i,$($fixedY + 1),$newDirection",0)
                }
            }
                
            break
        } elseif ($currPoint -eq '\') {
            if ($direction -eq "N") {
                $newDirection = "W"

                $check = Check-EnergizeTable "$fixedX,$i" $direction
                if ($check) {
                    $beamQueue.Add("$($fixedX - 1),$i,$newDirection",0)
                }
            } elseif ($direction -eq "S") {
                $newDirection = "E"

                $check = Check-EnergizeTable "$fixedX,$i" $direction
                if ($check) {
                    $beamQueue.Add("$($fixedX + 1),$i,$newDirection",0)
                }
            } elseif ($direction -eq "E") {
                $newDirection = "S"

                $check = Check-EnergizeTable "$i,$fixedY" $direction
                if ($check) {
                    $beamQueue.Add("$i,$($fixedY + 1),$newDirection",0)
                }
            } elseif ($direction -eq "W") {
                $newDirection = "N"

                $check = Check-EnergizeTable "$i,$fixedY" $direction
                if ($check) {
                    $beamQueue.Add("$i,$($fixedY - 1),$newDirection",0)
                }
            }
                
            break
        } elseif ($currPoint -eq '|') {
            if ($direction -in ("N","S")) {
                $check = Check-EnergizeTable "$fixedX,$i" "N" #Don't care what direction comes in to Splitters

                if ($check) {
                    $beamQueue.Add("$fixedX,$($i - 1),N",0)
                    $beamQueue.Add("$fixedX,$($i + 1),S",0)
                }
            } else {
                $check = Check-EnergizeTable "$i,$fixedY" "N" #Don't care what direction comes in to Splitters

                if ($check) {
                    $beamQueue.Add("$i,$($fixedY - 1),N",0)
                    $beamQueue.Add("$i,$($fixedY + 1),S",0)
                }
            }

            break
        } elseif ($currPoint -eq '-') {
            if ($direction -in ("N","S")) {
                $check = Check-EnergizeTable "$fixedX,$i" "N" #Don't care what direction comes in to Splitters

                if ($check) {
                    $beamQueue.Add("$($fixedX + 1),$i,E",0)
                    $beamQueue.Add("$($fixedX - 1),$i,W",0)
                }
            } else {
                $check = Check-EnergizeTable "$i,$fixedY" "N" #Don't care what direction comes in to Splitters

                if ($check) {
                    $beamQueue.Add("$($i + 1),$fixedY,E",0)
                    $beamQueue.Add("$($i - 1),$fixedY,W",0)
                }
            }

            break
        }

        if ($direction -in ("E","S")) { $i++ } else { $i-- }
    }

}

Write-Host $energizeTable.Count