<#
Get seeds and translate to locations
#>

$strarray = Get-Content ina.txt
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

$trash, $seeds = $strarray[0].Split(" ")
$seeds = [int64[]] $seeds

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

ForEach ($seed in $seeds) {

    $currPoint = $seed
    
    for ($i = 0;$i -lt $translationBlocks.Length;$i+=2) { # iterate through each translation set

        for ($j = $translationBlocks[$i];$j -le $translationBlocks[$i+1];$j++) { # iterate through each line of a translation set
            $currLine = $strarray[$j].Split(" ")

            $dest = [int64] $currLine[0]
            $source = [int64] $currLine[1]
            $sourceEnd = $source + ([int64] $currLine[2]) #goes 1 over actual range so use lt on comparison below

            if ( ($currPoint -ge $source) -and ($currPoint -lt $sourceEnd) ) {
                $currPoint = $dest + ($currPoint - $source)
                break;
            }
        }

    }

    if ($currPoint -lt $answer) {
        $answer = $currPoint
    }
}


Write-Host $answer