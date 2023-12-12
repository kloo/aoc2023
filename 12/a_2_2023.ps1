<#
Mild performance increase on initial implementation by editing ?s in String only when needed and not doing a bunch of String replacements
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

foreach ($line in $strarray) {
    $arrangement = $line.Split(" ")
    $counts = $arrangement[1]
    $arrangement = [String] $arrangement[0]

    $unknownIndexes = @()
    for ($i = 0;$i -lt $arrangement.Length;$i++) {
        if ($arrangement[$i] -eq '?') {
            $unknownIndexes += $i
        }
    }

    $maxMask = [Math]::Pow(2,$unknownIndexes.Length)
    $currMask = 0

    for ($currMask = 0;$currMask -lt $maxMask;$currMask++) { # Generate all possible strings
        $currLine = $arrangement
        $binaryMask = [convert]::ToString($currMask,2)
        $binaryMask = $binaryMask[-1..-$binaryMask.Length] -join '' #Reverse mask

        <#for($i = 0;$i -lt $unknownIndexes.Length;$i++) {
            $replaceIndex = $unknownIndexes[$i]

            $replaceChar = '.'
            if ($binaryMask[$i] -eq '1') {
                $replaceChar = '#'
            }

            #Write-Host "$binaryMask $replaceIndex $replaceChar $i"

            $currLine = $currLine.Remove($replaceIndex,1).Insert($replaceIndex,$replaceChar)
        }#>

        $testCount = ""
        $inStreak = $false
        $currStreak = 0
        $questionIndex = 0
        for ($i = 0;$i -lt $currLine.Length;$i++) { #Test String
            $currChar = $currLine[$i]

            if ($currChar -eq '?') {
                $currChar = '.'
                if ($binaryMask[$questionIndex] -eq '1') {
                    $currChar = '#'
                }

                $questionIndex++
            }


            if ($inStreak -and ($currChar -eq '.')) { #End current streak and report
                $testCount += "$currStreak" + ","
                $inStreak = $false
                $currStreak = 0
            } elseif ($currChar -eq '#') { #Start Streak
                $inStreak = $true
                $currStreak++
            }
            
            if ($inStreak -and ($currChar -eq '#') -and ($i -eq ($currLine.Length - 1))) { #found # at end of line, end it
                $testCount += "$currStreak" + ","
            }
        }

        if($testCount[-1] -eq ',') {
            $testCount = $testCount.Remove($testCount.Length - 1,1) #Trim comma
        }
        
        #if ($testCount[0] -eq '3') {
            #Write-Host "$currLine $testCount $counts $binaryMask"
        #}

        if ($testCount -eq $counts) {
            $answer++
            #Write-Host "HIT"
        }
    }

    #Write-Host "$line - $answer"
}

Write-Host $answer