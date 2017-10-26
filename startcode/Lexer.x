{
module Lexer (lexer)  where

import LexParseCommon
import Control.Monad.State
}

tokens :-

<0>         $white+           ;
<0>         cat               {plainTok TCat}

<0>         mystery           {plainTok TOne}
<case_1>    mystery           {plainTok TTwo}

<0>         trigger           {plainTok TTrigger}

{
type LexAction = Int->String->P (Maybe Token)

plainTok::Token->LexAction
plainTok t _ _ = return (Just t)

textTok::(String->Token)->LexAction
textTok cons _ s = return $ Just (cons s)




readToken::P Token
readToken = do
  s <- get
  case alexScan (input s) (lexSC s) of
    AlexEOF -> return TEOF
    AlexError inp' -> error $ "Lexical error on line "++(show $ ailineno inp')
    AlexSkip inp' _ -> do
      put s{input = inp'}
      readToken
    AlexToken inp' n act -> do
      let (AlexInput{airest=buf}) = input s
      put s{input = inp'}
      res <- act n (take n buf)
      case res of
        Nothing -> readToken
        Just t -> return t

lexer::(Token->P a)->P a
lexer cont = do
  tok <- readToken
  cont tok
}
