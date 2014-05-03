#lang racket

(define (f-recursive n)
  (cond
	((< n 3) n)
	(else (+
			(f-recursive (- n 1))
			(* 2 (f-recursive (- n 2)))
			(* 3 (f-recursive (- n 3)))))))

; まあ、これはちゃちゃっと書ける。
; 問題はiterativeの方で、こっちはどうやって変換すればいいんだろうか。
; とりあえず、書き下す感じでいくつか調べてみる
;
; f(0) => 0
; f(1) => 1
; f(2) => 2
; f(3) => f(2) + 2 * f(1) + 3 * f(0) = 2 + 2 + 0 = 4
; f(4) => f(3) + 2 * f(2) + 3 * f(1) = 4 + 4 + 3 = 11
; うーん、fibの式が3要素になった版ととらえればいいから、
; なんとなくa, b, cの3つの変数を用意してくるくる回していけばいい気がする

(define (f-iterative n)
  (if (< n 3)
	n
	(f-iter 2 1 0 (- n 2))))

(define (f-iter a b c count)
  (if (= count 0)
	a
	(f-iter
	  (+ a (* 2 b) (* 3 c))
	  a
	  b
	  (- count 1))))

; できた。
; SICPの例に出ているfibのやりかただと、
; fib(n+1)まで計算してからfib(n)の値を返しているのだけど、
; if文を使ってf(n)までで済むようにしてみた。
; 実際は余計に計算してても条件分岐しないSICPの書き方の方が速いとは思うけど…

(define (check n)
  (if (= n 0) #t
	(and
	  (= (f-recursive n) (f-iterative n))
	  (check (- n 1)))))

(check 30)

; うん、あってる。

