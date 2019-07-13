# install the prerequisites for the grammar building tools
try {
    # create modules folder if it doesn't exist
    if (-not (Test-Path modules -PathType Container)) {
        New-Item modules -ItemType Directory | Out-Null
    }

    # clean out any past copies of the build tool repositories
    if (Test-Path modules\PwshJSONtoPList -PathType Container) {
        Write-Progress 'Removing old PwshJSONtoPList module.'
        Remove-Item modules\PwshJSONtoPList -Recurse -Force
    }
    <#if (Test-Path modules\PwshOutCSON -PathType Container) {
        Write-Progress 'Removing old PwshOutCSON module.'
        Remove-Item modules\PwshOutCSON -Recurse -Force
    }#>

    # clone some prerequisite repositories that will help build the grammars
    git clone --depth 1 https://github.com/msftrncs/PwshJSONtoPList.git modules\PwshJSONtoPList
    #git clone --depth 1 https://github.com/msftrncs/PwshOutCSON.git modules\PwshOutCSON

} catch {
    throw # error occured, give it forward to the user
}