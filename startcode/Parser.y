{
module Parser (parse) where

import LexParseCommon
import Lexer
}

%name parserAct
%tokentype {Token}
%error {parseError}
%monad {P}
%lexer {lexer} {TEOF}

%token
  cat           {TCat}
  one           {TOne}
  two           {TTwo}
  trigger       {TTrigger}
%%
Program : Endowments {$1}

Endowments:               {[]}
          | Result1       {result1}
          | Result2       {result2}



Result1 : one cat         {}
Result2 : two cat         {}

{
parseError _ = do
  lno <- getLineNo
  error $ "Parse error on line "++show lno

result1 = [([], 1)]
result2 = [([], 2)]

parse::String->[(String,Int)]
parse s = evalP parserAct s
}

