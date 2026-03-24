[String]$ModuleRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src\UofIBox'
Import-Module -Name $ModuleRoot

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\UofIBox\UofIBox.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }
}
