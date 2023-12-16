<#

#>

$strarray = Get-Content testin.txt
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
$beamQueue.Add("0,0,1",0)

$energizeTable = @{}

while ($beamQueue.Count -gt 0) {
    if ($beamQueue.Count -eq 1) {
        $currInstruction = $beamQueue.Keys[0]
    } else {
        $currInstruction = $($beamQueue.Keys)[0]
    }
    
    $direction = $beamQueue[$currInstruction][-1]
    $position = $beamQueue[$currInstruction] -replace ".{2}$" #Remove comma and direction

    $beamQueue.Remove($currInstruction)

    if ( ($energizeTable[$position] -ne $null) -and $energizeTable[$position].Contains($direction) ) { #Already went this direction from this node
        continue
    } else { #Run path

        $currCoords = [int[]] [String[]] $position.Split(",")

        $fixedX = $currCoords[0]
        $fixedY = $currCoords[1]

        if ($direction -eq "0") { #North
            for ($i = $fixedY;$i -ge 0;$i++) {
                $currPoint = $strarray[$i][$fixedX]
                
                if ($currPoint -eq '.') { #Continue as normal tracking path

                    if (Check-EnergizeTable "$fixedX,$i" $direction) {
                        continue
                    } else {
                        break
                    }
                    
                } elseif ($currPoint -eq '/') {
                    $newDirection = "1"
                    $beamQueue.Add("$($fixedX + 1),$i,$newDirection",0)
                    $trash = Check-EnergizeTable "$fixedX,$i" $direction
                    break
                } elseif ($currPoint -eq '\') {
                    $newDirection = "3"
                    $beamQueue.Add("$($fixedX - 1),$i,$newDirection",0)
                    $trash = Check-EnergizeTable "$fixedX,$i" $direction
                    break
                } elseif ($currPoint -eq '|') { 
                    $check = Check-EnergizeTable "$fixedX,$i" "0" #Don't care what direction comes in to Splitters

                    if ($check) {
                        $beamQueue.Add("$fixedX,$($i - 1),0",0)
                        $beamQueue.Add("$fixedX,$($i + 1),2",0)
                    }

                    break
                } elseif ($currPoint -eq '-') {
                    $check = Check-EnergizeTable "$fixedX,$i" "0" #Don't care what direction comes in to Splitters

                    if ($check) {
                        $beamQueue.Add("$($fixedX + 1),$i,1",0)
                        $beamQueue.Add("$($fixedX - 1),$i,3",0)
                    }

                    break
                }
            }
        } elseif ($direction -eq "1") { #East
            for ($i = $fixedX;$i -lt $Xmax;$i++) {
                $currPoint = $strarray[$fixedY][$i]
                
                if ($currPoint -eq '.') { #Continue as normal tracking path
                    if (Check-EnergizeTable "$i,$fixedY" $direction) {
                        continue
                    } else {
                        break
                    }
                } elseif ($currPoint -eq '/') {
                    $newDirection = "0"
                    $beamQueue.Add("$i,$($fixedY - 1),$newDirection",0)
                    $trash = Check-EnergizeTable "$i,$fixedY" $direction
                    break
                } elseif ($currPoint -eq '\') {
                    $newDirection = "2"
                    $beamQueue.Add("$i,$($fixedY + 1),$newDirection",0)
                    $trash = Check-EnergizeTable "$i,$fixedY" $direction
                    break
                } elseif ($currPoint -eq '|') { 
                    $check = Check-EnergizeTable "$i,$fixedY" "0" #Don't care what direction comes in to Splitters

                    if ($check) {
                        $beamQueue.Add("$i,$($fixedY - 1),0",0)
                        $beamQueue.Add("$i,$($fixedY + 1),2",0)
                    }

                    break
                } elseif ($currPoint -eq '-') {
                    $check = Check-EnergizeTable "$i,$fixedX" "0" #Don't care what direction comes in to Splitters

                    if ($check) {
                        $beamQueue.Add("$($i + 1),$fixedY,1",0)
                        $beamQueue.Add("$($i - 1),$fixedY,3",0)
                    }

                    break
                }
            }
        } elseif ($direction -eq "2") { #South
             for ($i = $fixedY;$i -lt $Ymax;$i++) {
                $currPoint = $strarray[$i][$fixedX]
                
                if ($currPoint -eq '.') { #Continue as normal tracking path

                    if (Check-EnergizeTable "$fixedX,$i" $direction) {
                        continue
                    } else {
                        break
                    }
                    
                } elseif ($currPoint -eq '/') {
                    $newDirection = "3"
                    $beamQueue.Add("$($fixedX - 1),$i,$newDirection",0)
                    $trash = Check-EnergizeTable "$fixedX,$i" $direction
                    break
                } elseif ($currPoint -eq '\') {
                    $newDirection = "1"
                    $beamQueue.Add("$($fixedX + 1),$i,$newDirection",0)
                    $trash = Check-EnergizeTable "$fixedX,$i" $direction
                    break
                } elseif ($currPoint -eq '|') { 
                    $check = Check-EnergizeTable "$fixedX,$i" "0" #Don't care what direction comes in to Splitters

                    if ($check) {
                        $beamQueue.Add("$fixedX,$($i - 1),0",0)
                        $beamQueue.Add("$fixedX,$($i + 1),2",0)
                    }

                    break
                } elseif ($currPoint -eq '-') {
                    $check = Check-EnergizeTable "$fixedX,$i" "0" #Don't care what direction comes in to Splitters

                    if ($check) {
                        $beamQueue.Add("$($fixedX + 1),$i,1",0)
                        $beamQueue.Add("$($fixedX - 1),$i,3",0)
                    }

                    break
                }
            }
        } elseif ($direction -eq "3") { #West
            for ($i = $fixedX;$i -ge 0;$i--) {
                $currPoint = $strarray[$fixedY][$i]
                
                if ($currPoint -eq '.') { #Continue as normal tracking path
                    if (Check-EnergizeTable "$i,$fixedY" $direction) {
                        continue
                    } else {
                        break
                    }
                } elseif ($currPoint -eq '/') {
                    $newDirection = "2"
                    $beamQueue.Add("$i,$($fixedY + 1),$newDirection",0)
                    $trash = Check-EnergizeTable "$i,$fixedY" $direction
                    break
                } elseif ($currPoint -eq '\') {
                    $newDirection = "0"
                    $beamQueue.Add("$i,$($fixedY - 1),$newDirection",0)
                    $trash = Check-EnergizeTable "$i,$fixedY" $direction
                    break
                } elseif ($currPoint -eq '|') { 
                    $check = Check-EnergizeTable "$i,$fixedY" "0" #Don't care what direction comes in to Splitters

                    if ($check) {
                        $beamQueue.Add("$i,$($fixedY - 1),0",0)
                        $beamQueue.Add("$i,$($fixedY + 1),2",0)
                    }

                    break
                } elseif ($currPoint -eq '-') {
                    $check = Check-EnergizeTable "$i,$fixedX" "0" #Don't care what direction comes in to Splitters

                    if ($check) {
                        $beamQueue.Add("$($i + 1),$fixedY,1",0)
                        $beamQueue.Add("$($i - 1),$fixedY,3",0)
                    }

                    break
                }
            }
        }

    }
}

Write-Host $energizeTable.Count