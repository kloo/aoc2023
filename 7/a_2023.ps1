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

$handBetTable = @{}

foreach ($line in $strarray) {
    $hand,$bet = $line.Split(" ")
    $bet = [int64] $bet

    $cardCounts = @(0) * 13
    $cardString = ""

    for ($i = 0;$i -lt $hand.Length;$i++) {
        $card = $hand[$i]
        if ($card -eq 'A') {
            $cardCounts[1]++
            $cardString += "14"
        } elseif ($card -eq 'K') {
            $cardCounts[0]++
            $cardString += "13"
        } elseif ($card -eq 'Q') {
            $cardCounts[12]++
            $cardString += "12"
        } elseif ($card -eq 'J') {
            $cardCounts[11]++
            $cardString += "11"
        } elseif ($card -eq 'T') {
            $cardCounts[10]++
            $cardString += "10"
        } else {
            $cardCounts[ [int] [String] $card ]++
            $cardString += "0" + $card
        }
    }

    $cardCounts = $cardCounts | Sort -Descending
    $highCount = $cardCounts[0]
    if ($highCount -eq 5) { #5 of a kind
        $handValue = "7"
    } elseif ($highCount -eq 4) { #4 of a kind
        $handValue = "6"
    } elseif ($highCount -eq 3) {
        if ($cardCounts[1] -ge 2) { #Full House
            $handValue = "5"
        } else { #3 of a kind
            $handValue = "4"
        }
    } elseif ($highCount -eq 2) {
        if ($cardCounts[1] -ge 2) { #Two pair
            $handValue = "3"
        } else { #one pair
            $handValue = "2"
        }
    } else { #high card
        $handValue = "1"
    }

    $cardString = [int64] ($handValue + $cardString)

    $handBetTable.Add($cardString,$bet)
}

$winnerArray = ([int64[]] $handBetTable.Keys) | Sort
for ($i = 0;$i -lt $winnerArray.Length;$i++) {
    $answer += $handBetTable[$winnerArray[$i]] * ($i + 1)
}

Write-Host $answer