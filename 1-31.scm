#lang racket

; これ、掛け算にするだけですよね。
; …と思ったら単位元を1にする必要があった。

(define (product term a next b)
  (if (> a b)
	1
	(* (term a)
	   (product term (next a) next b))))

(define (product2 term a next b)
  (define (iter a result)
	(if (> a b)
	  result
	  (iter (next a) (* result (term a)))))
  (iter a 1))

; はい。
; 問題bもついでに解いてあります。

(define (ident x) x)

(define (inc x)
  (+ x 1))


; factorialはこんなもんで。そのまんまですね。
(define (factorial n)
  (product ident 1 inc n))

(factorial 10)

; πの計算の方は…ちょっとわからないですね。
; productとsumをどっちも使っていいならいけそうだけど…
; …って！これもHTML版だと式間違ってるじゃないですか！
; まったくもー！

(define (pi n)
  (define (num n)
	(* 2 (+ 1 (floor (/ (+ 1 n) 2)))))
  (define (denom n)
	(+ 1 (* 2 (+ 1 (floor (/ n 2))))))
  (define (f n)
	(/ (num n) (denom n)))
  (* 4 (product f 0 inc n)))

(pi 100)
; 200867255532373784442745261542645325315275374222849104412672/64249161716620373460843064181220845545337380321779613660047
; なんすかこの巨大な分数
; 3.12637939804	
; でした。
; よしよし。

