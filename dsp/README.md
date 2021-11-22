## dsp compilation
this [faust](https://faustdoc.grame.fr/manual/compiler/) dsp can be transpiled to to  [D](https://dlang.org/) /  [Dplug](https://github.com/AuburnSounds/Dplug/ 
) with:
`faust -i -lang dlang -a dplug.d testm.dsp -o main.d`
