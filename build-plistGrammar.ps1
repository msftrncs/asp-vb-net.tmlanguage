# convert the VS Code JSON asp-vb-net grammar to the XML PList format grammar file the ASP-VB-NET TM Bundle repository uses.
try {
    # scope in a PList build tool
    . .\modules\PwshJSONtoPList\ConvertTo-PList.ps1

    # create output folder if it doesn't exist
    if (-not (Test-Path out -PathType Container)) {
        New-Item out -ItemType Directory | Out-Null
    }

    # from here on, we're converting the asp-vb-net.tmLanguage.JSON file to PLIST with hardcoded conversion requirements
    # start by reading in the file through ConvertFrom-JSON
    $grammar_json = Get-Content asp-vb-net.tmlanguage.json | ConvertFrom-Json

    # create the PList grammar template, supplying some data missing from the JSON file.
    $grammar_plist = [ordered]@{
        fileTypes     = @('vb')
        keyEquivalent = '^~A'
        uuid          = '7F9C9343-D48E-4E7D-BFE8-F680714DCD3E'
    }

    # add to the PList grammar, only the selected items from the JSON grammar.
    if ($grammar_json.comment) {
        # manually insert the `comment` key
        $grammar_plist.insert(0, 'comment', $grammar_json.comment)
        $InsertIndex = 3
    } else {
        $InsertIndex = 2
    }
    # note the keys are in reverse order from how they will appear.
    foreach ($key in  'scopeName', 'repository', 'patterns', 'injections', 'name') {
        if ($grammar_json.$key) {
            $grammar_plist.insert($InsertIndex, $key, $grammar_json.$key)
        }
    }

    # write the PList document.
    $grammar_plist | ConvertTo-Plist -Indent `t -StateEncodingAs UTF-8 -Depth 100 |
    Set-Content 'out\ASP VB.net.plist' -Encoding UTF8
} catch {
    throw # error occured, give it forward to the user
}