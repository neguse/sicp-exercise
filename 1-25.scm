; えーと、元のexpmodってどんなでしたっけ。
(define (expmod base exp m)
	(cond ((= exp 0) 1)
				((even? exp)
				 (remainder (square (expmod base (/ exp 2) m))
										m))
				(else
					(remainder (* base (expmod base (- exp 1) m))
										 m))))        

; はいこれ。
; で?これをfast-exptを使って書き換えたいと。

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (expmod-2 base exp m)
	(remainder (fast-expt base exp) m))

; はいブーですね。
; なんのためにexpとmodを一緒の関数でまとめてやってるか、
; というのを考えましょう。

; exptって、めちゃくちゃ数が大きくなっちゃうんですよ。
; で、計算機の数の数の扱い方は、普通は32bitとか64bitとかの
; ビット列で表現できる範囲をこえるのは無理なんですね。
; Pythonだとあふれる時に勝手に多倍長整数にしてくれたりするけど、まあおいておいて。

; Schemeのintがどんな数なのかあまりわかってないので、
; ちょっとみてみましょうか。
; > (+ 18446744073709551615 1)
; 18446744073709551616
; あれ? 64bitだとここであふれるはずなんですが、大丈夫そうですね。
; とすると平気なのかな…?

; ここでSchemeの仕様であるR7RSをみてみますか。
; http://milkpot.sakura.ne.jp/scheme/r7rs.pdf
; > 処理系は事実上無制限の大きさと精度を持つ正確な整数と正
; > 確な有理数とサポートし、上記の手続きと / 手続きを正確
; > な引数に対して必ず正確な結果を返すよう実装することが推
; > 奨されますが要求されません。
; うーん、ということは推奨どおりにちゃんとやってる処理系では
; メモリが許す限り正確な計算ができるっぽいですね。
; じゃあfast-exptでもよさそうですね。

