<#
Get seed ranges and translate to locations
#>

$strarray = Get-Content testin.txt
$answer = [int64]::MaxValue

$inputLen = $strarray.Length
$inputArray = New-Object String[] $inputLen

Function Get-TranslationBlock {
    Param (
        [int64] $startLine
    )

    $currLine = $startLine

    while (($strarray[$currLine] -ne "") -and ($currLine -lt $strarray.Length)) {
        $currLine++
    }
    
    return $currLine - 1
}

Function Translate-Block {
    Param (
        [int64[]] $inputArray #Array of Translation Block Number, Start Number, Range
    )

    $blockStart = $inputArray[0]*2
    $blockEnd = $blockStart + 1

    $blockStart = $translationBlocks[$blockStart]
    $blockEnd = $translationBlocks[$blockEnd]

    $startNum = $inputArray[1]
    $endNum = $startNum + $inputArray[2] - 1 # Subtract 1 to match exact range

    for ($j = $blockStart;$j -le $blockEnd;$j++) { # iterate through each line of a translation set
            $currLine = $strarray[$j].Split(" ")

            $dest = [int64] $currLine[0]
            $source = [int64] $currLine[1]
            $sourceEnd = $source + ([int64] $currLine[2]) - 1 # Subtract 1 to match exact range

            $coversLow = $source -le $startNum
            $coversHigh = $sourceEnd -ge $endNum
            
            $subsetLow = $coversLow -and ($sourceEnd -ge $startNum)
            $subsetHigh = $coversHigh -and ($source -le $endNum )

            $subsetCenter = ($source -le $endNum) -and ($sourceEnd -ge $startNum)

            if ( $coversLow -and $coversHigh ) { # If translation range encompasses full input range
                $queue
            } elseif ( $subsetLow ) { # If translation range covers lower end of input range
                
            } elseif ( $subsetHigh ) { # If translation range cover upper end of input range
                
            } elseif ( $subsetCenter ) { # If translation range covers some center subset of input range
                
            }
    }
}

$trash, $seeds = $strarray[0].Split(" ")
$seeds = [int64[]] $seeds

$queue = @()
$endQueue = @()

for ($i = 0; $i -lt $seeds.Length;$i+=2) {
    $queue += @(0,$seeds[$i],$seeds[$i+1])
}

$translationMapCount = 7
$translations = 0

$line = 3;
$translationBlocks = [int64[]] @()

while ($translations -lt $translationMapCount ) {

    $endLine = Get-TranslationBlock $line

    $translationBlocks += $line
    $translationBlocks += $endLine

    $line = $endLine + 3 #skip the blank line and header

    $translations++
}

while($queue.Count -gt 0) {
    Translate-Block $queue[0]
    
    if ($queue[0][2] -eq $null) { # Handle case of one array in 2d array crunching to 1d array
        $currArray = $queue[0]
        $queue = @()

        Translate-Block $currArray
    } else {
        Translate-Block $queue[0]
        $trash, $queue = $queue
    }
}

ForEach ($locationRange in $endQueue) {
    $min = $locationRange[1]

    if ($min -lt $answer) {
        $answer = $min
    }
}

Write-Host $answer