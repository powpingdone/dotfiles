{runCommand}:
runCommand "ppd-doomdir" {} ''
  cp -r ${../../.doom.d} $out/
''
