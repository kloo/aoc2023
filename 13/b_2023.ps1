<#
 Wrong: 29270 32000

 > 31415
 
#>

$strarray = Get-Content testin.txt
$answer = 0

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Find-ReflectionLine {
    Param (
        [String[]] $currPuzzle,
        [int] $changedPoint
    )
    
    $foundReflection = $false

    for ($j = 1;$j -lt $currPuzzle.Length;$j++) { #fold all rows

        $l = $j - 1
        for ($k = $j;($k -lt $currPuzzle.Length) -and ($l -ge 0);$k++) {
            if ($currPuzzle[$k] -eq $currPuzzle[$l]) {
                if (($k -eq $currPuzzle.Length - 1) -or ($l -eq 0)) {
                    $foundReflection = $true
                    break
                }
            } else {
                break
            }

            $l--
        }

        if (($l -le $changedPoint) -and ($k -ge $changedPoint) -and $foundReflection) {
            return $j
        }
    }

    return -1
}

$inputs = [int[]] @(0)

for ($i = 0;$i -lt $inputLen;$i++) {
    if ($strarray[$i] -eq "") {
        $inputs += $i - 1
        if ($i -lt $inputLen - 1) {
            $inputs += $i + 1
        }
    }
}

for ($i = 0;$i -lt $inputs.Length;$i += 2) {

    $puzzle = $strarray[$inputs[$i]..$inputs[$i + 1]]

    $found = $false
    for ($m = 0; $m -lt ($puzzle.Length * $puzzle[0].Length);$m++) {
        $foundReflection = $false
        
        
        
        $xCoord = $m % $puzzle[0].Length
        $yCoord = [math]::floor($m / $puzzle[0].Length)

        #Write-Host "$xCoord $yCoord"

        $replaceChar = '.'
        if ($puzzle[$yCoord][$xCoord] -eq $replaceChar) {
            $replaceChar = '#'
        }

        $newPuzzle = @() + $puzzle
        $newPuzzle[$yCoord] = $newPuzzle[$yCoord].Remove($xCoord,1).Insert($xCoord,$replaceChar)

        #Look for horizontal reflection
        $reflectionIndex = -1
        
        $reflectionIndex = Find-ReflectionLine $newPuzzle $yCoord
        

        #Look for vertical reflection
        if ($reflectionIndex -le 0) {
            $rotatedPuzzle = [String[]] @()
            for ($j = 0;$j -lt $newPuzzle[0].Length;$j++) {
                $newLine = ""
                for ($k = $newPuzzle.Length - 1;$k -ge 0;$k--) {
                    $newLine += $newPuzzle[$k][$j]
                }

                $rotatedPuzzle += $newLine
            }


            $reflectionIndex = Find-ReflectionLine $rotatedPuzzle $xCoord
            
            if ($reflectionIndex -gt 0) {
                Write-Host "Vertical: $reflectionIndex Index: $m Xmax: $($puzzle[0].Length)"
                $answer += $reflectionIndex
                $foundReflection = $true
            }
        } else {
            Write-Host "Horizontal: $reflectionIndex Index: $m Xmax: $($puzzle[0].Length)"
            $answer += $reflectionIndex * 100
            $foundReflection = $true
        }


        if ($foundReflection) {
            break
        }
        
    }
    
}

Write-Host $answer