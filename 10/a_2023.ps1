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

$Ymax = $strarray.Length
$Xmax = $strarray[0].Length

$distanceTable = @{}
$queue = New-Object System.Collections.ArrayList

# Get coord of S
$foundS = $false
for ($i = 0;$i -lt $Ymax;$i++) {
    for ($j = 0;$j -lt $Xmax;$j++) {
        if ($strarray[$i][$j] -eq 'S') {

            $foundS = $true

            $startX = $j
            $startY = $i

            $addCoords = "$j,$i"

            $distanceTable.Add("$addCoords",0)

            $trash = $queue.Add($addCoords)

            break
        }
    }

    if ($foundS) {
        break
    }
}

while ($queue.Count -gt 0) {
    $currCoords = $queue[0]

    $trash = $queue.RemoveAt(0)
    
    $currDistance = [int] ($distanceTable[$currCoords] + 1)

    $currCoords = [int[]] [String[]] $currCoords.Split(",")
    $currX = $currCoords[0]
    $currY = $currCoords[1]

    $northY = $currY - 1
    $southY = $currY + 1
    $westX = $currX - 1
    $eastX = $currX + 1

    #Write-Host "$currX,$northY - $currX,$southY - $westX,$currY - $eastX,$currY"

    #check NESW
    if ($northY -ge 0) { #North
        #Write-Host "$currX,$northY"
        $nextPipe = $strarray[$northY][$currX]
        
        if ("$nextPipe" -in @('|','7','F')) {
            $nextCoord = "$currX,$northY"
            #Write-Host $nextCoord
            if ($distanceTable[$nextCoord] -eq $null) {
                $distanceTable.Add($nextCoord,$currDistance)
                $trash = $queue.Add($nextCoord)
            }
        }
    }
    if ($southY -lt $Ymax) { #South
        $nextPipe = $strarray[$southY][$currX]
        
        if ("$nextPipe" -in @('|','L','J')) {
            $nextCoord = "$currX,$southY"
            #Write-Host $nextCoord
            if ($distanceTable[$nextCoord] -eq $null) {
                $distanceTable.Add($nextCoord,$currDistance)
                $trash = $queue.Add($nextCoord)
            }
        }
    }
    if ($westX -ge 0) { #West
        $nextPipe = $strarray[$currY][$westX]

        if ("$nextPipe" -in @('-','L','F')) {
            $nextCoord = "$westX,$currY"
            #Write-Host $nextCoord
            if ($distanceTable[$nextCoord] -eq $null) {
                $distanceTable.Add($nextCoord,$currDistance)
                $trash = $queue.Add($nextCoord)
            }
        }
    }
    if ($eastX -lt $Xmax) { #East
        $nextPipe = $strarray[$currY][$eastX]

        if ("$nextPipe" -in @('-','J','7')) {
            $nextCoord = "$eastX,$currY"
            #Write-Host $nextCoord
            if ($distanceTable[$nextCoord] -eq $null) {
                $distanceTable.Add($nextCoord,$currDistance)
                $trash = $queue.Add($nextCoord)
            }
        }
    }

    #"$queue"
}



$answer = ($distanceTable.Values | Sort -Descending)[0]

Write-Host $answer