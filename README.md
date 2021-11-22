﻿
# Faust 2 Dplug Guide
## Requirements
- Install [DMD](https://dlang.org/download.html) or [LDC](https://github.com/ldc-developers/ldc/releases)
- Install [Faust](https://github.com/grame-cncm/faust/releases)
- Clone [Dplug](https://github.com/AuburnSounds/Dplug/wiki/Getting-Started) and build it with `dub` command
- On windows, copy `dplug-build` file to some directory in PATH environment

## transpiling faust dsp to Dplug dlang framework
Compile the dsp file in the `src` folder

`'faust -i -lang dlang -a dplug.d testm.dsp -o main.d'`

## basic UI implementation
**todo**

## Compilation to VST3
Compile the dsp file in the `src` folder

`dplug-build -c VST3 -a x86_64`
OR, if you installed DMD instead of LDC
`dplug-build --compiler dmd -c VST3 -a x86_64`
