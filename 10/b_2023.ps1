<#

#>

$strarray = Get-Content testin.txt
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

#Part 2 addition
$queue = New-Object System.Collections.ArrayList #reset queue just in case

$line = $strarray[0] -replace ".","o"
for ($i = 0;$i -lt $Ymax;$i++) {
    $strarray[$i] = $line
}

#Set all of loop to x in map
foreach ($coord in $distanceTable.Keys) { 
    $currCoords = [int[]] [String[]] $coord.Split(",")
    $currX = $currCoords[0]
    $currY = $currCoords[1]

    $strarray[$currY] = $strarray[$currY].Remove($currX,1).Insert($currX,"x")
}

#Set all of border to x that isn't part of loop and queue for BFS
for ($i = 0; $i -lt $Xmax;$i++) {
    if ($strarray[0][$i] -eq 'o') {
        $trash = $queue.Add("$i,0")
        $strarray[0] = $strarray[0].Remove($i,1).Insert($i,"x")
    }

    $bottomY = $Ymax - 1
    if ($strarray[$bottomY][$i] -eq 'o') {
        $trash = $queue.Add("$i,$bottomY")
        $strarray[$bottomY] = $strarray[$bottomY].Remove($i,1).Insert($i,"x")
    }
}

for ($i = 0;$i -lt $Ymax;$i++) {
    if ($strarray[$i][0] -eq 'o') {
        $trash = $queue.Add("0,$i")
        $strarray[$i] = $strarray[$i].Remove(0,1).Insert(0,"x")
    }

    $rightX = $Xmax - 1
    if ($strarray[$i][$rightX] -eq 'o') {
        $trash = $queue.Add("$rightX,$i")
        $strarray[$i] = $strarray[$i].Remove($rightX,1).Insert($rightX,"x")
    }
}


#BFS to close all open area as 'x'
while ($queue.Count -gt 0) {
    $currCoords = $queue[0]
    $trash = $queue.RemoveAt(0)
    
    $currCoords = [int[]] [String[]] $currCoords.Split(",")
    $currX = $currCoords[0]
    $currY = $currCoords[1]

    $northY = $currY - 1
    $southY = $currY + 1
    $westX = $currX - 1
    $eastX = $currX + 1
    
    #check NESW
    if ($northY -ge 0) { #North
        #Write-Host "$currX,$northY"
        $nextPipe = $strarray[$northY][$currX]
        
        if ("$nextPipe" -eq 'o') {
            $nextCoord = "$currX,$northY"
            
            $strarray[$northY] = $strarray[$northY].Remove($currX,1).Insert($currX,"x")
            $trash = $queue.Add($nextCoord)
        }
    }
    if ($southY -lt $Ymax) { #South
        $nextPipe = $strarray[$southY][$currX]
        
        if ("$nextPipe" -eq 'o') {
            $nextCoord = "$currX,$southY"
            
            $strarray[$southY] = $strarray[$southY].Remove($currX,1).Insert($currX,"x")
            $trash = $queue.Add($nextCoord)
        }
    }
    if ($westX -ge 0) { #West
        $nextPipe = $strarray[$currY][$westX]

        if ("$nextPipe" -eq 'o') {
            $nextCoord = "$westX,$currY"

            $strarray[$currY] = $strarray[$currY].Remove($westX,1).Insert($westX,"x")
            $trash = $queue.Add($nextCoord)
        }
    }
    if ($eastX -lt $Xmax) { #East
        $nextPipe = $strarray[$currY][$eastX]

        if ("$nextPipe" -eq 'o') {
            $nextCoord = "$eastX,$currY"

            $strarray[$currY] = $strarray[$currY].Remove($eastX,1).Insert($eastX,"x")
            $trash = $queue.Add($nextCoord)
        }
    }


}



foreach ($line in $strarray) {
    $answer += ($line.ToCharArray() | Where-Object {$_ -eq 'o'} | Measure-Object).Count
}

Write-Host $answer