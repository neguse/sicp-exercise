#lang racket

(require r5rs)

(define (last-pair x)
  (if (null? (cdr x))
	x
	(last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define z (make-cycle (list 'a 'b 'c)))

(last-pair z)

; (cons 'a (cons 'b (cons 'c <ここに先頭のconsの参照が来る>)))
; という感じになるはず。
; last-pairを適用すると、cdrをたどりすぎていつまでもぐるぐるする。
