#lang racket
(require r5rs)

; or-gate は、どちらかの入力が1なら1になるやつ

(define (or-gate a1 a2 output)
  (define (or-action-procedure)
	(let ((new-value
			(logical-or (get-signal a1) (get-signal a2))))
	  (after-delay or-gate-delay
				   (lambda ()
					 (set-signal! output new-value)))))
  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok)

; and-gateを適当にor-gateっぽく識別子なおしただけだけど、
; 動くのかどうかわからん
; というか、logical-andとかlogical-orって定義されてるんですか?
; …どうも自前で定義する必要がありそう
; さらに答えちょっと見た感じだと、入力が0でも1でもない場合はエラー返したほうがよさそう

(define (logical-or a1 a2)
  (cond
	((and (= a1 0) (= a2 0)) 0)
	((and (= a1 1) (= a2 0)) 1)
	((and (= a1 0) (= a2 1)) 1)
	((and (= a1 1) (= a2 1)) 1)
	(else
	  (error "Invalid Signal OR" a1 a2))))

; こんなところでしょうか

