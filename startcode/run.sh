#!/bin/bash
alex Lexer.x
happy Parser.y
ghc Main.hs
rm *.o
echo "Printing output..."
./Main
