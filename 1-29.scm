#lang racket

(define (sum term a next b)
  (if (> a b)
	0
	(+ (term a)
	   (sum term (next a) next b))))

; わからん…
; 問題文でπ/4がどうたら〜って書いてあるけど、
; それがどうして汎用の積分関数になるのか
;
; ... 
;
; なんか日本語版がミスってるだけっぽい
; http://sicp.iijlab.net/fulltext/x131.html
; http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-12.html#%_sec_1.3.1
; これはひどい。確か前もこういうのあったよね。
; 数式とか間違ってると怖いから、pdf版も読むようにしよう。
; https://github.com/minghai/sicp-pdf

; えーと、元のintegralがこれ、と
(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
	 dx))

; で、今回のは
; h/3 ( y0 + 4y1 + 2y2 + 4y3 + 2y4 + ... + 2y(n-2) + 4y(n-1) + yn )

(define (integral-simpson f a b n)
  (define (inc x) (+ x 1))
  (define h (/ (- b a) n))
  (define (coeff k)
	(cond
	  ((odd? k) 4)
	  ((or (= k 0) (= k n)) 1)
	  (else 2)))
  (define (y k)
	(* (coeff k)
	   (f (+ a (* k h)))))
  (* (/ h 3) (sum y 0 inc n)))

(define (cube x)
  (* x x x))

(integral cube 0 1 0.01)
; 0.24998750000000042
(integral-simpson cube 0 1 100)
; 1/4
(integral cube 0 1 0.001)
; 0.249999875000001
(integral-simpson cube 0 1 1000)
; 1/4

; うむ、Simpsonの方は100の時点で既に1/4となっているので、
; 全然誤差ないっすね。

