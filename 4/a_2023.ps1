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

foreach ($line in $strarray) {
    $winningNumbers = $line.Split(":")[1]
    $winningNumbers,$cardNumbers = $winningNumbers.Split("|")

    $winningNumbers = [int64[]] $winningNumbers.Trim().Replace("  "," ").Split(" ")
    $cardNumbers = [int64[]] $cardNumbers.Trim().Replace("  "," ").Split(" ")

    $winCount = 0
    foreach ($num in $winningNumbers) {
        if ($cardNumbers.Contains($num)) {
            $winCount++
        }
    }

    if ($winCount -gt 0) {
        Write-Host $winCount
        $answer += [Math]::Pow(2, $winCount - 1)
    }
}

Write-Host $answer