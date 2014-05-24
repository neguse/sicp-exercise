#lang racket
; わからないので、とりあえず答えから見ていきますよ。
; http://www.billthelizard.com/2010/02/sicp-exercise-127-carmichael-numbers.html

; えーと、もともとのfermat-testが内部で乱数を作ってexpmodの引数にしていたのを、
; 外部から渡せるようにしてますね。
(define (fermat-test n a)
	(= (expmod a n n) a))

; その上で、n〜2までfermat-testする
; fermat-full関数を作ってますね。
(define (square x)
	(* x x))

(define (even? n)
	(= (remainder n 2) 0))

(define (expmod base exp m)
	(cond ((= exp 0) 1)
				((even? exp)
				 (remainder (square (expmod base (/ exp 2) m))
										m))
				 (else
					 (remainder (* base (expmod base (- exp 1) m))
											m))))

(define (fermat-full n)
	(define (iter a)
		(cond ((= a 1) #t)
					((not (fermat-test n a)) #f)
					(else (iter (- a 1)))))
	(iter (- n 1)))

(fermat-full 561)
(fermat-full 1105)
(fermat-full 1729)
(fermat-full 2465)
(fermat-full 2821)
(fermat-full 6601)

; はいぜんぶ#tですね。
; なんだ、これぐらいなら自分でもできるよ！(まけおしみ)
