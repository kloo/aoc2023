<#

#>

$strarray = Get-Content ina.txt
$answer = 0

$inputLen = $strarray.Length
$inputArray = New-Object int[] $inputLen

Function Compute-NextRecursive {
    Param (
        [int[]] $intList
    )
    
    $allZero = $true
    forEach ($int in $intList) {
        if ($int -ne 0) {
            $allZero = $false
        }
    }

    if ($allZero) {
        return 0
    } else {
        $nextList = @()
        for ($i = 1;$i -lt $intList.Length;$i++) {
            $nextList += $intList[$i] - $intList[$i - 1]
        }

        return $intList[-1] + (Compute-NextRecursive $nextList)
    }
}

foreach ($line in $strarray) {
    $currLine = [int[]] $line.Split(" ")
    $nextVal = Compute-NextRecursive $currLine

    $answer += $nextVal
}

Write-Host $answer