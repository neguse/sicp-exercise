#lang racket

; 今回もなんとなく実装でいきます

(define (=zero? x)
  (apply-generic '=zero? x))

(define (=zero-poly? x)
  (=zero-termlist? (term-list x)))

(define (=zero-termlist? x)
  (or
	(empty-termlist? x)
	(and
	  (= 0 (coeff (first-term x)))
	  (=zero-termlist? (rest-terms x)))))

; なるほど、=zero-termlist?はemptyに対して呼ばれることもあるから
; まずemptyかを調べて、その後再帰で見ていくようにしないとだめですね。
	
