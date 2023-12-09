<#

#>

$strarray = Get-Content ina.txt
$answer = 0

$inputCount = $strarray.Length
$cardCountTable = @{}

for ($i = 0;$i -lt $inputCount;$i++) {
    $cardCountTable.Add($i,1)
}


for ($i = 0;$i -lt $inputCount;$i++) {

    $winningNumbers = $strarray[$i].Split(":")[1]
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
        $currCardCount = $cardCountTable[$i]

        for ($j = 1;$j -le $winCount;$j++) {
            $nextCardIndex = $i + $j
            if ($nextCardIndex -lt $inputCount) {
                $cardCountTable[$nextCardIndex] += $currCardCount
            }
        }
    }
}

for ($i = 0;$i -lt $inputCount;$i++) {
    $answer += $cardCountTable[$i]
}

Write-Host $answer