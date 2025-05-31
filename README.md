# Conf.dg

## Installation

1. Run `brew bundle check` to check dependencies
2. Run `brew bundle install` to install dependencies from `brewfile`
3. Run `chmod +x symlink.sh` to make it an executable
4. Run `./symlink.sh` to symlink ghostty, zshrc, starshipl and nvim
5. Ready to go

## Monaspace Font Lingatures

```
// FROM https://github.com/githubnext/monaspace/issues/293
// ! " # $ % & ' ( ) * + , - . / 0 1 2 3 4 5 6 7 8 9 : ; < = > ? @
// A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ] ^ _ `
// a b c d e f g h i j k l m n o p q r s t u v w x y z { | } ~
//
// liga: ... ;;; ;; /// // || !!
//
// ss01 (Equal Symbols): === !== =!= =/= /== /= #= &= == != ~~ =~ !~ ~- -~
// ss02 (Comparisons): >= <=
// ss03 (Arrows): <--> <!-- <-- --> <-> <- -> <~~ ~~> <~> <~ ~>
// ss04 (HTML Tags): </> </ /> <>
// ss05 (F# Shapes): /\ \/ <|> |> <| [| |] {| |}
// ss06 (Markdown Strings): ++ +++ ## ### ==== && &&&
// ss07 (Centered Colon): :*: :-: :­–: :—: :+: ­:−: :×: :÷: :=: :≠: :>: :<: :≥: :≤: :±: :≈: :~: :¬: :∞: :-->: :->:
//                        :!=: :!==: :!~: :#=: :/=: :/==: :/>: :|>: :=!=: :==: :===: :==>: :=>: :=>>: :=<<: :=~:
//                        :=/=: :>=: :>>: :>>=: :<-: :<--: :<-->: :<->: :<!--: :<|: :<=: :<==: :<==>: :<=>: :<>:
//                        :<<: :<<=: :<~: :<~>: :<~~: :</: :</>: :~>: :~~: :~~>: -:; ;:- ::: ::
// ss08 (Centered Period): ..= ..- ..< .- .= ..
// ss09 (Double Arrows): <==> <== ==> <<= =>> =<< >>= << >> <=> =>
// ss10 (Other Tags): #[ #(
//
// cv01 (Alt Zero): 0
// cv02 (Alt One): 1
// cv10 (Alt Small L/I): l ĺ ľ ļ ŀ ł i í ĭ î ï ị ì ī į ĳ
// cv11 (Alt Small J/F/R/T): j ȷ ĵ f r ŕ ř ŗ t ŧ ť ţ ț
// cv30 (Raised Asterisk): *
// cv31 (Six-Pointed Asterisk): *
// cv32 (Angled Comparisons): >= <=
// cv60 (Left Double Arrow): <=
// cv61 (Empty Box): []
// cv62 (At-Underscore): @_
```
