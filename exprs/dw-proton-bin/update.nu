#!/usr/bin/env nu

let source_path = ($env.FILE_PWD | path join "source.json")
mut source = open $source_path

let release = http get "https://dawn.wine/api/v1/repos/dawn-winery/dwproton/releases/latest"
let version = ($release.tag_name | str replace "dwproton-" "")

if ($source.version != $version) {
  let url = $"https://dawn.wine/dawn-winery/dwproton/releases/download/dwproton-($version)/dwproton-($version)-x86_64.tar.xz"
  let hash = (^nix store prefetch-file --json --unpack $url | from json).hash

  $source = {
    version: $version,
    url: $url,
    hash: $hash,
  }

  print $"dw-proton-bin: updated to ($version)"
}

$source | to json | save -f $source_path
