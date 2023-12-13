<#

#>

$strarray = Get-Content ina.txt
$answer = 0

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Find-ReflectionLine {
    Param (
        [String[]] $currPuzzle
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

        if ($foundReflection) {
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

 
    #Look for horizontal reflection
    $reflectionIndex = Find-ReflectionLine $puzzle

    #Look for vertical reflection
    if ($reflectionIndex -le 0) {
        $rotatedPuzzle = [String[]] @()
        for ($j = 0;$j -lt $puzzle[0].Length;$j++) {
            $newLine = ""
            for ($k = $puzzle.Length - 1;$k -ge 0;$k--) {
                $newLine += $puzzle[$k][$j]
            }

            $rotatedPuzzle += $newLine
        }


        $reflectionIndex = Find-ReflectionLine $rotatedPuzzle

        Write-Host "Vertical: $reflectionIndex"
        $answer += $reflectionIndex
    } else {
        Write-Host "Horizontal: $reflectionIndex"
        $answer += $reflectionIndex * 100
    }

    
}

Write-Host $answer