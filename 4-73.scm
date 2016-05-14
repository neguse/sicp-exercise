
; まず、この問題文の定義だと返り値がstreamじゃなくなるから
; 他のコードとの整合性がおかしくなるんじゃないか。
; …と思ったけど、interleaveもstreamを返すんだった。

; https://github.com/ypeels/sicp/blob/master/exercises/4.73-delay-in-flatten-stream.scm
; 結局無限ループになるから、ということっぽいのだけど
; どうにも理解できてない。

