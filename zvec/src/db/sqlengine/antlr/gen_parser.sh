#!/bin/sh
#****************************************************************#
# ScriptName: gen_parser.sh
# Author: fancy.lf
# Function: command to generate antlr sql parser code in se directory
#***************************************************************#

java -jar ../../../../../thirdparty/antlr/antlr-4.8-complete.jar -Dlanguage=Cpp -package antlr4 SQLLexer.g4 SQLParser.g4 -o gen
sed -i 's/\bu8"/"/g' gen/*.cc
