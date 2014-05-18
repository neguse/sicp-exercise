
; applicative orderについては、本文にあった通り
; (gcd 206 40)
; (gcd 40 (remainder 206 40))
; (gcd 40 6)
; (gcd 6 (remainder 40 6))
; (gcd 6 4)
; (gcd 4 (remainder 6 4))
; (gcd 4 2)
; (gcd 2 (remainder 4 2))
; (gcd 2 0)
; 2
; なので、remainderは4回

; normal orderについては…ちょっと考えてみたけど、ほとんど変わらないんじゃ?
; …ちょっとカンニングしたところ、だいぶ違うらしい。
; if文込みで展開する必要がありそう
;
; (gcd 206 40)
; (if (= 40 0) 206 (gcd 40 (remainder 206 40)))
; (gcd 40 (remainder 206 40))
; (if (= (remainder 206 40) 0) 40 (gcd (remainder 206 40) (remainder 40 (remainder 206 40)))) 
; <= ここでifのcond節にある(remainder 206 40)を計算
; (gcd (remainder 206 40) (remainder 40 (remainder 206 40)))
; (if (= (remainder 40 (remainder 206 40)) 0)
;   (remainder 206 40)
;   (gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))
; <= ここでifのcond節にある(remainder 40 (remainder 206 40))を計算
; (gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))
; (if (= (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 0)
;   (remainder 40 (remainder 206 40))
;   (gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))))
; <= ここでifのcond節にある(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))を計算
; (gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))
; (if (= (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) 0)
; 	(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
; 	(gcd (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) (remainder (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))))
; <= ここでifのcond節にある(remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))を計算
; (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
; 2
; つかれた…
;
; えーと、1 + 2 + 4 + 7 + 4 = 18回?
; Haskellとか遅延評価の言語はさすがにこんな評価のしかたはしないと思うんだけど、どうやってるんでしょうね。

