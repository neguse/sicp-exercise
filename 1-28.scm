#lang racket

; アルゴリズムを日本語で説明されても…という気がする
; 擬似コードなり、プログラミング言語なりで説明してくれ
; (それだと問題にならないけど…)
; 途中までは自分でやってみたけど、なんかうまく動かんので結局カンニングした

(define (square x) (* x x))

(define (expmod-signal base exp m)
  (cond ((= exp 0) 1)
		((and
		   (not (or (= base 1) (= base (- m 1))))
		   (= (remainder (square base) m) 1))
		   0)
        ((even? exp)
         (remainder (square (expmod-signal base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod-signal base (- exp 1) m))
                    m))))      

(define (miller-rabin-test n)
	(define (try-it a)
		(= (expmod-signal a (- n 1) n) 1))
	(try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
	(cond ((= times 0) true)
				((miller-rabin-test n) (fast-prime? n (- times 1)))
				(else #f)))

; Carmichael numberというのが、Fermat Testを通過する擬素数だそうです。
; http://www.billthelizard.com/2010/03/sicp-exercise-128-miller-rabin-test.html
; とりあえずこれらは全部#fとなってので、よしよし。
(fast-prime? 561 100)
(fast-prime? 1105 100)
(fast-prime? 1729 100)
(fast-prime? 2465 100)
(fast-prime? 2821 100)
(fast-prime? 6601 100)

; ここからは適当な素数
; ぜんぶ#tになったので、よしよし。
(fast-prime? 67979 100)
(fast-prime? 171251 100)
(fast-prime? 9993821 100)


