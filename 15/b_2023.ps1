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

$boxMap = @{} #boxNum, @(label1, focal1, label2, focal2)
for ($i = 0;$i -lt 256;$i++) {
    $boxMap.Add($i,[System.Collections.ArrayList]::new())
}

foreach ($line in $strarray) {
    $commands = $line.Split(",")

    foreach ($entry in $commands) {
        $hash = 0
        $isAdd = $false

        if ($entry.Contains('=')) {
            $labelEnd = $entry.IndexOf('=')
            $isAdd = $true
        } else {
            $labelEnd = $entry.IndexOf('-')
        }

        $label = $entry.Substring(0,$labelEnd)

        for ($i = 0;$i -lt $label.Length;$i++) {
            $hash += [byte][char] $label[$i]
            $hash *= 17
            $hash = $hash % 256
        }

        $boxContains = $boxMap[$hash].Contains($label)
        if ($isAdd) { #Add in box
            $focalLength = [int] $entry.Substring($labelEnd + 1)

            if ($boxContains) { #Replace Value
                $focalIndex = $boxMap[$hash].IndexOf($label) + 1
                $trash = $boxMap[$hash].RemoveAt($focalIndex)
                $trash = $boxMap[$hash].Insert($focalIndex,$focalLength)
            } else { #Append Values
                $trash = $boxMap[$hash].Add($label)
                $trash = $boxMap[$hash].Add($focalLength)
            }

        } else { #Remove from box
            if ($boxContains) { #Replace Value
                $labelIndex = $boxMap[$hash].IndexOf($label)
                $trash = $boxMap[$hash].RemoveAt($labelIndex) #Remove label
                $trash = $boxMap[$hash].RemoveAt($labelIndex) #Remove focalLength
            }
        }
    }
}

for ($i = 0;$i -lt 256;$i++) {
    if ($boxMap[$i].Count -gt 0) {
        $boxNum = $i + 1

        $boxArray = $boxMap[$i]
        
        for ($j = 1;$j -lt $boxArray.Count;$j += 2) {
            $focalLength = $boxArray[$j]
            $boxPos = ($j + 1) / 2

            #Write-Host "$boxNum * $boxPos * $focalLength"
            $answer += $boxNum * $boxPos * $focalLength
        }
    }
}

Write-Host $answer